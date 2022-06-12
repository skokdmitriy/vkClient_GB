//
//  FirebaseGroup.swift
//  VKClient
//
//  Created by Дмитрий Скок on 19.05.2022.
//

import Firebase

class FirebaseGroup {
  
    let groupName: String
    let groupId: Int
    let ref: DatabaseReference?
    
     init(groupName: String, groupId: Int) {
        self.groupName = groupName
        self.groupId = groupId
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String:Any],
            let id = value["groupId"] as? Int,
            let name = value["groupName"] as? String
        else {
            return nil
        }
        
        self.groupName = name
        self.groupId = id
        self.ref = snapshot.ref
    }
    
    func toAnyObject() -> [String:Any] {
        return [
            "groupId": groupId,
            "groupName": groupName
        ]
    }
}



