//
//  AlgoliaFeedRequest.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/17.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Algent
import AlgoliaSearch

struct AlgoliaFeedRequest: AlgoliaRequestProtocol {
    typealias HitType = Algolia.Feed

    let page: Int
    let per: Int
    let isLocationEnabled: Bool
    let lng: Double?
    let lat: Double?
    let text: String?
    let radius: Int
    let userIDs: [String]

    var indexName: String {
        return "feed"
    }

    var query: AlgentQuery {
        let query = AlgentQuery(query: text)
        query.page = UInt(page)
        query.hitsPerPage = UInt(per)

        if isLocationEnabled {
            if let lat = lat, let lng = lng {
                query.aroundLatLng = LatLng(lat: lat, lng: lng)
                query.aroundRadius = Query.AroundRadius.explicit(UInt(radius))
            }
        }

        if !userIDs.isEmpty {
            query.facets = ["userID"]
            query.facetFilters = [userIDs.map { "userID:\($0)" }]
        }
        return query
    }

    init(page: Int, per: Int, isLocationEnabled: Bool = false, lng: Double? = nil, lat: Double? = nil, text: String? = nil, radius: Int = 10000, userIDs: [String] = []) {
        self.page = page
        self.per = per
        self.isLocationEnabled = isLocationEnabled
        self.text = text
        self.radius = radius
        self.lat = lat
        self.lng = lng
        self.userIDs = userIDs
    }
}
