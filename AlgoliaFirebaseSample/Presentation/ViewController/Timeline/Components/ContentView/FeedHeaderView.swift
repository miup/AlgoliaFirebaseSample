//
//  FeedHeaderView.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/17.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import Instantiate

class FeedHeaderView: UIView, NibInstantiatable {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    func configure(userName: String, contentType: Firebase.Post.ContentType, createdAt: TimeInterval) {
        let date = Date(timeIntervalSince1970: createdAt / 1000)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .full
        formatter.timeStyle = .short

        dateLabel.text = formatter.string(from: date)
        switch contentType {
        case .diary:
            titleLabel.text = "\(userName)さんが、日記を投稿しました"
        case .photo:
            titleLabel.text = "\(userName)さんが、写真を投稿しました"
        case .unknown:
            titleLabel.text = "\(userName)さんが、？？を投稿しました"
        }
    }
}
