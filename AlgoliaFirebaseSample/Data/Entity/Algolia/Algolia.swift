//
//  Algolia.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/17.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Foundation

class Algolia {
    struct GeoLocation: Decodable {
        let lng: Double
        let lat: Double
    }

    struct Image: Decodable {
        let mimeType: String
        let name: String
        let url: URL
    }

    struct Relation: Decodable {
        let count: Int
    }
}
