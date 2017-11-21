//
//  FeedPhotoView.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/17.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import Instantiate
import ImageStore

class FeedPhotoView: UIView, NibInstantiatable {
    @IBOutlet weak var imageView: UIImageView!

    func configure(url: URL) {
        imageView.load(url)
    }
}
