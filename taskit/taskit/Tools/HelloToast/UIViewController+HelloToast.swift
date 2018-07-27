//
//  UIViewController+HelloToast.swift
//  HelloToastExample
//
//  Created by hxy on 2017/6/9.
//  Copyright © 2017年 hxy. All rights reserved.
//

import UIKit

public extension UIViewController {
    @discardableResult
    public func showLoading(title: String? = "", detail: String? = "", hideAfter delay: TimeInterval = -1, offset: CGPoint = .zero, completion: (() -> Void)? = nil) -> HelloToastView? {
        let toast = HelloToast.showLoading(title: title, detail: detail, in: self.view, hideAfter: delay, completion: completion)
        toast?.offset = offset
        return toast
    }

    @discardableResult
    public func showInfo(title: String? = "", detail: String? = "", hideAfter delay: TimeInterval = 1.5, completion: (() -> Void)? = nil) -> HelloToastView? {
        return HelloToast.showInfo(title: title, detail: detail, in: self.view, hideAfter: delay, completion: completion)
    }

    @discardableResult
    public func showSuccess(title: String? = "", detail: String? = "", hideAfter delay: TimeInterval = 1.5, completion: (() -> Void)? = nil) -> HelloToastView? {
        return HelloToast.showSuccess(title: title, detail: detail, in: self.view, hideAfter: delay, completion: completion)
    }

    @discardableResult
    public func showError(title: String? = "", detail: String? = "", hideAfter delay: TimeInterval = 1.5, completion: (() -> Void)? = nil) -> HelloToastView? {
        return HelloToast.showError(title: title, detail: detail, in: self.view, hideAfter: delay, completion: completion)
    }

    @discardableResult
    public func showTip(title: String? = "", detail: String? = "", hideAfter delay: TimeInterval = 1.5, completion: (() -> Void)? = nil) -> HelloToastView? {
        return HelloToast.showTip(title, detail: detail, in: self.view, hideAfter: delay, completion: completion)
    }

    @discardableResult
    public func show(customView: UIView?, title: String? = "", detail: String? = "", hideAfter delay: TimeInterval = 1.5, completion: (() -> Void)? = nil) -> HelloToastView? {
        return HelloToast.show(customView: customView, title: title, detail: detail, in: self.view, hideAfter: delay, completion: completion)
    }

    public func hideToast() {
        HelloToast.hideToast(in: self.view)
    }
}
