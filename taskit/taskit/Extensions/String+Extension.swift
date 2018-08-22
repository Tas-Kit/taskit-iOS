//
//  String+Extension.swift
//  taskit
//
//  Created by xieran on 2018/7/30.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation

extension String {
    var base64Decoded: String? {
        var encodedStr = self
        if !self.hasSuffix("==") {
            encodedStr.append("==")
        }
        let data = NSData.init(base64Encoded: encodedStr, options: NSData.Base64DecodingOptions.init(rawValue: 0)) ?? NSData()
        return String.init(data: data as Data, encoding: .utf8)
    }
}

extension String {
    func size(_ font: UIFont, _ width: CGFloat, _ height: CGFloat, lineBreakMode: NSLineBreakMode, lineSpacing: CGFloat = 0.0) -> CGSize {
        let para = NSMutableParagraphStyle()
        para.lineSpacing = lineSpacing
        para.lineBreakMode = lineBreakMode
        let size = (self as NSString).boundingRect(with: CGSize(width: width, height: height), options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: para], context: nil).size
        return size
    }
}
