//
//  Networking.swift
//  GitHubUserVisualApp
//
//  Created by Baron Lazar on 12/11/19.
//  Copyright © 2019 Baron Lazar. All rights reserved.
//

import Foundation
import UIKit

enum NetworkError: String, Error {
    case notURL
    case noData
    case noImage
    case decodingFailure
}

class Networking {
    
    static let shared: Networking = Networking()
    
    private let baseURL = "https://api.github.com/users"
    private let searchUsersURL = "https://api.github.com/search/users?q="
    
    private init() {}
    
    func fetchUsers(completion: @escaping (Any?, Error?) -> Void) {
        
        guard let url = URL(string: baseURL) else {
            completion(nil, NetworkError.notURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            do {
                let users = try JSONDecoder().decode(UserResponse.self, from: data)
                completion(users, nil)
                
            } catch let error {
                print("Failure to decode: \(error.localizedDescription)")
                completion(nil, NetworkError.decodingFailure)
            }
            
        }.resume()
    }
    
    
    func fetchUsers(_ query: String, completion: @escaping (Any?, Error?) -> Void) {
        
        guard let url = URL(string: searchUsersURL + query) else {
            completion(nil, NetworkError.notURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            do {
                let users = try JSONDecoder().decode(UserResponse.self, from: data)
                completion(users.items, nil)
                
            } catch let error {
                print("Failure to decode: \(error.localizedDescription)")
                completion(nil, NetworkError.decodingFailure)
            }
            
        }.resume()
    }
    
    func fetchAvatar(urlString: String, completion: @escaping (Any?, Error?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(nil, NetworkError.notURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(nil, NetworkError.noImage)
                return
            }
            
            completion(image, nil)
            
        }.resume()
        
    }
    
    func fetchUserRepos(urlString: String, completion: @escaping (Any?, Error?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(nil, NetworkError.notURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            do {
                let repos = try JSONDecoder().decode([Repository].self, from: data)
                completion(repos , nil)

            } catch let error {
                print("Failure to decode: \(error.localizedDescription)")
                completion(nil, NetworkError.decodingFailure)
            }
            
        }.resume()
    }
    
    func fetchUserDetails(urlString: String, completion: @escaping (Any?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil, NetworkError.notURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(user, nil)
                
            } catch let error {
                print("Failure to decode: \(error.localizedDescription)")
                completion(nil, NetworkError.decodingFailure)
            }
            
        }.resume()
    }
    
}

