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
        tabBar.unselectedItemTintColor = .init(red: 41 / 255, green: 8 / 255, blue: 84 / 255, alpha: 1)
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .tabBarBackground
    }
}

