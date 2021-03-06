//
//  HomePostCell.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 8/20/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

// MARK: - Protocols

protocol HomePostCellDelegate {
    func didTapComment(post: Post)
    func didLike(for cell: HomePostCell)
}

class HomePostCell: UICollectionViewCell {
    
    // MARK: -  Instance Variables And UI Element Defs

    var delegate: HomePostCellDelegate?

    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            photoImageView.loadImage(urlString: imageUrl)

            guard let profileImageUrl = post?.user.profileImageUrl else { return }
            userProfileImageView.loadImage(urlString: profileImageUrl)
            
            likeButton.setImage(post?.hasLiked == true ?
                #imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal),
                                for: .normal)

            usernameLabel.text = post?.user.username
            setupAttributedCaption()
        }
    }
    
    fileprivate let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    fileprivate let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    fileprivate let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    lazy fileprivate var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        
        return button
    }()
    
    @objc fileprivate func handleLike() {
        delegate?.didLike(for: self)
    }
    
    lazy fileprivate var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleComment() {
        guard let post = post else { return }
        delegate?.didTapComment(post: post)
    }
    
    fileprivate let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        
        return button
    }()
    
    fileprivate let bookMarkButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        
        return button
    }()
    
    fileprivate let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
                
        return label
    }()
    
    fileprivate let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    // MARK: - Init View

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        anchorProfileImage()
        anchorPhotoImage()
        anchorOptionsButton()
        anchorUsername()
        anchorActionButtons()
        anchorPhotoCaption()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Element Positioning
    
    fileprivate func anchorProfileImage() {
        addSubview(userProfileImageView)

        userProfileImageView.anchor(top: topAnchor, leading: leadingAnchor,
                                    bottom: nil, trailing: nil,
                                    paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0,
                                    width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
    }
    
    fileprivate func anchorPhotoImage() {
        addSubview(photoImageView)
        
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, leading: leadingAnchor,
                              bottom: nil, trailing: trailingAnchor,
                              paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                              width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
    }
    
    fileprivate func anchorUsername() {
        addSubview(usernameLabel)

        usernameLabel.anchor(top: topAnchor, leading: userProfileImageView.trailingAnchor,
                             bottom: photoImageView.topAnchor, trailing: optionsButton.leadingAnchor,
                             paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0,
                             width: 0, height: 0)
    }
    
    fileprivate func anchorOptionsButton() {
        addSubview(optionsButton)

        optionsButton.anchor(top: topAnchor, leading: nil,
                             bottom: photoImageView.topAnchor, trailing: trailingAnchor,
                             paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                             width: 44, height: 0)
    }
    
    fileprivate func anchorActionButtons() {
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
    
        attributedText.append(NSAttributedString(string: "1 week ago",
                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray,
                                                              NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        captionLabel.attributedText = attributedText
    }
    
    fileprivate func anchorPhotoCaption() {
        addSubview(captionLabel)
        
        captionLabel.anchor(top: likeButton.bottomAnchor, leading: leadingAnchor,
                            bottom: bottomAnchor, trailing: trailingAnchor,
                            paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8,
                            width: 0, height: 0)
    }
}
