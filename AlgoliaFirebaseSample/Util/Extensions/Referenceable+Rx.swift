//
//  Referenceable+Rx.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/12.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Firebase
import RxSwift
import Salada

extension Reactive where Base: Object {
    static func observeSingle(_ id: String, eventType: DataEventType) -> Single<Base?> {
        return .create { observer in
            Base.get(id) { (document, error)  in
                if let document = document {
                    observer(.success(document))
                } else {
                    print(error)
                    observer(.success(nil))
                }
            }
            return Disposables.create()
        }
    }

    static func observe(_ id: String, eventType: DataEventType) -> Observable<Base?> {
        return .create { observer in
            let disposeBag: AnyDisposer = Base
                .listen(id) { (document, error) in
                    if let document = document {
                        observer.onNext(document)
                    } else {
                        print(error!)
                        observer.onNext(nil)
                    }
                }
                .toAny()
            return Disposables.create {
                disposeBag.dispose()
            }
        }
    }
}

extension Reactive where Base == Firebase.User {
    static func currrent() -> Single<Base?> {
        return .create { observer in
            Base.current { user in
                observer(.success(user))
            }
            return Disposables.create()
        }
    }
}
