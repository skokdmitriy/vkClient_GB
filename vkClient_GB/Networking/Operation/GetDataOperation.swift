//
//  GetDataOperation.swift
//  VKClient
//
//  Created by Дмитрий Скок on 05.06.2022.
//

import Foundation

class GetDataOperation: AsyncOperation {
    
    let networkingConstants = NetworkingConstants()
    
    private var urlConstructor = URLComponents()
    private let configuration: URLSessionConfiguration!
    private let session: URLSession!
    private var url: URL
    private var task: URLSessionDataTask?

    var data: Data?

    init (url: URL) {
        urlConstructor.scheme = networkingConstants.scheme
        urlConstructor.host = networkingConstants.host
        configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)

        self.url = url
    }

    override func cancel() {
        task?.cancel()
        super.cancel()
    }

    override func main() {
        task = session.dataTask(with: url,
                                completionHandler: { (data, response, error) in
            guard let data = data else { return }

            self.data = data
            self.state = .finished

        })
        task?.resume()
    }
}
