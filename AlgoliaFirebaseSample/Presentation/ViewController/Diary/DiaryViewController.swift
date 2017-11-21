//
//  DiaryViewController.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/18.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import Instantiate

class DiaryViewController: ViewController, StoryboardInstantiatable {
    struct Dependency {
        let diary: Algolia.Diary
    }

    private var diary: Algolia.Diary!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!

    func inject(_ dependency: DiaryViewController.Dependency) {
        self.diary = dependency.diary
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.title = ""
        imageView.load(diary.image.url)
        titleLabel.text = diary.title
        detailLabel.text = diary.detail
    }
}
