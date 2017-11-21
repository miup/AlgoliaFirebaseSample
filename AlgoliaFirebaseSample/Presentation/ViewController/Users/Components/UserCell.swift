//
//  UserCell.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/18.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import Instantiate
import RxSwift

class UserCell: UITableViewCell, Reusable, NibType {

    var didTapFollowActionBlock: (() -> Void)?
    var followButtonIsSelected: Variable<Bool> = Variable<Bool>(false)
    private var postCountString: Variable<String> = Variable<String>("0")
    private var postCountHandle: UInt?
    private var followeeCountString: Variable<String> = Variable<String>("0")
    private var followeeCountHandle: UInt?
    private var followerCountString: Variable<String> = Variable<String>("0")
    private var followerCountHandle: UInt?
    private var userID: String?
    private let disposeBag = DisposeBag()

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followeeCountLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        followButtonIsSelected.asDriver().drive(followButton.rx.isSelected).disposed(by: disposeBag)
        postCountString.asDriver().drive(postCountLabel.rx.text).disposed(by: disposeBag)
        followerCountString.asDriver().drive(followerCountLabel.rx.text).disposed(by: disposeBag)
        followeeCountString.asDriver().drive(followeeCountLabel.rx.text).disposed(by: disposeBag)
    }

    func configure(_ user: Algolia.User) {
        userID = user.objectID
        nameLabel.text = user.name
        postCountLabel.text = "\(user.posts.count)"
        followerCountLabel.text = "\(user.follower.count)"
        followeeCountLabel.text = "\(user.followee.count)"

        Firebase.User.observeSingle(user.objectID, eventType: .value) { user in
            guard let user = user else { return }
            Firebase.User.current { me in
                guard let me = me else { return }
                me.followee.contains(user) { [weak self] isContain in
                    self?.followButtonIsSelected.value = isContain
                }
            }
        }

        postCountHandle = Firebase.User.databaseRef.child(user.objectID).child("posts/count").observe(.value) { [weak self] snapshot in
            if snapshot.exists() {
                self?.postCountString.value = "\((snapshot.value as? Int) ?? 0)"
            } else {
                self?.postCountString.value = "0"
            }
        }

        followeeCountHandle = Firebase.User.databaseRef.child(user.objectID).child("followee/count").observe(.value) { [weak self] snapshot in
            if snapshot.exists() {
                self?.followeeCountString.value = "\((snapshot.value as? Int) ?? 0)"
            } else {
                self?.followeeCountString.value = "0"
            }
        }

        followerCountHandle = Firebase.User.databaseRef.child(user.objectID).child("follower/count").observe(.value) { [weak self] snapshot in
            if snapshot.exists() {
                self?.followerCountString.value = "\((snapshot.value as? Int) ?? 0)"
            } else {
                self?.followerCountString.value = "0"
            }
        }
    }

    @IBAction func didTapFollowButton(_ sender: Any) {
        didTapFollowActionBlock?()
    }

    override func prepareForReuse() {
        nameLabel.text = ""
        postCountString.value = "0"
        followeeCountString.value = "0"
        followerCountString.value = "0"
        followButtonIsSelected.value = false

        if let userID = userID, let postCountHandle = postCountHandle {
            Firebase.User.databaseRef.child(userID).child("posts/count").removeObserver(withHandle: postCountHandle)
        }
        if let userID = userID, let followeeCountHandle = followeeCountHandle {
            Firebase.User.databaseRef.child(userID).child("followee/count").removeObserver(withHandle: followeeCountHandle)
        }
        if let userID = userID, let followerCountHandle = followerCountHandle {
            Firebase.User.databaseRef.child(userID).child("follower/count").removeObserver(withHandle: followerCountHandle)
        }
    }
}
