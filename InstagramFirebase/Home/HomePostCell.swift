//
//  HomePostCell.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 8/20/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

class HomePostCell: UICollectionViewCell {
    
    // MARK: -  Instance Variables And UI Element Defs

    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            guard let profileImageUrl = post?.user.profileImageUrl else { return }
            photoImageView.loadImage(urlString: imageUrl)
            userProfileImageView.loadImage(urlString: profileImageUrl)

            usernameLabel.text = post?.user.username
            setupAttributedCaption()
        }
    }
    
    let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        
        return button
    }()
    
    let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        
        return button
    }()
    
    let bookMarkButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        
        return button
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
                
        return label
    }()
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserProfileImage()
        setupPhotoImage()
        setupOptionsButton()
        setupUsername()
        setupActionButtons()
        setupPhotoCaption()
    }
    
    // MARK: - UI Element Positioning
    
    fileprivate func setupUserProfileImage() {
        addSubview(userProfileImageView)

        userProfileImageView.anchor(top: topAnchor, leading: leadingAnchor,
                                    bottom: nil, trailing: nil,
                                    paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0,
                                    width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
    }
    
    fileprivate func setupUsername() {
        addSubview(usernameLabel)

        usernameLabel.anchor(top: topAnchor, leading: userProfileImageView.trailingAnchor,
                             bottom: photoImageView.topAnchor, trailing: optionsButton.leadingAnchor,
                             paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0,
                             width: 0, height: 0)
    }
    
    fileprivate func setupOptionsButton() {
        addSubview(optionsButton)

        optionsButton.anchor(top: topAnchor, leading: nil,
                             bottom: photoImageView.topAnchor, trailing: trailingAnchor,
                             paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                             width: 44, height: 0)
    }
    
    fileprivate func setupPhotoImage() {
        addSubview(photoImageView)

        photoImageView.anchor(top: userProfileImageView.bottomAnchor, leading: leadingAnchor,
                              bottom: nil, trailing: trailingAnchor,
                              paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                              width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
    }
    
    fileprivate func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: photoImageView.bottomAnchor, leading: leadingAnchor,
                         bottom: nil, trailing: nil,
                         paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0,
                         width: 120, height: 50)
        
        addSubview(bookMarkButton)
        bookMarkButton.anchor(top: photoImageView.bottomAnchor, leading: nil,
                              bottom: nil, trailing: trailingAnchor,
                              paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                              width: 40, height: 50)
    }
    
    fileprivate func setupAttributedCaption() {
        guard let post = self.post else { return }
        
        let attributedText = NSMutableAttributedString(string: post.user.username,
                                                       attributes: [NSAttributedStringKey.font:
                                                        UIFont.boldSystemFont(ofSize: 14)])
    
        attributedText.append(NSAttributedString(string: " \(post.caption)",
                                                 attributes: [NSAttributedStringKey.font:
        UIFont.systemFont(ofSize: 14)]))
    
        attributedText.append(NSAttributedString(string: "\n\n",
                                                 attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 4)]))
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeAgoDisplay,
                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray,
                                                              NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        captionLabel.attributedText = attributedText
    }
    
    fileprivate func setupPhotoCaption() {
        addSubview(captionLabel)
        
        captionLabel.anchor(top: likeButton.bottomAnchor, leading: leadingAnchor,
                            bottom: bottomAnchor, trailing: trailingAnchor,
                            paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8,
                            width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
