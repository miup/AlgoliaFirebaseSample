//
//  ActivityIndicator.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/12.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit

final class ActivityIndicator: UIWindow {

    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    var message: String? {
        didSet {
            self.messageLabel.text = message
            self.setNeedsLayout()
        }
    }

    convenience init(_ message: String? = nil) {
        self.init(frame: UIScreen.main.bounds)
        self.message = message
        self.messageLabel.text = message
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.windowLevel = UIWindowLevelAlert
        self.addSubview(self.indicator)
        self.addSubview(self.messageLabel)
        self.isHidden = true
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.45)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.indicator.center = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
        self.messageLabel.sizeToFit()
        self.messageLabel.frame = CGRect(x: 0, y: self.indicator.frame.minY - 16 - self.messageLabel.bounds.height, width: self.bounds.width, height: self.messageLabel.bounds.height)
    }

    func show() {
        self.makeKeyAndVisible()
        self.indicator.startAnimating()
        self.isHidden = false
    }

    func hide() {
        self.indicator.stopAnimating()
        self.isHidden = true
        (UIApplication.shared.delegate as? AppDelegate)?.window?.makeKeyAndVisible()
    }

    // MARK: -

    private(set) lazy var messageLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.shadowColor = UIColor(white: 0, alpha: 0.3)
        label.shadowOffset = CGSize(width: 0, height: 1)
        return label
    }()
}
