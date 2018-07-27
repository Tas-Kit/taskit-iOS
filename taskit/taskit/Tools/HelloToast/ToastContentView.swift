//
//  ToastContentView.swift
//  HelloToastExample
//
//  Created by hxy on 2017/6/1.
//  Copyright © 2017年 hxy. All rights reserved.
//

import UIKit

class ToastContentView: UIView {

    var customView: UIView? {
        willSet {
            customView?.removeFromSuperview()
        }

        didSet {
            if customView != nil {
                addSubview(customView!)
                setNeedsLayout()
            }
        }
    }
    var titleLabel: UILabel = UILabel()
    var titleLabelText: String? {
        didSet {
            if titleLabelText != nil {
                titleLabel.attributedText = NSAttributedString(string: titleLabelText!, attributes: titelLabelAttributes)
                setNeedsLayout()
            }
        }
    }
    var detailLabel: UILabel = UILabel()
    var detailLabelText: String? {
        didSet {
            if detailLabelText != nil {
                detailLabel.attributedText = NSAttributedString(string: detailLabelText!, attributes: detailLabelAttributes)
                setNeedsLayout()
            }
        }
    }

    var insets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) {
        didSet {
            setNeedsLayout()
        }
    }
    var minimumSize: CGSize = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    var customViewMarginBottom: CGFloat = 8 {
        didSet {
            setNeedsLayout()
        }
    }
    var titleLabelMarginBottom: CGFloat = 4 {
        didSet {
            setNeedsLayout()
        }
    }
    var detailTitleLabelMarginBottom: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    var titelLabelAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.white] {
        didSet {
            setNeedsLayout()
        }
    }
    var detailLabelAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.white] {
        didSet {
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.allowsGroupOpacity = false
        prepareSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func prepareSubviews() {
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.isOpaque = false
        addSubview(titleLabel)

        detailLabel.numberOfLines = 0
        detailLabel.textAlignment = .center
        detailLabel.textColor = .white
        detailLabel.font = UIFont.systemFont(ofSize: 12)
        detailLabel.isOpaque = false
        addSubview(detailLabel)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let hasCustomView = customView != nil
        let hasTitleLabel = titleLabel.text?.count ?? 0 > 0
        let hasDetailLabel = detailLabel.text?.count ?? 0 > 0

        var width: CGFloat = 0
        var height: CGFloat = 0

        let maxContentWidth = size.width - (insets.left + insets.right)
        let maxContentHeight = size.height - (insets.top + insets.bottom)

//        var minY = insets.top

        if hasCustomView {
            width = fmax(width, customView?.bounds.width ?? 0)
            height += customView!.bounds.height + ((hasTitleLabel || hasDetailLabel) ? customViewMarginBottom : 0)
        }

        if hasTitleLabel {
            let textLabelSize = titleLabel.sizeThatFits(CGSize(width: maxContentWidth, height: maxContentHeight))
            width = fmax(width, textLabelSize.width)
            height += textLabelSize.height + (hasDetailLabel ? titleLabelMarginBottom : 0)
        }

        if hasDetailLabel {
            let detailLabelSize = detailLabel.sizeThatFits(CGSize(width: maxContentWidth, height: maxContentHeight))
            width = fmax(width, detailLabelSize.width)
            height += detailLabelSize.height + detailTitleLabelMarginBottom
        }

        width += (insets.left + insets.right)
        height += (insets.top + insets.bottom)

        if __CGSizeEqualToSize(minimumSize, .zero) == false {
            width = fmax(width, minimumSize.width)
            height = fmax(height, minimumSize.height)
        }
        return CGSize(width: fmin(size.width, width), height: fmin(size.height, height))
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let hasCustomView = customView != nil
        let hasTitleLabel = titleLabel.text?.count ?? 0 > 0
        let hasDetailLabel = detailLabel.text?.count ?? 0 > 0

        let contentWidth = bounds.width
        let maxContentWidth = contentWidth - (insets.left + insets.right)

        var minY: CGFloat = insets.top

        if hasCustomView {
            if hasTitleLabel == false, hasDetailLabel == false {
                minY = (bounds.height - customView!.bounds.height) / 2
            }
            let originX: CGFloat = (contentWidth - customView!.bounds.width) / 2
            customView?.frame = CGRect(x: originX, y: minY, width: customView!.bounds.width, height: customView!.bounds.height)
            minY = customView!.frame.maxY + customViewMarginBottom
        }

        if hasTitleLabel {
            let titleLabelSize = titleLabel.sizeThatFits(CGSize(width: maxContentWidth, height: CGFloat.infinity))
            if hasCustomView == false, hasDetailLabel == false {
                minY = (bounds.height - titleLabelSize.height) / 2
            }
            let originX: CGFloat = (contentWidth - maxContentWidth) / 2
            titleLabel.frame = CGRect(x: originX, y: minY, width: maxContentWidth, height: titleLabelSize.height)
            minY = titleLabel.frame.maxY + titleLabelMarginBottom
        }

        if hasDetailLabel {
            let detailLabelSize = detailLabel.sizeThatFits(CGSize(width: maxContentWidth, height: 0))
            if hasCustomView == false, hasTitleLabel == false {
                minY = (bounds.height - detailLabelSize.height) / 2
            }
            let originX: CGFloat = (contentWidth - maxContentWidth) / 2
            detailLabel.frame = CGRect(x: originX, y: minY, width: maxContentWidth, height: detailLabelSize.height)
        }
    }

}
