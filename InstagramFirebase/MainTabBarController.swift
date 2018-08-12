//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 7/22/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (Auth.auth().currentUser == nil) {
            /*
             when app launches for the first time, mainTabCtrl is not setup fully...
             so wait until it is inside the UI, then present loginController
            */
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
                return
            }
            
        }
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController: userProfileController)
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [navController]
    }
}
