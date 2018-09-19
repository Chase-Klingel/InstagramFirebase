//
//  UIFormatter.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 9/18/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

class UIFormatter {
    static func sizeHomeCells(view: UIView) -> CGSize {
        var height: CGFloat = 40 + 8 + 8
        height += view.frame.width
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    static func sizeGridCells(view: UIView) -> CGSize {
        let width = (view.frame.width - 2) / 3
        
        return CGSize(width: width, height: width)
    }
}
