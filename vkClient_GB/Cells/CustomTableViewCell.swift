//
//  CustomTableViewCell.swift
//  VKClient
//
//  Created by Дмитрий Скок on 21.10.2021.
//

import UIKit

protocol CustomTableCellProtocol: AnyObject {
    func customTableCellLikeCounterIncrement(counter: Int)
    func customTableCellLikeCounterDecrement(counter: Int)
    func setCurrentCount(count: Int)
}

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var backView: UIView!
    @IBOutlet var likeView: LikeCounterView!
    
    weak var delegate: CustomTableCellProtocol?
    var completion: ((Friend) -> Void)?
    var friend: Friend?
    private let imageService = FriendsServiceManager()
    
    override func prepareForReuse() {
        avatarImageView.image = nil
        titleLabel.text = nil
        completion = nil
        friend = nil
    }
    
    func configure(friend: Friend, completion: ((Friend) -> Void)?) {
        self.completion = completion
        self.friend = friend
        titleLabel.text = friend.firstName
        likeView.delegate = self
    }
    
    func configure(group: Group) {
        titleLabel.text = group.name
        likeView.delegate = self
        imageService.loadImage(url: group.photo100) { [weak self] image in
            guard let self = self else { return }
            self.avatarImageView.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.size.height * 0.5
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.black.cgColor
        avatarImageView.contentMode = .scaleToFill
//        backView.layer.masksToBounds = true
//        backView.layer.cornerRadius = backView.frame.size.height * 0.5
//        backView.layer.shadowColor = UIColor.black.cgColor
//        backView.layer.shadowOffset = CGSize(width: 4, height: 4)
//        backView.layer.shadowRadius = 4
//        backView.layer.shadowOpacity = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    @IBAction func pressAvatarButton(_ sender: Any) {
//
//    let scale = CGFloat(18)
//
//        UIView.animate(withDuration: 2) { [weak self] in
//            guard let self = self else {return}
//            self.avatarImageView.frame = CGRect(x: self.avatarImageView.frame.origin.x + scale / 2,
//                                                y: self.avatarImageView.frame.origin.y + scale / 2,
//                                                width: self.avatarImageView.frame.width - scale,
//                                                height: self.avatarImageView.frame.height - scale)
//        } completion: { isSuccessfully in
//            UIView.animate(withDuration: 2,
//                           delay: 0,
//                           usingSpringWithDamping: 0.3,
//                           initialSpringVelocity: 0.7,
//                           options: []) { [weak self] in
//                guard let self = self else {return}
//                self.avatarImageView.frame = CGRect(x: self.avatarImageView.frame.origin.x + scale / 2,
//                                                    y: self.avatarImageView.frame.origin.y + scale / 2,
//                                                    width: self.avatarImageView.frame.width - scale,
//                                                    height: self.avatarImageView.frame.height - scale)
//
//            } completion: { [weak self] isAllSuccessfully in
//                guard let self = self else {return}
//                self.delegate?.setCurrentCount(count: 15)
//                if isAllSuccessfully,
//                   let friend = self.friend
//                {
//                    self.completion?(friend)
//                }
//            }
//        }
//    }
}

extension CustomTableViewCell: LikeCounterProtocol {
    func likeCounterIncrement(counter: Int) {
        delegate?.customTableCellLikeCounterIncrement(counter: counter)
    }
    
    func likeCounterDecrement(counter: Int) {
        delegate?.customTableCellLikeCounterDecrement(counter: counter)
    }
}



