//
//  FeedCell.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/17.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import Instantiate
import RxSwift

class FeedCell: UITableViewCell, Reusable, NibType {

    private let headerView = FeedHeaderView.instantiate()
    private let diaryView = FeedDiaryView.instantiate()
    private let photoView = FeedPhotoView.instantiate()
    private let actionView = FeedActionView.instantiate()

    var didTapLikeActionBlock: (() -> Void)?
    var likebuttonIsSelected: Variable<Bool> = Variable<Bool>(false)
    var likeCountString: Variable<String> = Variable<String>("0")
    private var likecountHandle: UInt?
    private var postID: String?
    private let disposeBag = DisposeBag()



    @IBOutlet weak var stackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(diaryView)
        stackView.addArrangedSubview(photoView)
        stackView.addArrangedSubview(actionView)
        likebuttonIsSelected.asDriver().drive(actionView.likeButton.rx.isSelected).disposed(by: disposeBag)
        likeCountString.asDriver().drive(actionView.likeCountLabel.rx.text).disposed(by: disposeBag)
    }

    func configure(_ feed: Algolia.Feed) {
        headerView.configure(userName: feed.userName, contentType: Firebase.Post.ContentType(rawValue: feed.contentType)!, createdAt: feed._createdAt)
        likeCountString.value = "\(feed.likes.count)"
        switch Firebase.Post.ContentType(rawValue: feed.contentType)! {
        case .diary:
            diaryView.isHidden = false
            photoView.isHidden = true
            diaryView.configure(title: feed.diary!.title, imageURL: feed.diary!.image.url)
        case .photo:
            photoView.isHidden = false
            diaryView.isHidden = true
            photoView.configure(url: feed.photo!.image.url)
        default:
            break
        }
        actionView.didTapLikeActionBlock = { [weak self] in
            self?.didTapLikeActionBlock?()
        }

        Firebase.Post.observeSingle(feed.objectID, eventType: .value) { post in
            guard let post = post else { return }
            Firebase.User.current { user in
                guard let user = user else { return }
                post.likes.contains(user) { [weak self] isContains in
                    self?.likebuttonIsSelected.value = isContains
                }

            }
        }

        likecountHandle = Firebase.Post.databaseRef.child(feed.objectID).child("likes/count").observe(.value) { [weak self] snapshot in
            if snapshot.exists() {
                self?.likeCountString.value = "\((snapshot.value as? Int) ?? 0)"
            } else {
                self?.likeCountString.value = "0"
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        likebuttonIsSelected.value = false
        likeCountString.value = "0"
        if let postID = postID, let likecountHandle = likecountHandle {
            Firebase.Post.databaseRef.child(postID).child("likes/count").removeObserver(withHandle: likecountHandle)
        }
    }
}
