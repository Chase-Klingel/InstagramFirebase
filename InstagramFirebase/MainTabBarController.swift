//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 7/22/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController,
    UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            
            present(navController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
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
        
        setupViewControllers()
    }
    
    func setupViewControllers() {
        let layout = UICollectionViewFlowLayout()

        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"),
                                                      selectedImage: #imageLiteral(resourceName: "home_selected"),
                                                      rootViewController: HomeController(collectionViewLayout: layout))
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"),
                                                        selectedImage: #imageLiteral(resourceName: "search_selected"),
                                                        rootViewController: UserSearchController(collectionViewLayout: layout))
        let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        let likeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        let userProfileNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"),
                                                             selectedImage: #imageLiteral(resourceName: "profile_selected"),
                                                             rootViewController: UserProfileController(collectionViewLayout: layout))
        
        tabBar.tintColor = .black
        
        viewControllers = [homeNavController,
                           searchNavController,
                           plusNavController,
                           likeNavController,
                           userProfileNavController]
        
        // modify tab bar item insets
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4,
                                            left: 0,
                                            bottom: -4,
                                            right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage,
                                           selectedImage: UIImage,
                                           rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        
        return navController
        
    }
}
