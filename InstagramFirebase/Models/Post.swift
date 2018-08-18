//
//  Posts.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 8/17/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import Foundation

struct Post {
    let imageUrl: String
    
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
