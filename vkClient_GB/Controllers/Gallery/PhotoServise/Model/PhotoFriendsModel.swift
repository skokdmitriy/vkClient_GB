//
//  PhotoFriendsModel.swift
//  VKClient
//
//  Created by Дмитрий Скок on 29.03.2022.
//

import Foundation

struct PhotoFriends: Codable {
    let response: ResponsePhoto
}

struct ResponsePhoto: Codable {
    let count: Int
    let items: [InfoPhotoFriend]
}

struct InfoPhotoFriend: Codable {
    var text: String
    var sizes: [Size]
    
    enum CodingKeys: String, CodingKey {
        case text
        case sizes
    }
}

struct Size: Codable {
    let url: String
    let type: SizeType
    
    enum SizeType: String, Codable{
        case m = "m"
        case o = "o"
        case p = "p"
        case q = "q"
        case r = "r"
        case s = "s"
        case w = "w"
        case x = "x"
        case y = "y"
        case z = "z"
    }
}

