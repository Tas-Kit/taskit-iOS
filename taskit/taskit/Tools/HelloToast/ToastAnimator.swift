//
//  ToastAnimator.swift
//  HelloToastExample
//
//  Created by hxy on 2017/6/1.
//  Copyright © 2017年 hxy. All rights reserved.
//

import UIKit

public class ToastAnimator {

    enum ToastAnimationType {
        case fade
        case zoom
        case slide
    }

    weak var toastView: HelloToastView?
    var animationType: ToastAnimationType = .fade

    private(set) var isShowing = false
    private(set) var isAnimating = false

    required public init(toastView: HelloToastView) {
        self.toastView = toastView
    }

    typealias CompletionClosure = (Bool) -> Void

    func show(completion: CompletionClosure?) {
        isShowing = true
        isAnimating = true
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            self.toastView?.backgroundView?.alpha = 1.0
            self.toastView?.contentView?.alpha = 1.0
        }) { (finished) in
            self.isAnimating = false
            if completion != nil {
                completion!(finished)
            }
        }
    }

    func hide(completion: CompletionClosure?) {
        isShowing = false
        isAnimating = true
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            self.toastView?.backgroundView?.alpha = 0.0
            self.toastView?.contentView?.alpha = 0.0
        }) { (finished) in
            self.isAnimating = false
            if completion != nil {
                completion!(finished)
            }
        }
    }

}
