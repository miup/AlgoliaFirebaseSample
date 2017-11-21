//
//  FeedDiaryView.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/17.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import Instantiate
import ImageStore

class FeedDiaryView: UIView, NibInstantiatable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    func configure(title: String, imageURL: URL) {
        titleLabel.text = title
        imageView.load(imageURL)
    }
}
