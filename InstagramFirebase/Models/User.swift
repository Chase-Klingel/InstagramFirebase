//
//  User.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 8/22/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import Foundation

struct User {
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
