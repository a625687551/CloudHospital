//
//  ColorExtensions.swift
//  CloudHospital
//
//  Created by wangankui on 22/12/2017.
//  Copyright © 2017 oneday. All rights reserved.
//

import UIKit

extension UIColor {
    static let theme = UIColor(hex: 0x32b16c) // theme
    static let line = UIColor(hex: 0xdddddd) // line
    static let background = UIColor(hex: 0xf5f5f5) // background
    static let black87 = UIColor(hex: 0x212121) // 87%
    static let black54 = UIColor(hex: 0x757575) // 54%
    static let black26 = UIColor(hex: 0xbdbdbd) // 26%

    
    convenience init(red: Int, green: Int, blue: Int, alpha: Float) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha))
    }
    
    convenience init(hex: Int, alpha: Float = 1) {
        self.init(red: (hex >> 16) & 0xff, green: (hex >> 8) & 0xff, blue: hex & 0xff, alpha: alpha)
    }
}
