//
//  Firebase+Diary.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/16.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Firebase
import RxSwift
import Salada
import Result

extension Firebase {

    @objcMembers
    class Diary: RootObject {
        dynamic var title: String?
        dynamic var detail: String?
        dynamic var image: File?
    }
}

extension Firebase.Diary {
    static func create(
        title: String,
        detail: String,
        image: File?,
        completion: ((Result<Firebase.Diary, AnyError>) -> Void)? = nil
    ) {
        let diary = Firebase.Diary()
        diary.title = title
        diary.detail = detail
        diary.image = image
        diary.save { (ref, error) in
            switch makeResult(ref, error) {
            case .success:
                completion?(.success(diary))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}

extension Reactive where Base: Firebase.Diary {
    static func create(
        title: String,
        detail: String,
        image: File?
        ) -> Single<Firebase.Diary> {
        return .create { observer in
            Base.create(title: title, detail: detail, image: image) { result in
                switch result {
                case .success(let diary):
                    observer(.success(diary))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }

}
