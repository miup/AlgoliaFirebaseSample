//
//  SearchUseCase.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/17.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation
import Algent

class SearchUseCase {
    enum SearchError {
        case cantFetchFeedItems(Error)
    }

    let feeds: Variable<[Algolia.Feed]> = Variable([])
    let searchErrorSubject: PublishSubject<SearchError> = PublishSubject<SearchError>()

    var page = 0
    var per = 30
    var radius = 10000
    var isLocationEnabled: Variable<Bool> = Variable<Bool>(false)
    var text: Variable<String?> = Variable<String?>(nil)

    private let disposeBag = DisposeBag()

    init() {
        bind()
    }

    func bind() {
        text.asDriver()
            .throttle(0.3)
            .distinctUntilChanged()
            .asObservable()
            .bind(onNext: { [weak self] _ in
                self?.search()
            }).disposed(by: disposeBag)
        isLocationEnabled
            .asObservable()
            .bind(
                onNext: { [weak self] _ in
                    self?.search()
                }
            ).disposed(by: disposeBag)
    }

    func search() {
        Single.just(isLocationEnabled.value)
            .flatMap { isLocationEnabled -> Single<CLLocation?> in
                if isLocationEnabled {
                    return GeoLocationRepository.shared.requestLocation()
                } else {
                    return .just(nil)
                }
            }.flatMap { [weak self] locationOrNil -> Single<AlgoliaResponse<Algolia.Feed>> in
                AlgoliaRepository
                    .shared
                    .searchFeed(page: self?.page ?? 0, per: self?.per ?? 20, location: locationOrNil, text: self?.text.value, radius: self?.radius ?? 10000)
            }.subscribe(
                onSuccess: { [weak self] response in
                    self?.feeds.value = response.hits
                }, onError: { [weak self] error in
                    self?.searchErrorSubject.onNext(.cantFetchFeedItems(error))
                }
            ).disposed(by: disposeBag)
    }
}
