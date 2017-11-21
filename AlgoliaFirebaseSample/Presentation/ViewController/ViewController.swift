//
//  ViewController.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/12.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
    }

}

extension ViewController {

    final func exclusiveAllTouches() {
        self.exclusiveTouches(view: self.view)
    }

    private func exclusiveTouches(view: UIView) {
        for view in view.subviews {
            let aView = view as UIView
            aView.isExclusiveTouch = true
            self.exclusiveTouches(view: aView)
        }
    }

    func showIndicator(_ message: String? = nil) {
        let window: ActivityIndicator = ActivityIndicator(message)
        WindowManager.default.show(window: window)
        window.indicator.startAnimating()
    }

    func hideIndicator() {
        if let window: ActivityIndicator = WindowManager.default.hide() as? ActivityIndicator {
            window.indicator.stopAnimating()
        }
    }
}
