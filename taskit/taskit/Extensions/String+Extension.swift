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
