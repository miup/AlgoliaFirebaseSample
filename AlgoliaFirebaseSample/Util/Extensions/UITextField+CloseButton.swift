//
//  UITextField+CloseButton.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/15.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit

extension UITextField {
    func addCloseButton() {
        let barButton = UIBarButtonItem(
            title: "決定",
            style: .plain,
            target: self,
            action: #selector(UITextField.didTapDone(sender:)))
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [spacer, barButton]
        self.inputAccessoryView = toolbar
    }

    @objc func didTapDone(sender: AnyObject) {
        self.resignFirstResponder()
    }
}
