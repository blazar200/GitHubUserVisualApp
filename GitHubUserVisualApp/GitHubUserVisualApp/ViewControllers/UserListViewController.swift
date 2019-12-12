//
//  UserListViewController.swift
//  GitHubUserVisualApp
//
//  Created by Baron Lazar on 12/11/19.
//  Copyright © 2019 Baron Lazar. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {
    
    @IBOutlet weak var userListSearchBar: UISearchBar!
    @IBOutlet weak var userListTableView: UITableView!
    
    // Actual Data to use
    var userInfo: [UserBasic] = []
    var filteredUserInfo: [UserBasic] = []
    
    // Dummy Data
    var useDummyData: Bool = false
    var dummyData: [String] = []
    var isFiltering: Bool = false
    var filterdDummyData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
//        self.setUpDummyData()
    }
        
    private func setUpUI() {
        self.userListTableView.delegate = self
        self.userListTableView.dataSource = self
        self.userListSearchBar.delegate = self

        self.navigationItem.title = "Github Searcher"
        self.userListSearchBar.placeholder = "Search Github Users"
        
        self.userListTableView.register(UserListCell.self, forCellReuseIdentifier: "userListCell")
    }
    
    private func setUpDummyData() {
        self.useDummyData = true
        for i in 0..<30 {
            self.dummyData.append("\(i): value\(i)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.pullUsersIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func presentAlert(text: String) {
        let alert = UIAlertController(title: "Whoops", message: "Something went wrong: \(text)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
        
    @objc func showKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        self.userListTableView.contentInset = insets
        self.userListTableView.scrollIndicatorInsets = insets
    }
    
    @objc func hideKeyboard(notification: Notification?) {
        self.userListTableView.contentInset = .zero
        self.userListTableView.scrollIndicatorInsets = .zero
    }

}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.useDummyData {
            if isFiltering {
                return self.filterdDummyData.count
            } else {
                return self.dummyData.count
            }
        } else {
            if isFiltering {
                return self.filteredUserInfo.count
            } else {
                return self.userInfo.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UserListCell! = tableView.dequeueReusableCell(withIdentifier: "userListCell", for: indexPath) as? UserListCell
        if cell == nil {
            cell = UserListCell(style: .value1, reuseIdentifier: "userListCell")
        }
        
        if self.useDummyData {
            if isFiltering {
                cell.textLabel?.text = self.filterdDummyData[indexPath.row]
            } else {
                cell.textLabel?.text = self.dummyData[indexPath.row]
            }
            cell.detailTextLabel?.text = "Repo: \(indexPath.row)"
            cell.imageView?.image = UIImage(named: "defaultAvatar.png")
        } else {
            if isFiltering {
                cell.textLabel?.text = self.filteredUserInfo[indexPath.row].user.login
                if let count = self.filteredUserInfo[indexPath.row].repos?.count {
                    cell.detailTextLabel?.text = "Repo: \(count)"
                } else {
                    cell.detailTextLabel?.text = "Repo: loading..."
                }

                if let image = self.filteredUserInfo[indexPath.row].avatar {
                    cell.imageView?.image = image
                } else {
                    cell.imageView?.image = UIImage(named: "defaultAvatar.png")
                }
            } else {
                cell.textLabel?.text = self.userInfo[indexPath.row].user.login
                if let count = self.userInfo[indexPath.row].repos?.count {
                    cell.detailTextLabel?.text = "Repo: \(count)"
                } else {
                    cell.detailTextLabel?.text = "Repo: loading..."
                }

                if let image = self.userInfo[indexPath.row].avatar {
                    cell.imageView?.image = image
                } else {
                    cell.imageView?.image = UIImage(named: "defaultAvatar.png")
                }

            }
        }
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !self.useDummyData else { return }
        self.pullReposIfNeeded(tableView: tableView, indexPath: indexPath)
        self.pullImagesIfNeeded(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = UserDetailViewController.createViewController() else { return }
        vc.title = "Github Searcher"
        if isFiltering {
            vc.userInfo = self.filteredUserInfo[indexPath.row]
        } else {
            vc.userInfo = self.userInfo[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension UserListViewController {
    
    private func pullUsersIfNeeded() {
        guard self.userInfo.count == 0 else { return }
        
        Networking.shared.fetchUsers { [weak self] (data, error) in
            guard let strongSelf = self else { return }
            guard error == nil else {
                strongSelf.presentAlert(text: error?.localizedDescription ?? "Unknown")
                return
            }
            guard let users = data as? [User] else {
                strongSelf.presentAlert(text: "data is not a user")
                return
            }
            users.forEach{
                strongSelf.userInfo.append(UserBasic(user: $0, avatar: nil, repos: nil))
            }
            DispatchQueue.main.async {
                strongSelf.userListTableView.reloadData()
            }
        }
    }
    
    private func pullReposIfNeeded(tableView: UITableView, indexPath: IndexPath) {
        guard self.userInfo[indexPath.row].repos == nil else { return }
        
        Networking.shared.fetchUserRepos(urlString: self.userInfo[indexPath.row].user.repos_url) { [weak self] (repos, error) in
            guard let strongSelf = self else { return }
            guard error == nil else {
                strongSelf.presentAlert(text: error?.localizedDescription ?? "Unknown")
                return
            }
            guard let repos = repos as? [Repository] else {
                strongSelf.presentAlert(text: "Data is not an Int")
                return
            }
            
            if strongSelf.isFiltering {
                strongSelf.filteredUserInfo[indexPath.row].repos = repos
            } else {
                strongSelf.userInfo[indexPath.row].repos = repos
            }
            
            DispatchQueue.main.async {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
    }
    
    private func pullImagesIfNeeded(tableView: UITableView, indexPath: IndexPath){
        guard self.userInfo[indexPath.row].avatar == nil else { return }
        
        Networking.shared.fetchAvatar(urlString: self.userInfo[indexPath.row].user.avatar_url) { [weak self] (image, error) in
            guard let strongSelf = self else { return }
            guard error == nil else {
                strongSelf.presentAlert(text: error?.localizedDescription ?? "Unknown")
                return
            }
            guard let image = image as? UIImage else {
                strongSelf.presentAlert(text: "Data is not an image")
                return
            }
            if strongSelf.isFiltering {
                strongSelf.filteredUserInfo[indexPath.row].avatar = image
            } else {
                strongSelf.userInfo[indexPath.row].avatar = image
            }
            
            DispatchQueue.main.async {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
}

extension UserListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            self.isFiltering = false
            DispatchQueue.main.async {
                self.userListTableView.reloadData()
            }
            return
        }
        self.isFiltering = true
        
        if self.useDummyData {
            self.filterdDummyData = self.dummyData.filter {
                return ($0.lowercased().contains(searchText.lowercased()))
            }
        } else {
            self.filteredUserInfo.removeAll()
            self.filteredUserInfo = self.userInfo.filter {
                return $0.user.login.lowercased().contains(searchText.lowercased())
            }
        }
        
        DispatchQueue.main.async {
            self.userListTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       searchBar.resignFirstResponder()
    }

}


