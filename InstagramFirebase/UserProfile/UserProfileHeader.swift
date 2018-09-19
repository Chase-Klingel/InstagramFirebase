//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 7/22/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeader: UICollectionViewCell {
    
    var delegate: UserProfileHeaderDelegate?
    
    // MARK: - Set Profile Image + Username
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            
            usernameLabel.text = user?.username
            
            setupEditFollowButton()
        }
    }
    
    // MARK: - UI Element Definitions
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        
        return iv
    }()
    
    lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        
        return button
    }()
    
    @objc fileprivate func handleChangeToGridView() {
        gridButton.tintColor = .mainBlue()
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        
        delegate?.didChangeToGridView()
    }
    
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.1)
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        
        return button
    }()
    
    @objc fileprivate func handleChangeToListView() {
        listButton.tintColor = .mainBlue()
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        
        delegate?.didChangeToListView()
    }
    
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
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Init View
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        anchorProfileImage()
        anchorUserStatsView()
        anchorEditProfileButton()
        anchorBottomToolBar()
        anchorUsernameLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Profile Image Positioning
    
    fileprivate func anchorProfileImage() {
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor,
                                bottom: nil, trailing: nil,
                                paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0,
                                width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
    }
    
    // MARK: - Edit Profile Button Positioning
    
    fileprivate func anchorEditProfileButton() {
        addSubview(editProfileFollowButton)
        
        editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, leading: postsLabel.leadingAnchor,
                                 bottom: nil, trailing: followingLabel.trailingAnchor,
                                 paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                                 width: 0, height: 0)
    }
    
    // MARK: - Handle Follow / Unfollow Users
    
    fileprivate func setupEditFollowButton() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            // edit profile
        } else {
            
            Database.database().reference().child("following")
                .child(currentLoggedInUserId)
                .child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                        print("inside unfollow logic")
                        self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                        self.editProfileFollowButton.setTitleColor(.black, for: .normal)
                    } else {
                        print("inside follow logic")
                        self.setupFollowStyle()
                    }
            }, withCancel: { (err) in
                print("Failed to check if following ", err)
            })
        }
    }
    
    fileprivate func setupFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    @objc func handleEditProfileOrFollow() {
        
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            Database
                .database()
                .reference()
                .child("following")
                .child(currentLoggedInUserId)
                .child(userId).removeValue { (err, ref) in
                if let err = err {
                    print("Failed to unfollow user:", err)
                    
                    return
                }
                
                print("Successfully unfollowed user: ", self.user?.username ?? "")
                self.setupFollowStyle()
            }
        } else {
            let ref = Database
                        .database()
                        .reference()
                        .child("following")
                        .child(currentLoggedInUserId)
            
            let values = [userId: 1]
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to follow user: ", err)
                    
                    return
                }
                
                print("Successfully followed user: ", self.user?.username ?? "")
                
                self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                self.editProfileFollowButton.backgroundColor = .white
                self.editProfileFollowButton.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    // MARK: - Profile Stats Positioning
    
    fileprivate func anchorUserStatsView() {
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

    fileprivate func anchorBottomToolBar() {
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

    fileprivate func anchorUsernameLabel() {
        addSubview(usernameLabel)
        
        usernameLabel.anchor(top: profileImageView.bottomAnchor, leading: leadingAnchor,
                             bottom: nil, trailing: trailingAnchor,
                             paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0,
                             width: 0, height: 0)
    }
}
