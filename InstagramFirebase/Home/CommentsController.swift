//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 9/15/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController {
    
    // MARK: - Instance Variables

    var post: Post?
    
    // MARK: - Loading View And View Transitions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        
        collectionView?.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Container View
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, leading: nil,
                            bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor,
                            paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12,
                            width: 50, height: 0)
        
        containerView.addSubview(commentTextField)
        commentTextField.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor,
                         bottom: containerView.bottomAnchor, trailing: submitButton.leadingAnchor,
                         paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0,
                         width: 0, height: 0)
        
        return containerView
    }()
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        
        return textField
    }()
    
    @objc func handleSubmit() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postId = self.post?.id else { return }
        let values = ["text": commentTextField.text ?? "",
                      "creationDate": Date().timeIntervalSince1970,
                      "uid": uid] as [String: Any]
        Database
            .database()
            .reference()
            .child("comments")
            .child(postId)
            .childByAutoId()
            .updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to enter comment: ", err)
                    
                    return
                }
                
                print("Successfully inserted comment.")
        }
    }
        
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
