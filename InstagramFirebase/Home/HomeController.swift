//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 8/20/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController,
    UICollectionViewDelegateFlowLayout {
    
    // MARK: - Instance Variables

    let cellId = "cellId"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(HomePostCell.self,
                                 forCellWithReuseIdentifier: cellId)
        setupNavigationItems()
        fetchPosts()
    }
    
    // MARK: - Collection View Definition
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8 // username userprofileimageview
        height += view.frame.width
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    // MARK: - Setup Home Feed Instagram Logo
    
    func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        navigationItem.titleView?.contentMode = .scaleAspectFill
    }
    
    // MARK: - Fetch Posts
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // get user data from firebase
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            
            let user = User(dictionary: userDictionary)
            
            // get reference to posts related to current user
            let ref = Database.database().reference().child("posts").child(uid)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                
                // loop each post node in firebase and append to "posts" var
                dictionaries.forEach({ (key, value) in
                    guard let dictionary = value as? [String: Any] else { return }
                    
                    let post = Post(user: user, dictionary: dictionary)
                    
                    self.posts.append(post)
                })
                
                self.collectionView?.reloadData()
                
            }) { (err) in
                print("Failed to fetch posts:", err)
            }
        }) { (err) in
            print("Failed to fetch user for posts: ", err)
        }
    }
}
