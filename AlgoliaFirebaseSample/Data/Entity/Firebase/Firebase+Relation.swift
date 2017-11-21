//
//  Firebase+Relation.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/16.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Salada

extension Firebase {
    class RootRelation<T: Object>: Relation<T> {
        override class var _version: String {
            return "miup/AlgoliaFirebaseSample/v1"
        }
    }

    class UserPost: RootRelation<Post> {
        override class var _name: String {
            return "user-post"
        }
    }

    class PostLike: RootRelation<User> {
        override class var _name: String {
            return "post-like"
        }
    }

    class Follower: RootRelation<User> {
        override class var _name: String {
            return "user-follower"
        }
    }

    class Followee: RootRelation<User> {
        override class var _name: String {
            return "user-followee"
        }
    }
}
