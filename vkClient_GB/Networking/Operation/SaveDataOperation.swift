//
//  SaveDataOperation.swift
//  VKClient
//
//  Created by Дмитрий Скок on 05.06.2022.
//

import Foundation
import RealmSwift

class SaveDataOperation<T: Object & Codable>: Operation {
        
    override func main() {
        guard let parseDataOperation = dependencies.first as? ParseDataOperation<T>,
              let outputData = parseDataOperation.outputData else { return }
        
        do {
            let realm = try Realm()
            let oldValues = realm.objects(T.self)
            realm.beginWrite()
            realm.delete(oldValues)
            realm.add(outputData)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
