//
//  CommentCell.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 9/16/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet {
            textLabel.text = comment?.text
        }
    }
    
    let textLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.backgroundColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        addSubview(textLabel)
        textLabel.anchor(top: topAnchor, leading: leadingAnchor,
                         bottom: bottomAnchor, trailing: trailingAnchor,
                         paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4,
                         width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
