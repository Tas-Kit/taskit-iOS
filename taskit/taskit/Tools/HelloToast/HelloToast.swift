//
//  HelloToast+Show.swift
//  HelloToastExample
//
//  Created by hxy on 2017/6/2.
//  Copyright © 2017年 hxy. All rights reserved.
//

import UIKit

public class HelloToast {
    @discardableResult
    public class func showLoading(title: String? = "", detail: String? = "", in view: UIView? = UIApplication.shared.keyWindow, hideAfter delay: TimeInterval = -1, completion: (() -> Void)? = nil) -> HelloToastView? {

        let customView = ToastLoadingCircle(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        customView.startAnimating()
        let toastView = show(customView: customView, title: title, detail: detail, in: view, hideAfter: delay, completion: completion)
        toastView?.contentView?.minimumSize = CGSize(width: 88, height: 88)
        return toastView
    }

    @discardableResult
    public class func showInfo(title: String? = "", detail: String? = "", in view: UIView? = UIApplication.shared.keyWindow, hideAfter delay: TimeInterval = 1.5, completion: (() -> Void)? = nil) -> HelloToastView? {
        let customView = UIImageView(image: UIImage(named: "hellotoast_info"))
        let toastView = show(customView: customView, title: title, detail: detail, in: view, hideAfter: delay, completion: completion)
        toastView?.contentView?.minimumSize = CGSize(width: 88, height: 88)
        return toastView
    }

    @discardableResult
    public class func showSuccess(title: String? = "", detail: String? = "", in view: UIView? = UIApplication.shared.keyWindow, hideAfter delay: TimeInterval = 1.5, completion: (() -> Void)? = nil) -> HelloToastView? {
        let customView = UIImageView(image: UIImage(named: "hellotoast_done"))
        let toastView = show(customView: customView, title: title, detail: detail, in: view, hideAfter: delay, completion: completion)
        toastView?.contentView?.minimumSize = CGSize(width: 88, height: 88)
        return toastView
    }

    @discardableResult
    public class func showError(title: String? = "", detail: String? = "", in view: UIView? = UIApplication.shared.keyWindow, hideAfter delay: TimeInterval = 1.5, completion: (() -> Void)? = nil) -> HelloToastView? {
        let customView = UIImageView(image: UIImage(named: "hellotoast_error"))
        let toastView = show(customView: customView, title: title, detail: detail, in: view, hideAfter: delay, completion: completion)
        toastView?.contentView?.minimumSize = CGSize(width: 88, height: 88)
        return toastView
    }

    @discardableResult
    public class func showTip(_ title: String? = "", detail: String? = "", in view: UIView? = UIApplication.shared.keyWindow, hideAfter delay: TimeInterval = 1.5, completion: (() -> Void)? = nil) -> HelloToastView? {
        let toastView = show(customView: nil, title: title, detail: detail, in: view, hideAfter: delay, completion: completion)
        toastView?.contentView?.minimumSize = CGSize(width: 180, height: 36)
        return toastView
    }

    @discardableResult
    public class func show(customView: UIView?, title: String? = "", detail: String? = "", in view: UIView? = UIApplication.shared.keyWindow, hideAfter delay: TimeInterval = 1.5, completion: (() -> Void)? = nil) -> HelloToastView? {
        guard let v = view else {
            return nil
        }
        let toastView = createToastView(in: v)
        toastView.contentView?.titleLabelText = title ?? ""
        toastView.contentView?.detailLabelText = detail ?? ""
        if let _customView = customView {
            toastView.contentView?.customView = _customView
        }
        toastView.show(animated: true)
        if delay > 0 {
            toastView.hide(animated: true, delay: delay, completion: completion)
        }
        return toastView
    }

    public class func hideToast(in view: UIView? = UIApplication.shared.keyWindow) {
        let toasts = allToast(in: view)
        for toast in toasts {
            toast.hide(animated: true)
        }
    }

    public class func allToast(in view: UIView? = UIApplication.shared.keyWindow) -> [HelloToastView] {
        guard let v = view else {
            return []
        }
        let toasts: [HelloToastView] = v.subviews.filter { (vv) -> Bool in
            return vv.isKind(of: HelloToastView.self)
            } as! [HelloToastView]
        return toasts
    }

    private class func createToastView(in view: UIView) -> HelloToastView {
        let toastView = HelloToastView(with: view)
        toastView.offset = toastOffset
        view.addSubview(toastView)
        return toastView
    }

    public class func setup() {
        addKeyboardObserver()
    }

    static func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(showNetworkError(noti:)), name: .kNetworkErrorNotification, object: nil)
    }

    private static var toastOffset: CGPoint = .zero
    @objc static func keyboardWillShow(noti: Notification) {
        let value = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        toastOffset = CGPoint(x: 0, y: -value.cgRectValue.height/2)
    }

    @objc static func keyboardWillHide() {
        toastOffset = .zero
    }

    @objc static func showNetworkError(noti: Notification) {
        let userInfo = noti.userInfo ?? [:]
        let msg = (userInfo["msg"] as? String) ?? ""
        showTip(msg)
    }
}
