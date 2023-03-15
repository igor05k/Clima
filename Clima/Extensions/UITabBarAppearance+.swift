//
//  UITabBarAppearance+.swift
//  Clima
//
//  Created by Igor Fernandes on 15/03/23.
//

import UIKit

extension UITabBarAppearance {
    static func setupAppearance() {
        let tabBarApperance = UITabBarAppearance()
        tabBarApperance.configureWithOpaqueBackground()
        tabBarApperance.backgroundColor = .tabBarBackground
        UITabBar.appearance().scrollEdgeAppearance = tabBarApperance
        UITabBar.appearance().standardAppearance = tabBarApperance
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .init(red: 41 / 255, green: 8 / 255, blue: 84 / 255, alpha: 1)
    }
}
