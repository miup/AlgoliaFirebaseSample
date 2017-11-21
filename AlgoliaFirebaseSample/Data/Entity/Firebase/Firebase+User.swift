//
//  Firebase+User.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/12.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Firebase
import RxSwift
import Salada

extension Firebase {
    @objcMembers
    class User: RootObject {
        /// User name
        dynamic var name: String?
        dynamic var image: File?

        /// post
        dynamic var posts: Firebase.UserPost = []

        dynamic var follower: Firebase.Follower = []
        dynamic var followee: Firebase.Followee = []
    }

}

extension Firebase.User {

    /// Retrive current user through Auth
    ///
    /// - Parameter completion: Firebase.User (if signed up)
    static func current(_ completion: @escaping (Firebase.User?) -> Void) {
        guard let authUser = Auth.auth().currentUser else {
            return completion(nil)
        }

        self.get(authUser.uid) { user, _ in
            guard let user = user else {
                _ = try? Auth.auth().signOut()
                completion(nil)
                return
            }
            completion(user)
        }
    }


    /// Create New user
    ///
    /// - Parameters:
    ///   - id: Auth.auth().currentUser.uid
    ///   - completion: document_reference or Error
    static func create(id: String, name: String? = nil,  completion: ((DatabaseReference?, Error?) -> Void)? = nil) {
        let user = Firebase.User(id: id)!
        if let name = name {
            user.name = name
        } else {
            let anonymousNames = ["anonymous_cat", "anonymous_dog", "anonymous_fish", "anonymous_bird"]
            user.name = anonymousNames.sample()
        }

        user.save(completion)
    }

    func follow(_ user: Firebase.User) {
        self.followee.insert(user)
        user.follower.insert(self)
    }

    func unfollow(_ user: Firebase.User) {
        self.followee.remove(user)
        user.follower.remove(self)
    }

    func followIfNeeded(_ user: Firebase.User) {
        self.followee.contains(user) { [weak self] isContain in
            if !isContain {
                self?.follow(user)
            }
        }
    }

    func unfollowIfNeeded(_ user: Firebase.User) {
        self.followee.contains(user) { [weak self] isContain in
            if isContain {
                self?.unfollow(user)
            }
        }
    }
}

extension Reactive where Base: Firebase.User {
    static func current() -> Single<Firebase.User?> {
        return .create { observer in
            Base.current { user in
                observer(.success(user))
            }
            return Disposables.create()
        }
    }

    static func create(id: String, name: String? = nil) -> Single<Void> {
        return .create { observer in
            Base.get(id) { (user, error) in
                if let _ = user {
                    observer(.success(()))
                    return
                }
                Base.create(id: id, name: name) { ref, error in
                    switch makeResult(ref, error) {
                    case .success:
                        observer(.success(()))
                    case .failure(let error):
                        observer(.error(error))
                    }
                }
            }
            return Disposables.create()

        }
    }
}
