//
//  Firebase+Post.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/14.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Firebase
import RxSwift
import Salada
import Result

extension Firebase {

    @objcMembers
    class Post: RootObject {
        dynamic var lng: Double = 0
        dynamic var lat: Double = 0
        dynamic var isLocationEnabled: Bool = false
        dynamic var contentType: ContentType = .unknown
        dynamic var contentID: String?
        dynamic var userID: String?
        dynamic var likes: PostLike = []

        override func encode(_ key: String, value: Any?) -> Any? {
            switch key {
            case "contentType":
                return contentType.rawValue
            default:
                return nil
            }
        }

        override func decode(_ key: String, value: Any?) -> Any? {
            switch key {
            case "contentType":
                let contentType = (value as? Int).flatMap(ContentType.init(rawValue:)) ?? .unknown
                self.contentType = contentType
                return contentType
            default:
                return nil
            }
        }
    }
}

extension Firebase.Post {
    enum ContentType: Int {
        case unknown
        case diary
        case photo
    }

    enum PostError: Error {
        case cantGetUser
        case cantSavePost(Error)
        case cantGetLocation
    }
}

extension Firebase.Post {
    static func create(
        contentType: ContentType,
        contentID: String,
        lng: Double? = nil,
        lat: Double? = nil,
        isLocationEnabled: Bool,
        completion: ((Result<Firebase.Post, Firebase.Post.PostError>) -> Void)? = nil
    ) {
        Firebase.User.current { user in
            guard let user = user else {
                completion?(.failure(PostError.cantGetUser))
                return
            }
            let post = Firebase.Post()
            post.userID = user.id
            post.contentID = contentID
            post.contentType = contentType
            post.isLocationEnabled = isLocationEnabled
            post.lng = lng ?? 0
            post.lat = lat ?? 0
            post.save { (ref, error) in
                switch makeResult(ref, error) {
                case .success:
                    completion?(.success(post))
                case .failure(let error):
                    completion?(.failure(PostError.cantSavePost(error)))
                }
            }
        }
    }
}

extension Reactive where Base: Firebase.Post {
    static func create(
        contentType: Firebase.Post.ContentType,
        contentID: String,
        lng: Double? = nil,
        lat: Double? = nil,
        isLocationEnabled: Bool
    ) -> Single<Firebase.Post> {
        return .create { observer in
            Base.create(contentType: contentType, contentID: contentID, lng: lng, lat: lat, isLocationEnabled: isLocationEnabled) { result in
                switch result {
                case .success(let post):
                    observer(.success(post))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }

}
