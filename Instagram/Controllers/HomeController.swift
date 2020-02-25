//
//  HomeController.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class HomeController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        
        tabBar.layer.shadowOpacity = 0.12
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        tabBar.layer.shadowRadius = 8
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.masksToBounds = false
        tabBar.isTranslucent = true
        
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        tabBar.tintColor = primaryColor
        
        let feedController = createNavigationController(viewController: FeedController(), title: "Feeds", image: "camera_icon", selectedImage: "selected_camera_icon")
        let messageController = createNavigationController(viewController: MessageController(), title: "Messages", image: "chat_icon", selectedImage: "selected_chat_icon")
        let notificationController = createNavigationController(viewController: NotificationController(), title: "Notifications", image: "noti_icon", selectedImage: "selected_noti_icon")
        let profileController = createNavigationController(viewController: ProfileController(), title: "Profile", image: "profile_icon", selectedImage: "selected_profile_icon")
        
        viewControllers = [feedController, messageController, notificationController, profileController]
    }
    
    private func createNavigationController(viewController: UIViewController, title: String, image: String, selectedImage: String) -> UIViewController {
        viewController.title = title
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

