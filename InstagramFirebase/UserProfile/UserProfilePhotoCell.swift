//
//  UserProfilePhotoCell.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 8/18/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    // MARK: - Set Post

    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            photoImageView.loadImage(urlString: imageUrl)
        }
    }
    
    // MARK: - UI Element Definitions
    
    fileprivate let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv;
    }()
    
    // MARK: - Init View

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        
        photoImageView.anchor(top: topAnchor, leading: leadingAnchor,
                              bottom: bottomAnchor, trailing: trailingAnchor,
                              paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                              width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
