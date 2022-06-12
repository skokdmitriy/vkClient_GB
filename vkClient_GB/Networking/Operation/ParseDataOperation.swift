//
//  ParseDataOperation.swift
//  VKClient
//
//  Created by Дмитрий Скок on 05.06.2022.
//

import Foundation

class ParseDataOperation<T:Codable>: Operation {
    var outputData: [T]?
    
    override func main() {
        guard let getDataOperation = dependencies.first as? getDataOperation,
              let data = getDataOperation.data else { return }
        
        guard let parseData = try? JSONDecoder().decode(ResponseGroup.self, from: data)
                return
    }
    outputData = parseData
}
