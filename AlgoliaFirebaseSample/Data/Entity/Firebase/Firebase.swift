//
//  Firebase.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/12.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Firebase
import Salada

/// Name space for Firebase model
class Firebase {
    typealias ObjectIDSet<T> = Set<String>

    class RootObject: Object {
        override open class var _path: String {
            return "miup/AlgoliaFirebaseSample/\(super._path)"
        }
    }
}


