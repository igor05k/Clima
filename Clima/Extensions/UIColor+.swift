//
//  UIColor+.swift
//  Clima
//
//  Created by Igor Fernandes on 25/02/23.
//

import UIKit

extension UIColor {
    static var backgroundColor: UIColor {
        return UIColor(named: "backgroundColor") ?? .red
    }
    
    static var labelColor: UIColor {
        return UIColor(named: "labelColor") ?? .red
    }
    
    static var backgroundCell: UIColor {
        return UIColor(named: "backgroundCell") ?? .red
    }
    
    static var tabBarBackground: UIColor {
        return UIColor(named: "tabBarBackground") ?? .red
    }
}

