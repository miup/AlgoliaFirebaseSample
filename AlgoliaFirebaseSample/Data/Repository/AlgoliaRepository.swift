//
//  AlgoliaRepository.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/17.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Algent
import RxSwift
import CoreLocation

class AlgoliaRepository {
    static let shared = AlgoliaRepository()

    private init() { }
}

/// For Feed
extension AlgoliaRepository {
    func fetchFeed(page: Int, per: Int = 30, userIDs: [String] = []) -> Single<AlgoliaResponse<Algolia.Feed>> {
        return .create { observer in
            Algent.shared.search(request: AlgoliaFeedRequest(page: page, per: per, userIDs: userIDs)) { result in
                switch result {
                case .success(let response):
                    observer(.success(response))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    func searchFeed(page: Int, per: Int = 30, location: CLLocation? = nil, text: String? = nil, radius: Int = 10000) -> Single<AlgoliaResponse<Algolia.Feed>> {
        let isLocationEnabled = location != nil ? true : false
        return .create { observer in
            Algent.shared.search(
                request: AlgoliaFeedRequest(
                    page: page,
                    per: per,
                    isLocationEnabled: isLocationEnabled,
                    lng: location?.coordinate.longitude,
                    lat: location?.coordinate.latitude,
                    text: text,
                    radius: radius
                )
            ) { result in
                switch result {
                case .success(let response):
                    observer(.success(response))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}

extension AlgoliaRepository {
    func fetchUser(page: Int, per: Int = 30, text: String? = nil) -> Single<AlgoliaResponse<Algolia.User>> {
        return .create { observer in
            Algent.shared.search(request: AlgoliaUserRequest(page: page, per: per, text: text)) { result in
                switch result {
                case .success(let response):
                    observer(.success(response))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}
