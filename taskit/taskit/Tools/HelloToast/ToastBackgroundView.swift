//
//  ToastBackgroundView.swift
//  HelloToastExample
//
//  Created by hxy on 2017/6/1.
//  Copyright © 2017年 hxy. All rights reserved.
//

import UIKit

class ToastBackgroundView: UIView {

    var shouldBlurBackgroundView = false {
        didSet {
            if shouldBlurBackgroundView {
                let effect = UIBlurEffect(style: .light)
                let effectView = UIVisualEffectView(effect: effect)
                effectView.layer.cornerRadius = 10
                effectView.layer.masksToBounds = true
                addSubview(effectView)
                self.effectView = effectView
            } else {
                if self.effectView != nil {
                    self.effectView?.removeFromSuperview()
                    self.effectView = nil
                }
            }
        }
    }
    var styleColor: UIColor?
    var viewCornerRadius: CGFloat = 10.0 {
        didSet {
            if effectView != nil {
                effectView?.layer.cornerRadius = viewCornerRadius
            }
        }
    }
    private var effectView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.allowsGroupOpacity = false
        backgroundColor = UIColor(white: 0, alpha: 0.8)
        layer.cornerRadius = 10
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if effectView != nil {
            effectView?.frame = bounds
        }
    }
}
