//
//  PostViewController.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/16.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import Instantiate

class PostViewController: UIViewController, StoryboardInstantiatable {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "投稿"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "投稿"
    }

    @IBAction func didTapDiaryButton(_ sender: Any) {
        let nc = UINavigationController(rootViewController: DiaryPostViewController.instantiate())
        present(nc, animated: true, completion: nil)
    }

    @IBAction func didTapPhotoButton(_ sender: Any) {
        let nc = UINavigationController(rootViewController: PhotoPostViewController.instantiate())
        present(nc, animated: true, completion: nil)
    }
}
