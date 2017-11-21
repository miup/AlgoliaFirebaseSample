//
//  Algolia+Diary.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/17.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Foundation

extension Algolia {
    struct Diary: Decodable {
        let _createdAt: TimeInterval
        let _updatedAt: TimeInterval
        let detail: String
        let title: String
        let image: Image
    }
}
