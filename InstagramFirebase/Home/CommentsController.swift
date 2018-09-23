//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 9/15/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController,
    UICollectionViewDelegateFlowLayout,
    CommentInputAccessoryViewDelegate {
    
    // MARK: - Instance Variables

    var post: Post?
    var comments = [Comment]()
    let cellId = "cellId"
    
    // MARK: - Load View And View Transitions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        // dismiss keyboard when you scroll up and down
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.register(CommentCell.self,
                                 forCellWithReuseIdentifier: cellId)
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Fetch Comments
    
    fileprivate func fetchComments() {
        guard let postId = self.post?.id else { return }
        let commentRef = Database
                            .database()
                            .reference()
                            .child("comments")
                            .child(postId)
        
        commentRef.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any]
                else { return }
            
            guard let uid = dictionary["uid"] as? String
                else { return }
            
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                
                self.collectionView?.reloadData()
            })
          
        }) { (err) in
            print("Failed to observe comments ", err)
        }
    }
    
    // MARK: - Collection View Methods
    
    // must conform to UICollectionViewDelegateFlowLayout protocol to use this
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        /*
            ensures your profile image view and comment text
            field is added before estimating size.
        */
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(40 + 8 + 8, estimatedSize.height)
    
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                      for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.item]
        
        return cell
    }
    
    // MARK: - Container View
    
    lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        
        return commentInputAccessoryView
    }()
    
    func didSubmit(for comment: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postId = self.post?.id else { return }
        let values = ["text": comment,
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
            self.containerView.clearCommentTextField()
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
