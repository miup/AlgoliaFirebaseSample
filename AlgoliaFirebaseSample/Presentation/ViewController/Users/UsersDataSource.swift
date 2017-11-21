//
//  UserDataSource.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/18.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseDatabase

class UsersDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {
    typealias Element = [Algolia.User]

    var users: [Algolia.User] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserCell.dequeue(from: tableView, for: indexPath)
        let user = users[indexPath.row]
        cell.configure(user)

        cell.didTapFollowActionBlock = {
            Firebase.User.current { me in
                guard let me = me else { return }
                Firebase.User.observeSingle(user.objectID, eventType: .value) { user in
                    guard let user = user else { return }
                    me.followee.contains(user) { isContain in
                        if isContain {
                            me.unfollow(user)
                            cell.followButtonIsSelected.value = false
                        } else {
                            me.follow(user)
                            cell.followButtonIsSelected.value = true
                        }
                    }
                }
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, observedEvent: Event<[Algolia.User]>) {
        Binder(self) { (dataSource, users) in
            dataSource.users = users
            tableView.reloadData()
        }.on(observedEvent)
    }

}
