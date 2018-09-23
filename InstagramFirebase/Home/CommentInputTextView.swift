//
//  CommentInputTextView.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 9/23/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

class CommentInputTextView: UITextView {
    
    // MARK: - Text View Placeholder 
    let placeholder: UILabel = {
        let ph = UILabel()
        ph.text = "Enter comment..."
        ph.font = UIFont.systemFont(ofSize: 14)
        ph.textColor = UIColor.lightGray
        
        return ph
    }()
    
    func displayPlaceholder() {
        placeholder.isHidden = false
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: .UITextViewTextDidChange, object: nil)
        addSubview(placeholder)
        placeholder.anchor(top: topAnchor, leading: leadingAnchor,
                           bottom: bottomAnchor, trailing: trailingAnchor,
                           paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0,
                           width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handle Text Change
    
    @objc func handleTextChange() {
        placeholder.isHidden = !self.text.isEmpty
    }
    
    
}
