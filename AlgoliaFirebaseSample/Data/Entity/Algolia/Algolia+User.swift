//
//  Algolia+User.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/18.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Foundation

extension Algolia {
    class User: Decodable {
        let name: String
        let posts: Algolia.Relation
        let follower: Algolia.Relation
        let followee: Algolia.Relation
        let objectID: String
        let image: Image?
    }
}
