//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 9/16/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import Foundation

struct Comment {
    let text: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
