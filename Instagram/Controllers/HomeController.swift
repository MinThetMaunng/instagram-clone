//
//  HomeController.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class HomeController: UITabBarController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AuthService.instance.isLoggedIn == false {
            let navController = UINavigationController(rootViewController: LoginController())
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: false, completion: nil)
        }
    }
    
    private func setupTabBar() {
        
        tabBar.layer.shadowOpacity = 0.12
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        tabBar.layer.shadowRadius = 8
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.masksToBounds = false
//        tabBar.isTranslucent = false
        
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        tabBar.tintColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        
        let feedController = createNavigationController(viewController: FeedController(), title: "Feeds", image: "home_icon", selectedImage: "selected_home_icon")
        let searchController = createNavigationController(viewController: UIViewController(), title: "Search", image: "search_icon", selectedImage: "selected_search_icon")
        let createPostController = createNavigationController(viewController: CreatePostController(), title: "Create Post", image: "plus_icon", selectedImage: "plus_icon")
        let heartController = createNavigationController(viewController: NotificationController(), title: "Profile", image: "love_icon", selectedImage: "selected_love_icon")
        let profileController = createNavigationController(viewController: ProfileController(), title: "Profile", image: "profile_icon", selectedImage: "selected_profile_icon")
        
        viewControllers = [feedController, searchController, createPostController, heartController, profileController]
    }
    
    private func createNavigationController(viewController: UIViewController, title: String, image: String, selectedImage: String) -> UIViewController {
        viewController.tabBarItem.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        viewController.tabBarItem.selectedImage = UIImage(named: selectedImage)
        viewController.view.backgroundColor = .white
        return UINavigationController(rootViewController: viewController)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if newCollection.userInterfaceStyle == .dark {
            NotificationCenter.default.post(name: CHANGE_TO_DARK, object: nil)
            return
        }
        NotificationCenter.default.post(name: CHANGE_TO_LIGHT, object: nil)
    }

}

