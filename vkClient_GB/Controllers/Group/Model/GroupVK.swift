//
//  GroupVK.swift
//  VKClient
//
//  Created by Дмитрий Скок on 27.03.2022.
//

import Foundation
import RealmSwift

struct SearchGroup: Decodable {
    let response: ResponseGroup
}

struct ResponseGroup: Decodable {
    let count: Int
    let items: [Group]
}

class Group: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var photo100 = ""
    @objc dynamic var is_member = 0

    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case is_member
        case photo100 = "photo_100"
    }

    override class func primaryKey() -> String? {
        "id"
    }
}
