//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 8/20/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import Firebase

import UIKit
import Firebase

class HomeController: UICollectionViewController,
    UICollectionViewDelegateFlowLayout,
    HomePostCellDelegate {
    
    // MARK: - Instance Variables

    let cellId = "cellId"
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        setupNavigationItems()
        
        fetchAllPosts()
    }
    
    // MARK: - Feed Updates / Refresh
    
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        print("Handling refresh..")
        posts.removeAll()
        fetchAllPosts()
    }
    
    // MARK: - Fetch Posts
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid
            else { return }
        Database
            .database()
            .reference()
            .child("following")
            .child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            
                userIdsDictionary.forEach({ (key, value) in
                    Database.fetchUserWithUID(uid: key, completion: { (user) in
                        self.fetchPostsWithUser(user: user)
                    })
                })
            
            }) { (err) in
                print("Failed to fetch following user ids:", err)
            }
    }
    
    var posts = [Post]()
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView?.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String: Any]
                else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any]
                    else { return }
                
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid
                    else { return }
                
                Database
                    .database()
                    .reference()
                    .child("likes")
                    .child(key)
                    .child(uid)
                    .observe(.value, with: { (snapshot) in
                        
                        if let value = snapshot.value as? Int, value == 1 {
                            post.hasLiked = true
                        } else {
                            post.hasLiked = false
                        }
                        
                        self.posts.append(post)
                        self.posts.sort(by: { (p1, p2) -> Bool in
                            return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                        })
                        
                        self.collectionView?.reloadData()
                        
                    }, withCancel: { (err) in
                        print("Failed to fetch like info for post: ", err)
                    })
            })
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
    
    // MARK: - Navigate to Camera View
    
    func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc func handleCamera() {
        print("Showing camera")
        
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    
    // MARK: - Collection View Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIFormatter.sizeHomeCells(view: view)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.item]
        
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - Comment View Transition
    
    func didTapComment(post: Post) {
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    func didLike(for cell: HomePostCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.item]
        
        guard let postId = post.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [uid: 1]
        Database
            .database()
            .reference()
            .child("likes")
            .child(postId)
            .updateChildValues(values) { (err, _) in
                if let err = err {
                    print("Failed to like post ", err)
                    
                    return
                }
                
                print("Successfully liked post")
                
                post.hasLiked = !post.hasLiked
                
                self.posts[indexPath.item] = post
                
                self.collectionView?.reloadItems(at: [indexPath])
        }
    }
}
