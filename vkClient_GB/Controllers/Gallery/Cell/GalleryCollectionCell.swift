//
//  GalleryCollectionCell.swift
//  VKClient
//
//  Created by Дмитрий Скок on 23.10.2021.
//

import UIKit

class GalleryCollectionCell: UICollectionViewCell {
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var heartButton: UIButton!
    @IBOutlet var likeCounter: UILabel!
    
    var likeEnable = false
    var counter = 0
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView.image = nil
        likeEnable = false
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    func configure(image: UIImage){
        photoImageView.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func pressHeartButton(_ sender: Any) {
        guard let button = sender as? UIButton else {return}
        if likeEnable {
            button.setImage(UIImage(systemName: "heart"), for: .normal)
            counter -= 1
            likeCounter.text = String(counter)
        }
        else {
            button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            counter += 1
            likeCounter.text = String(counter)
        }
        
        UIView.transition(with: likeCounter,
                          duration: 0.3,
                          options: .transitionFlipFromTop,
                          animations: { [unowned self] in
                            self.likeCounter.text = String(counter)
        })
        
        likeEnable = !likeEnable
    }
}





