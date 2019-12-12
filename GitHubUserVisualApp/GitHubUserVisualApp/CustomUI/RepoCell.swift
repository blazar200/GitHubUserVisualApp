//
//  RepoCell.swift
//  GitHubUserVisualApp
//
//  Created by Baron Lazar on 12/11/19.
//  Copyright © 2019 Baron Lazar. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .trailing
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var repoNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    private lazy var starsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    private lazy var forksLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUp()
    }
    
    private func setUp() {
        self.subviews.forEach{
            $0.removeFromSuperview()
        }
        
        self.addSubview(self.hStackView)
        self.hStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        self.hStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        self.hStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2).isActive = true
        self.hStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2).isActive = true
        
        self.vStackView.addArrangedSubview(self.forksLabel)
        self.vStackView.addArrangedSubview(self.starsLabel)
        
        self.hStackView.addArrangedSubview(self.repoNameLabel)
        self.hStackView.addArrangedSubview(self.vStackView)
    }
    
    func update(repoName: String, starCount: Int, forkCount: Int) {
        self.repoNameLabel.text = repoName
        self.starsLabel.text = "\(starCount) Stars"
        self.forksLabel.text = "\(forkCount) Forks"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.repoNameLabel.text = nil
        self.starsLabel.text = nil
        self.forksLabel.text = nil
    }

}
