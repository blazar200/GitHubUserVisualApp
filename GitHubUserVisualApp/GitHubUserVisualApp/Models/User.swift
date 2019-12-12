//
//  User.swift
//  GitHubUserVisualApp
//
//  Created by Baron Lazar on 12/11/19.
//  Copyright © 2019 Baron Lazar. All rights reserved.
//

import Foundation
import UIKit

/// Wrapper Struct to be used for UserList
struct UserBasic {
    var user: User
    var avatar: UIImage?
    var repos: [Repository]?
}

struct User: Decodable {
    
    let login: String
    let id: Int
    let avatar_url: String
    let url: String
    let repos_url: String
    let email: String?
    let name: String?
    let location: String?
    let followers: Int?
    let following: Int?
    let created_at: String?
    let bio: String?
    
    func formatDate() -> String {
        guard let dateCreatedString = self.created_at else { return "N/A" }
        
        if let date = ISO8601DateFormatter().date(from: dateCreatedString) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, YYYY 'at' h:mm a"
            return dateFormatter.string(from: date)
        }
        
        return "N/A"
    }
}

