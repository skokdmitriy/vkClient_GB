//
//  FriendsSection.swift
//  VKClient
//
//  Created by Дмитрий Скок on 16.01.2022.
//

import Foundation

/// Раздел друзей
struct FriendsSection: Comparable {
    var key: Character
    var data: [Friend]
    
    static func < (ihs: FriendsSection, rhs: FriendsSection) -> Bool {
        return ihs.key < rhs.key
    }
    
    static func == (ihs: FriendsSection, rhs: FriendsSection) -> Bool {
        return ihs.key < rhs.key
    }
}
