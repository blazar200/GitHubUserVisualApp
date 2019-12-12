//
//  UserDetailViewController.swift
//  GitHubUserVisualApp
//
//  Created by Baron Lazar on 12/11/19.
//  Copyright © 2019 Baron Lazar. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var userDetailTableView: UITableView!
    
    var userInfo: UserBasic?
    var filteredRepos: [Repository] = []
    var isFiltering: Bool = false
    
    static func createViewController() -> UserDetailViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userDetailTableView.delegate = self
        self.userDetailTableView.dataSource = self

        self.userDetailTableView.register(UserDetailHeader.self, forHeaderFooterViewReuseIdentifier: "userDetailHeader")
        self.userDetailTableView.register(RepoCell.self, forCellReuseIdentifier: "userDetail")
        
        guard let userInfo = self.userInfo else { return }
        
        Networking.shared.fetchUserDetails(urlString: userInfo.user.url) { [weak self] (detail, error) in
            guard let strongSelf = self else { return }
            guard error == nil else {
                strongSelf.presentAlert(text: error?.localizedDescription ?? "Unknown")
                return
            }
            guard let detail = detail as? User else {
                strongSelf.presentAlert(text: "Data is not an image")
                return
            }
            strongSelf.userInfo?.user = detail
            
            DispatchQueue.main.async {
                self?.userDetailTableView.reloadData()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func showKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        self.userDetailTableView.contentInset = insets
        self.userDetailTableView.scrollIndicatorInsets = insets
    }
    
    @objc func hideKeyboard(notification: Notification?) {
        self.userDetailTableView.contentInset = .zero
        self.userDetailTableView.scrollIndicatorInsets = .zero
    }
    
    private func presentAlert(text: String) {
        let alert = UIAlertController(title: "Whoops", message: "Something went wrong: \(text)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    

}

extension UserDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return self.filteredRepos.count
        } else {
            return self.userInfo?.repos?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RepoCell! = tableView.dequeueReusableCell(withIdentifier: "userDetail", for: indexPath) as? RepoCell
        
        if isFiltering {
            let repoName = self.filteredRepos[indexPath.row].name
            let starCount = self.filteredRepos[indexPath.row].stargazers_count
            let forkCount = self.filteredRepos[indexPath.row].forks
            cell.update(repoName: repoName, starCount: starCount, forkCount: forkCount)
        } else {
            let repoName = self.userInfo?.repos?[indexPath.row].name ?? "Repo Name"
            let starCount = self.userInfo?.repos?[indexPath.row].stargazers_count ?? 0
            let forkCount = self.userInfo?.repos?[indexPath.row].forks ?? 0
            cell.update(repoName: repoName, starCount: starCount, forkCount: forkCount)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isFiltering {
            guard let url = URL(string: self.filteredRepos[indexPath.row].html_url) else { return }
            UIApplication.shared.open(url, options: [:]) { success in
                print("safasf")
            }
            
        } else {
            guard let url = URL(string: self.userInfo?.repos?[indexPath.row].html_url ?? "") else { return }
            UIApplication.shared.open(url, options: [:]) { success in
                print("asd")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "userDetailHeader") as? UserDetailHeader
        
        let avatar = self.userInfo?.avatar ?? UIImage(named: "defaultAvatar.png")
        let name = self.userInfo?.user.login ?? "N/A"
        let email = self.userInfo?.user.email
        let location = self.userInfo?.user.location ?? "N/A"
        let joinDate = self.userInfo?.user.formatDate() ?? "N/A"
        let followers = self.userInfo?.user.followers ?? 0
        let following = self.userInfo?.user.following ?? 0
        let bio = self.userInfo?.user.bio
        
        header?.update(avatar: avatar, name: name, email: email, location: location, joinDate: joinDate, followers: followers, following: following, bio: bio)
        header?.setDelegate(delegate: self)
        
        return header
    }
    
}

extension UserDetailViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            self.isFiltering = false
            DispatchQueue.main.async {
                self.userDetailTableView.reloadData()
            }
            return
        }
        self.isFiltering = true
        
        self.filteredRepos.removeAll()
        let repos = self.userInfo?.repos ?? []
        self.filteredRepos = repos.filter {
            return $0.name.lowercased().contains(searchText.lowercased())
        }
        
        DispatchQueue.main.async {
            self.userDetailTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

