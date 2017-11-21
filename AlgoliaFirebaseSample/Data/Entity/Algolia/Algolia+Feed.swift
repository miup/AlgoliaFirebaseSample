//
//  Algolia+Feed.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/17.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Algent

extension Algolia {
    struct  Feed: Decodable {
        let objectID: String
        let _createdAt: TimeInterval
        let _updatedAt: TimeInterval
        let _geoloc: Algolia.GeoLocation
        let isLocationEnabled: Bool
        let contentType: Int
        let contentID: String
        let userID: String
        let userName: String
        let diary: Algolia.Diary?
        let photo: Algolia.Photo?
        let likes: Algolia.Relation
    }
}
