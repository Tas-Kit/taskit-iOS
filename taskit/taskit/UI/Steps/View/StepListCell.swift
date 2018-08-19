//
//  StepListCell.swift
//  taskit
//
//  Created by xieran on 2018/8/19.
//  Copyright © 2018 Snow. All rights reserved.
//

import UIKit

class StepListCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        let imgSize = CGSize(width: 30, height: 30)
        imageView?.frame = CGRect(x: 20, y: (self.frame.height - imgSize.height) / 2, width: imgSize.width, height: imgSize.height)
        imageView?.contentMode = .scaleAspectFit
        
        var txtLabelFrame = textLabel?.frame ?? .zero
        txtLabelFrame.origin.x = imageView?.frame.maxX ?? 0 + 20
        textLabel?.frame = txtLabelFrame
    }

}
