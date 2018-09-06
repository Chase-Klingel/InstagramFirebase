//
//  UserSearchController.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 8/28/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

class UserSearchController: UICollectionViewController,
    UICollectionViewDelegateFlowLayout {
    
    // MARK: - Instance Variables

    let cellId = "cellId"
    
    // MARK: - UI Element Definitions

    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.barTintColor = .gray
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor
            = UIColor.rgb(red: 230, green: 230, blue: 230)
        
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        let navBar = navigationController?.navigationBar

        navBar?.addSubview(searchBar)
        
        searchBar.anchor(top: navBar?.topAnchor, leading: navBar?.leadingAnchor,
                         bottom: navBar?.bottomAnchor, trailing: navBar?.trailingAnchor,
                         paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8,
                         width: 0, height: 0)
        
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
    }
    
    // MARK: - Collection View Definition
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        return cell
    }
    
    
}
