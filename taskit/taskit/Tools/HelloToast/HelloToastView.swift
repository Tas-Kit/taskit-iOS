//
//  ToastView.swift
//  HelloToastExample
//
//  Created by hxy on 2017/6/1.
//  Copyright © 2017年 hxy. All rights reserved.
//

import UIKit

public class HelloToastView: UIView {

    public enum HelloToastPosition {
        case top
        case center
        case bottom
    }

    weak var parentView: UIView!
    public var toastPosition: HelloToastPosition = .center
    var backgroundView: ToastBackgroundView? {
        willSet {
            if backgroundView != nil {
                backgroundView?.removeFromSuperview()
            }
        }
        didSet {
            backgroundView?.alpha = 0
            if backgroundView != nil {
                addSubview(backgroundView!)
            }
            setNeedsLayout()
        }
    }

    var contentView: ToastContentView? {
        willSet {
            if contentView != nil {
                contentView?.removeFromSuperview()
            }
        }

        didSet {
            contentView?.alpha = 0
            if contentView != nil {
                addSubview(contentView!)
            }
            setNeedsLayout()
        }
    }
    var h_maskView = UIView()

    var marginInsets: UIEdgeInsets = .zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    var offset: CGPoint = .zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    var toastAnimator: ToastAnimator?

    init(with view: UIView) {
        super.init(frame: view.bounds)
        parentView = view
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        backgroundView = HelloToastView.defaultBackgroundView()
        contentView = HelloToastView.defaultContentView()

        isOpaque = false
        alpha = 0
        backgroundColor = .clear
        layer.allowsGroupOpacity = false
        tintColor = .white

        h_maskView.backgroundColor = .clear
        addSubview(h_maskView)
    }

    class func defaultBackgroundView() -> ToastBackgroundView {
        let backgroundView = ToastBackgroundView()
        return backgroundView
    }

    class func defaultContentView() -> ToastContentView {
        let contentView = ToastContentView()
        return contentView
    }

    func defaultToastAnimator() -> ToastAnimator {
        return ToastAnimator(toastView: self)
    }

    override public func removeFromSuperview() {
        super.removeFromSuperview()
        parentView = nil
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        frame = parentView.bounds
        h_maskView.frame = self.bounds

        let contentWidth = parentView.bounds.width
        let contentHeight = parentView.bounds.height

        let limitWidth = contentWidth - (marginInsets.left + marginInsets.right)
        let limitHeight = contentHeight - (marginInsets.top + marginInsets.bottom)

        //deal keyboard

        if contentView != nil {
            let contentViewSize = contentView!.sizeThatFits(CGSize(width: limitWidth, height: limitHeight))
            let contentViewX = fmax(marginInsets.left, (contentWidth - contentViewSize.width) / 2) + offset.x
            var contentViewY = fmax(marginInsets.top, (contentHeight - contentViewSize.height) / 2) + offset.y

            switch toastPosition {
            case .top:
                contentViewY = marginInsets.top + offset.y
            case .bottom:
                contentViewY = contentHeight - contentViewSize.height - marginInsets.bottom + offset.y
            default:
                break
            }
            let contentRect = CGRect(x: contentViewX, y: contentViewY, width: contentViewSize.width, height: contentViewSize.height)
            contentView?.frame = contentRect.applying((contentView?.transform)!)
        }

        if backgroundView != nil {
            backgroundView?.frame = (contentView?.frame)!
        }
    }

    func show(animated: Bool) {
        setNeedsLayout()
        alpha = 1.0

        //delegate

        if animated {
            if toastAnimator == nil {
                toastAnimator = defaultToastAnimator()
            }
            toastAnimator?.show(completion: { (_) in
                self.didShow()
            })
        } else {
            backgroundView?.alpha = 1.0
            contentView?.alpha = 1.0
            self.didShow()
        }
    }

    func didShow() {

    }

    func hide(animated: Bool, completion: (() -> Void)? = nil) {
        if animated {
            if toastAnimator == nil {
                toastAnimator = defaultToastAnimator()
            }
            toastAnimator?.hide(completion: { (_) in
                self.didHide()
                if completion != nil {
                    completion!()
                }
            })
        }
    }

    func didHide() {
        (self.contentView?.customView as? ToastLoadingCircle)?.stopAnimating()

        alpha = 0.0
        removeFromSuperview()
    }

    func hide(animated: Bool, delay: TimeInterval, completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.hide(animated: animated, completion: completion)
        }
    }
}
