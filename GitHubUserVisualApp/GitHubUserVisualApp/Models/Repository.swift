//
//  Repository.swift
//  GitHubUserVisualApp
//
//  Created by Baron Lazar on 12/11/19.
//  Copyright © 2019 Baron Lazar. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    
    let id: Int
    let name: String
    let owner: User
    let stargazers_count: Int
    let forks: Int
    let html_url: String
}
