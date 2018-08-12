//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 7/22/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

class UserProfileHeader: UICollectionViewCell {
    var user: User? {
        didSet {
            setupProfileImageData()
            
            usernameLabel.text = user?.username
        }
    }
    
    // MARK: - UI Element Definitions
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        
        return iv
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)

        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.1)

        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.1)
        
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)

        return label
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n",
                                                       attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "posts",
                                                        attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray,
                                                                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n",
                                                       attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "followers",
                                                        attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray,
                                                                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n",
                                                       attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "following",
                                                        attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray,
                                                                                          NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        
        return  button
    }()
    
    // MARK: - Init UICollectionViewCell
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupProfileImage()
        setupUserStatsView()
        setupEditProfileButton()
        setupBottomToolBar()
        setupUsernameLabel()
    }
    
    // MARK: - Profile Image Positioning
    
    fileprivate func setupProfileImage() {
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor,
                                bottom: nil, trailing: nil,
                                paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0,
                                width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
    }
    
    fileprivate func setupProfileImageData() {
        guard let profileImageUrl = user?.profileImageUrl else { return }
        guard let url = URL(string: profileImageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch profile image: ", err)
                return
            }
            
            guard let data = data else { return }
            print("data => \(data)")
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
            }.resume()
    }
    
    // MARK: - Edit Profile Button Positioning
    
    fileprivate func setupEditProfileButton() {
        addSubview(editProfileButton)
        
        editProfileButton.anchor(top: postsLabel.bottomAnchor, leading: postsLabel.leadingAnchor,
                                 bottom: nil, trailing: followingLabel.trailingAnchor,
                                 paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                                 width: 0, height: 0)
    }
    
    // MARK: - Profile Stats Positioning
    
    fileprivate func setupUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        addSubview(stackView)
        
        stackView.anchor(top: topAnchor, leading: profileImageView.trailingAnchor,
                         bottom: nil, trailing: trailingAnchor,
                         paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12,
                         width: 0, height: 50)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
    }
    
    // MARK: - Header Tool Bar Positioning

    fileprivate func setupBottomToolBar() {
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: nil, leading: leadingAnchor,
                         bottom: bottomAnchor, trailing: trailingAnchor,
                         paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                         width: 0, height: 50)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        topDividerView.anchor(top: stackView.topAnchor, leading: leadingAnchor,
                              bottom: nil, trailing: trailingAnchor,
                              paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                              width: 0, height: 0.25)
        
        bottomDividerView.anchor(top: stackView.bottomAnchor, leading: leadingAnchor,
                                 bottom: nil, trailing: trailingAnchor,
                                 paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                                 width: 0, height: 0.25)
    }
    
    // MARK: - Username Positioning

    fileprivate func setupUsernameLabel() {
        addSubview(usernameLabel)
        
        usernameLabel.anchor(top: profileImageView.bottomAnchor, leading: leadingAnchor,
                             bottom: nil, trailing: trailingAnchor,
                             paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0,
                             width: 0, height: 0)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
