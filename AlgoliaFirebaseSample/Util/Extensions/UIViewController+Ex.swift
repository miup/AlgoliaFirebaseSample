//
//  UIViewController+Ex.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/12.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit

extension UIViewController {
    public func addChild(_ childController: UIViewController) {
        addChildViewController(childController)
        view.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
    }

    public func insertChild(_ childController: UIViewController, belowViewController: UIViewController) {
        addChildViewController(childController)
        view.insertSubview(childController.view, belowSubview: belowViewController.view)
        childController.didMove(toParentViewController: self)
    }

    public func removeFromParent() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }

    public static func transition(from: UIViewController, to: UIViewController, duration: TimeInterval = 0.35, completion: (() -> Void)? = nil) {
        UIView.transition(from: from.view, to: to.view, duration: duration, options: .transitionCrossDissolve) { _ in
            completion?()
        }
    }
}
