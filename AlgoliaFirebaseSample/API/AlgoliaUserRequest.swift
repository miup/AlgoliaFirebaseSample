//
//  AlgoliaUserRequest.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/18.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Algent
import AlgoliaSearch

class AlgoliaUserRequest: AlgoliaRequestProtocol {
    typealias HitType = Algolia.User

    let text: String?

    var query: AlgentQuery {
        let query = AlgentQuery()
        query.query = text
        return query
    }

    var indexName: String {
        return "user"
    }

    init(page: Int, per: Int, text: String? = nil) {
        self.text = text
    }

}
