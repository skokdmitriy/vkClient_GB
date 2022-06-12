//
//  Session.swift
//  VKClient
//
//  Created by Дмитрий Скок on 21.11.2021.
//

import Foundation

class Session {
        
    static let instance = Session ()
    
    var token: String?
    var userId: Int?
    
    private init () {}

}
