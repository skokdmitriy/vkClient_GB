//
//  GroupService.swift
//  VKClient
//
//  Created by Дмитрий Скок on 27.03.2022.
//

import Foundation
import RealmSwift

enum GroupError: Error {
    case parseError
    case requestError(Error)
}

fileprivate enum TypeMethods: String {
    case groupsGet = "/method/groups.get"
    case groupsSearch = "/method/groups.search"
    case groupsJoin = "/method/groups.join"
    case groupsLeave = "/method/groups.leave"
}

fileprivate enum TypeRequests: String {
    case get = "GET"
    case post = "POST"
}

class GroupService {
    
    private var realm = RealmCacheService()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    
    private let scheme = "https"
    private let host = "api.vk.com"
    private let cacheKey = "groups"
    private let decoder = JSONDecoder()
    
    func loadGroups(completion: @escaping (Result<[Group], GroupError>) -> Void) {
        
        if checkExpiry(key: cacheKey) {
            guard let realm = try? Realm() else { return }
            let groups = realm.objects(Group.self)
            let groupArray = Array(groups)
            
            if !groups.isEmpty {
                completion(.success(groupArray))
                return
            }
        }
        
        guard let token = Session.instance.token else { return }
        let params: [String: String] = ["extended": "1"]
        let url = configureUrl(token: token,
                               method: .groupsGet,
                               htttpMethod: .get,
                               params: params)
        print(url)
        let task = session.dataTask(with: url) {data, response, error in
            if let error = error {
                return completion(.failure(.requestError(error)))
            }
            guard let data = data else {
                return
            }
            do {
                let result = try self.decoder.decode(SearchGroup.self, from: data).response.items
                
                DispatchQueue.main.async {
                    self.realm.create(result)
                }
                return completion(.success(result))
            } catch {
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    func loadGroupSearch(searchText: String, completion: @escaping(Result<[Group],GroupError>) -> Void) {
        guard let token = Session.instance.token else { return }
        let params: [String: String] = ["extended": "1",
                                        "q": searchText,
                                        "count": "40"]
        let url = configureUrl(token: token,
                               method: .groupsSearch,
                               htttpMethod: .get,
                               params: params)
        let task = session.dataTask(with: url) {data, response, error in
            if let error = error {
                return completion(.failure(.requestError(error)))
            }
            guard let data = data else {return}
            
            do {
                let result = try self.decoder.decode(SearchGroup.self, from: data).response.items

                return completion(.success(result))
            } catch {
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    func addGroup(idGroup: Int, completion: @escaping(Result<JoinOrLeaveGroupModel, GroupError>) -> Void) {
        guard let token = Session.instance.token else { return }
        let params: [String: String] = ["group_id": "\(idGroup)"]
        let url = configureUrl(token: token,
                               method: .groupsJoin,
                               htttpMethod: .post,
                               params: params)
        let task = session.dataTask(with: url) {data, response, error in
            if let error = error {
                return completion(.failure(.requestError(error)))
            }
            guard let data = data else {
                return
            }
            do {
                let result = try self.decoder.decode(JoinOrLeaveGroupModel.self, from: data)
                return completion(.success(result))
            } catch {
                return completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    func deleteGroup(id: Int, completion: @escaping(Result<JoinOrLeaveGroupModel, GroupError>) -> Void) {
        guard let token = Session.instance.token else { return }
        let params: [String: String] = ["group_id": "\(id)"]
        let url = configureUrl(token: token,
                               method: .groupsJoin,
                               htttpMethod: .post,
                               params: params)
        let task = session.dataTask(with: url) {data, response, error in
            if let error = error {
                return completion(.failure(.requestError(error)))
            }
            guard let data = data else {
                return
            }
            do {
                let result = try self.decoder.decode(JoinOrLeaveGroupModel.self, from: data)
                return completion(.success(result))
            } catch {
                return completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    func leaveGroup(idGroup: Int, completion: @escaping(Result<JoinOrLeaveGroupModel, GroupError>) -> Void) {
        guard let token = Session.instance.token else { return }
        let params: [String: String] = ["group_id": "\(idGroup)"]
        let url = configureUrl(token: token,
                               method: .groupsLeave,
                               htttpMethod: .post,
                               params: params)
        let task = session.dataTask(with: url) {data, response, error in
            if let error = error {
                return completion(.failure(.requestError(error)))
            }
            guard let data = data else {
                return
            }
            do {
                let result = try self.decoder.decode(JoinOrLeaveGroupModel.self, from: data)
                return completion(.success(result))
            } catch {
                return completion(.failure(.parseError))
            }
        }
        task.resume()
    }
}
//MARK: - Private
private extension GroupService {
    /// Записывает дату просрочки кэша
    func setExpiry(key: String, time: Double){
        let date = (Date.init() + time).timeIntervalSince1970
        UserDefaults.standard.set(String(date), forKey: key)
    }
    
    /// Проверяет, свежие ли данные, true - всё хорошо
    func checkExpiry(key: String) -> Bool {
        let expiryDate = UserDefaults.standard.string(forKey: key) ?? "0"
        let currentDate = String(Date.init().timeIntervalSince1970)
        
        if expiryDate > currentDate {
            return true
        } else {
            return false
        }
    }
    
    func configureUrl(token: String,
                      method: TypeMethods,
                      htttpMethod: TypeRequests,
                      params: [String: String]) -> URL {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "access_token", value: token))
        queryItems.append(URLQueryItem(name: "v", value: constants.versionAPI))
        
        for (param, value) in params {
            queryItems.append(URLQueryItem(name: param, value: value))
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = method.rawValue
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            fatalError("URL id invalid")
        }
        return url
    }
}

