//
//  AccountViewController.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/17.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alertift

class AccountViewController: ViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "アカウント"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "アカウント"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationButton()
    }

    func addNavigationButton() {
        let bbi = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(didTapLogout(_:)))
        navigationItem.rightBarButtonItem = bbi
    }

    @objc func didTapLogout(_ sender: Any) {
        Alertift.alert(title: "ログアウト", message: "します")
            .action(.default("OK")) { _, _, _ in
                try! Auth.auth().signOut()
            }
            .action(.default("だめ"))
            .show()
    }
}
