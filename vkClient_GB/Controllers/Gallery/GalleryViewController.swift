//
//  GalleryViewController.swift
//  VKClient
//
//  Created by Дмитрий Скок on 23.10.2021.
//

import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    private let service = PhotoService()
    private let serviceImage = FriendsServiceManager()
    
    let reuseIdentifierGalleryCell = "reuseIdentifierGalleryCell"
    var fullScreenView: UIView?
    
    var infoPhotosFriend: [InfoPhotoFriend] = []
    var friendId = ""
    var storedImages: [String] = []
    var storedImagesZ: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GalleryCollectionCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifierGalleryCell)
        fetchPhotos()
        
    }
}
// MARK: UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierGalleryCell, for: indexPath) as? GalleryCollectionCell
        else {
            return UICollectionViewCell()
        }
        serviceImage.loadImage(url: storedImages[indexPath.item]) { image in
            cell.photoImageView.image = image
        }
        return cell
    }
}
// MARK: UICollectionViewDelegate
extension GalleryViewController: UICollectionViewDelegate {
    
 
    
}
//MARK: Private
private extension GalleryViewController {
    func sortImage(by sizeType: Size.SizeType, from array: [InfoPhotoFriend]) -> [String] {
        var imageLinks: [String] = []
        for model in array {
            for size in model.sizes {
                if size.type == sizeType {
                    imageLinks.append(size.url)
                }
            }
        }
        return imageLinks
    }
    
    func fetchPhotos() {
        service.loadPhoto(idFriend: friendId) { [weak self] model in
            guard let self = self else { return }
            switch model {
            case .success(let friendPhoto):
                self.infoPhotosFriend = friendPhoto
                let images = self.sortImage(by: .m, from: friendPhoto)
                self.storedImages = images
                let imagesZ = self.sortImage(by: .z, from: friendPhoto)
                self.storedImagesZ = imagesZ
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
//MARK: FullScreenView
    func showView(image: UIImage) {
        if fullScreenView == nil {
            fullScreenView = UIView(frame: self.view.safeAreaLayoutGuide.layoutFrame)
        }
        
        fullScreenView!.backgroundColor = UIColor.black
        self.view.addSubview(fullScreenView!)
        let tapRecognizer = UITapGestureRecognizer (target: self, action: #selector(onTap))
        fullScreenView?.addGestureRecognizer(tapRecognizer)
    
        let imageView = UIImageView(image: image)
        fullScreenView?.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: fullScreenView!.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: fullScreenView!.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: fullScreenView!.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: fullScreenView!.widthAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
    }
    
    @objc func onTap() {
        guard let fullScreenView = self.fullScreenView else {return}
        fullScreenView.removeFromSuperview()
        self.fullScreenView = nil
    }
}
