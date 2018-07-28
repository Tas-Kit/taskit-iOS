//
//  ToastLoadingCircle.swift
//  GiveLove
//
//  Created by xieran on 2017/8/2.
//  Copyright © 2017年 中智关爱通. All rights reserved.
//

import Foundation
import UIKit

class ToastLoadingCircle: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.image = UIImage(named: "loading_toast_circle")

        self.layer.edgeAntialiasingMask = [.layerBottomEdge, .layerTopEdge, .layerLeftEdge, .layerRightEdge]
        self.layer.allowsEdgeAntialiasing = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func startAnimating() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = acos(self.layer.affineTransform().a)
        animation.toValue = acos(self.layer.affineTransform().a) + CGFloat(Double.pi * 2)
        animation.duration = 0.6
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: "rotate")
    }

    override func stopAnimating() {
        self.layer.removeAnimation(forKey: "rotate")
    }
}
