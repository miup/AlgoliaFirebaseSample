//
//  TabBarController.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/12.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    static func build(with user: Firebase.User) -> TabBarController {
        //TODO: 将来的にはuserの属性に応じて画面の構成を変えるかもしれない。現状はCreator前提
        let tabbarController = TabBarController()
        tabbarController.viewControllers = [
            UINavigationController(rootViewController: TimelineViewController()),
            UINavigationController(rootViewController: SearchViewController()),
            UINavigationController(rootViewController: PostViewController.instantiate()),
            UINavigationController(rootViewController: UsersViewController()),
            UINavigationController(rootViewController: AccountViewController())
        ]
        return tabbarController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
