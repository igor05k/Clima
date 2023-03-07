//
//  MainTabBarController.swift
//  Clima
//
//  Created by Igor Fernandes on 07/03/23.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        
        tabBar.tintColor = .white
//        tabBar.unselectedItemTintColor = .yellow
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .lightText
    }
}

