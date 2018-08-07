//
//  Tools.swift
//  taskit
//
//  Created by xieran on 2018/7/25.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation

func LocalizedString(_ str: String) -> String{
    return NSLocalizedString(str, comment: "")
}

func imageWithNumber(_ num: Int, size: CGSize, font: UIFont) -> UIImage {
    let numString = "\(num)"
    let size = CGSize(width: size.width / 3, height: size.height)
    let textSize = (numString as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil).size
   
    UIGraphicsBeginImageContext(size)
    let context = UIGraphicsGetCurrentContext()
    context?.addArc(center: CGPoint(x: size.width / 2, y: size.height / 2), radius: 10, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
    context?.strokePath()
    
    (numString as NSString).draw(at: CGPoint(x: size.width / 2 - textSize.width / 2, y: size.height / 2 - textSize.height / 2), withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10), NSAttributedStringKey.foregroundColor: UIColor.black])
    let image = UIGraphicsGetImageFromCurrentImageContext()
    return image!
}

func usernameFirstLetter() -> String {
    if let username = KeychainTool.value(forKey: .username) as? String, !username.isEmpty {
        let firstLetter = String(username.first!).uppercased()
        return firstLetter
    }
    return ""
}
