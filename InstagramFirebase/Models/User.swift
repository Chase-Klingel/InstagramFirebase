//
//  User.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 8/22/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
