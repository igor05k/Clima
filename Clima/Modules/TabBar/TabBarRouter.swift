//
//  TabBarRouter.swift
//  Clima
//
//  Created by Igor Fernandes on 07/03/23.
//

import UIKit

protocol TabBarRouterProtocol {
    var viewController: UITabBarController? { get set }
    static func build() -> UIViewController
}

class TabBarRouter: TabBarRouterProtocol {
    weak var viewController: UITabBarController?

    static func build() -> UIViewController {
        let view = MainTabBarController()
        
        let homeVC = HomeRouter.build()
        let locationsVC = LocationsRouter.build()
        
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        locationsVC.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(systemName: "location"), tag: 2)
        
        view.setViewControllers([homeVC, locationsVC], animated: true)

        let router = TabBarRouter()
        router.viewController = view

        return view
    }
}
