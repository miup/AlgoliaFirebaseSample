//
//  WindowManager.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/12.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit

final class WindowManager {

    static let `default`: WindowManager = WindowManager()

    private var windows: [UIWindow] = []

    var topWindow: UIWindow? {
        return self.windows.last
    }

    /**
     新しいWindowを表示する
     */
    func show(window: UIWindow) {
        self.windows.append(window)
        window.makeKeyAndVisible()
    }

    /**
     最後に表示したWindowを削除
     */
    func hide() -> UIWindow? {
        guard !self.windows.isEmpty else {
            return nil
        }
        let removeWindow = self.windows.removeLast()
        if let window: UIWindow = self.windows.last {
            window.makeKeyAndVisible()
        }
        return removeWindow
    }
}
