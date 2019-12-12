//
//  UserListCell.swift
//  GitHubUserVisualApp
//
//  Created by Baron Lazar on 12/11/19.
//  Copyright © 2019 Baron Lazar. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: "userListCell")
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.textLabel?.text = nil
        self.detailTextLabel?.text = nil
        self.imageView?.image = nil
    }

}
