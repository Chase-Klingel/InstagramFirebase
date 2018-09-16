//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 9/16/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import Foundation

struct Comment {
    
    let user: User
    
    let text: String
    let uid: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
