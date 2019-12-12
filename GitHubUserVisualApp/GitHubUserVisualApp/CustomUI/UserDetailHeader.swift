//
//  UserDetailHeader.swift
//  GitHubUserVisualApp
//
//  Created by Baron Lazar on 12/11/19.
//  Copyright © 2019 Baron Lazar. All rights reserved.
//

import UIKit

class UserDetailHeader: UITableViewHeaderFooterView {
    
    private lazy var outerVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var innerHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var innerVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "defaultAvatar.png"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var joinDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var searchField: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for User's Repositories"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUp()
    }
    
    private func setUp(){
        self.contentView.backgroundColor = UIColor.gray
        
        self.addSubview(self.outerVStackView)
        self.outerVStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        self.outerVStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
        self.outerVStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        self.outerVStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8).isActive = true
        
        self.innerVStackView.addArrangedSubview(self.nameLabel)
        self.innerVStackView.addArrangedSubview(self.emailLabel)
        self.innerVStackView.addArrangedSubview(self.locationLabel)
        self.innerVStackView.addArrangedSubview(self.joinDateLabel)
        self.innerVStackView.addArrangedSubview(self.followersLabel)
        self.innerVStackView.addArrangedSubview(self.followingLabel)

        self.avatarImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.innerHStackView.addArrangedSubview(self.avatarImage)
        self.innerHStackView.addArrangedSubview(self.innerVStackView)
        
        self.outerVStackView.addArrangedSubview(self.innerHStackView)
        self.outerVStackView.addArrangedSubview(self.bioLabel)
        
        
        self.outerVStackView.addArrangedSubview(self.searchField)
        self.searchField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        self.searchField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        self.searchField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
    }
    
    func update(avatar: UIImage?, name: String, email: String?, location: String?, joinDate: String, followers: Int, following: Int, bio: String?){
        
        self.avatarImage.image = avatar
        self.nameLabel.text = name
        self.emailLabel.text = email
        self.emailLabel.isHidden = (email == nil) ? true : false
        self.locationLabel.text = location
        self.joinDateLabel.text = joinDate
        self.followersLabel.text = "\(followers) Followers"
        self.followingLabel.text = "Following \(following)"
        self.bioLabel.text = bio
        self.bioLabel.isHidden = (bio == nil) ? true : false
    }
    
    func setDelegate(delegate: UISearchBarDelegate) {
        self.searchField.delegate = delegate
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.avatarImage.image = nil
        self.nameLabel.text = nil
        self.emailLabel.text = nil
        self.emailLabel.isHidden = false
        self.locationLabel.text = nil
        self.joinDateLabel.text = nil
        self.followersLabel.text = nil
        self.followingLabel.text = nil
        self.bioLabel.text = nil
        self.bioLabel.isHidden = false
    }

}
