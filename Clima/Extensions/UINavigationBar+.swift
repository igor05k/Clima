//
//  UINavigationBar+.swift
//  Clima
//
//  Created by Igor Fernandes on 14/03/23.
//

import UIKit

extension UINavigationBar {
    static func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .backgroundColor
        
        self.appearance().standardAppearance = appearance
        self.appearance().scrollEdgeAppearance = appearance
    }
}
