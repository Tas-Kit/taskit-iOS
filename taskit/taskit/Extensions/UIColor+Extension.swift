//
//  UIColor+Extension.swift
//  GiveLove
//
//  Created by hxy on 2017/5/8.
//  Copyright © 2017年 中智关爱通. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// convience method to get a color avoiding dividing 255
    /// add prefix '_' due to the error same class name in Objective-C
    ///
    /// - Parameters:
    ///   - red: red
    ///   - green: green
    ///   - blue: blue
    ///   - alpha: alpha
    /// - Returns: UIColor instance
    public class func color(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: alpha)
    }
    
    public class func color(sameValue: Int) -> UIColor {
        return UIColor.color(red: sameValue, green: sameValue, blue: sameValue, alpha: 1)
    }
    
    public class var randomColor: UIColor {
        return UIColor.color(red: randomInt(255), green: randomInt(255), blue: randomInt(255), alpha: 1)
    }

}

public func randomInt(_ upper_bound: Int) -> Int {
    // Generate 64-bit random value in a range that is
    // divisible by upper_bound:
    let range = Int.max - Int.max % upper_bound
    var rnd : Int = 0
    repeat {
        arc4random_buf(&rnd, MemoryLayout.size(ofValue: rnd))
    } while rnd >= range
    return rnd % upper_bound
}

public extension UIColor {
    public convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex         = String(hex.suffix(from: index))
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
