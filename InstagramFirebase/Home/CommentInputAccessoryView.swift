//
//  CommentInputAccessoryView.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 9/23/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didSubmit(for comment: String)
}

class CommentInputAccessoryView: UIView {
    
    // MARK: - Declare Delegate + UI Element Definitions

    var delegate: CommentInputAccessoryViewDelegate?
    
    fileprivate let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        return button
    }()
    
    // UITextView supports multi-line and UITextField does not
    fileprivate let commentTextView: CommentInputTextView = {
        let textView = CommentInputTextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 16)
        //textField.placeholder = "Enter Comment"
        
        return textView
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        addSubview(submitButton)
        submitButton.anchor(top: topAnchor, leading: nil,
                            bottom: nil, trailing: trailingAnchor,
                            paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12,
                            width: 50, height: 50)
        
        addSubview(commentTextView)
        if #available(iOS 11, *) {
            commentTextView.anchor(top: topAnchor, leading: leadingAnchor,
                                    bottom: safeAreaLayoutGuide.bottomAnchor, trailing: submitButton.leadingAnchor,
                                    paddingTop: 8, paddingLeft: 12, paddingBottom: 8, paddingRight: 0,
                                    width: 0, height: 0)
        } else {
            commentTextView.anchor(top: topAnchor, leading: leadingAnchor,
                                    bottom: bottomAnchor, trailing: submitButton.leadingAnchor,
                                    paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0,
                                    width: 0, height: 0)
        }
   
        anchorLineSeparator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: - Helper Methods
    
    fileprivate func anchorLineSeparator() {
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: topAnchor, leading: leadingAnchor,
                                 bottom: nil, trailing: trailingAnchor,
                                 paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                                 width: 0, height: 0.5)
    }
    
    @objc func handleSubmit() {
        guard let commentText = commentTextView.text
            else { return }
        delegate?.didSubmit(for: commentText)
    }
    
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.displayPlaceholder()
    }

}
