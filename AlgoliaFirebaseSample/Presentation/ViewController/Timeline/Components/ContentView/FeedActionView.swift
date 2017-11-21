//
//  FeedActionView.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/17.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import Instantiate
import RxSwift

class FeedActionView: UIView, NibInstantiatable {

    var didTapLikeActionBlock: (() -> Void)?

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func didTapLikeButton(_ sender: Any) {
        didTapLikeActionBlock?()
    }
}
