//
//  AllGroupsCell.swift
//  VKClient
//
//  Created by Дмитрий Скок on 29.05.2022.
//

import UIKit

class AllGroupsCell: UITableViewCell {
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    
    private let imageService = FriendsServiceManager()
    
    func configure(group: Group) {
        groupName.text = group.name
        imageService.loadImage(url: group.photo100) { [ weak self ] image in
            guard let self = self else { return }
            self.groupImage.image = image
        }
    }
//
    override func awakeFromNib() {
        super.awakeFromNib()
        
        groupImage.layer.cornerRadius = groupImage.frame.size.height * 0.5
        groupImage.layer.masksToBounds = true
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
