//
//  PhotoSelectorCell.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 8/14/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell {
    
    // MARK: - UI Element Definitions

    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    // MARK: - Initializers 
    
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
