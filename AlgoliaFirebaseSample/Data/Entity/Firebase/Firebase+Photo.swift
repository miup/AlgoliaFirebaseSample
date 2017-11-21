//
//  Firebase+Photo.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/16.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Salada
import RxSwift

extension Firebase {
    @objcMembers
    class Photo: RootObject {
        dynamic var image: File?
    }
}

extension Reactive where Base: Firebase.Photo {
    static func create(image: File) -> Single<Firebase.Photo> {
        return .create { observer in
            let photo = Firebase.Photo()
            photo.image = image
            photo.save { (ref, error) in
                switch makeResult(ref, error) {
                case .success:
                    observer(.success(photo))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}
