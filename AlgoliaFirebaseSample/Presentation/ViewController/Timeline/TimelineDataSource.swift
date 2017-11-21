//
//  TimelineDataSource.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/17.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseDatabase

class TimelineDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {
    typealias Element = [Algolia.Feed]

    var feeds: [Algolia.Feed] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FeedCell.dequeue(from: tableView, for: indexPath)
        let feed = feeds[indexPath.row]
        cell.configure(feed)
        cell.didTapLikeActionBlock = {
            Firebase.Post.observeSingle(feed.objectID, eventType: .value) { post in
                guard let post = post else { return }
                Firebase.User.current { user in
                    guard let user = user else { return }
                    post.likes.contains(user) { isContain in
                        if isContain {
                            post.likes.remove(user)
                            cell.likebuttonIsSelected.value = false
                        } else {
                            post.likes.insert(user)
                            cell.likebuttonIsSelected.value = true
                        }
                    }
                }
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, observedEvent: Event<[Algolia.Feed]>) {
        Binder(self) { (dataSource, feeds) in
            dataSource.feeds = feeds
            tableView.reloadData()
        }.on(observedEvent)
    }
}
