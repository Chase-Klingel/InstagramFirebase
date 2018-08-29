//
//  FirebaseUtils.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 8/28/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        // get user data from firebase
        let userRef = Database.database().reference().child("users").child(uid)
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
            
        }) { (err) in
            print("Failed to fetch user for posts: ", err)
        }
    }
}
