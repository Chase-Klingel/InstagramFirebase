//
//  UserSearchCell.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 9/5/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            usernameLabel.text = user?.username
            
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
        }
    }
    
    // MARK: - UI Element Definitions

    fileprivate let profileImageView: CustomImageView = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        
        // position user profile image
        profileImageView.anchor(top: nil, leading: leadingAnchor,
                                bottom: nil, trailing: nil, paddingTop: 0,
                                paddingLeft: 8, paddingBottom: 0, paddingRight: 0,
                                width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 50 / 2
        
        // position username 
        usernameLabel.anchor(top: topAnchor, leading: profileImageView.trailingAnchor,
                             bottom: bottomAnchor, trailing: trailingAnchor,
                             paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0,
                             width: 0, height: 0)
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: usernameLabel.trailingAnchor,
                             bottom: bottomAnchor, trailing: trailingAnchor,
                             paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                             width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
