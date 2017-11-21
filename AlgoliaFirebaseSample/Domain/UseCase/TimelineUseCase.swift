//
//  TimelineUseCase.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/17.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Algent
import RxSwift

class TimelineUseCase {

    enum TimelineError {
        case cantFetchFeedItems(Error)
    }

    let feeds: Variable<[Algolia.Feed]> = Variable([])
    let timelineErrorSubject: PublishSubject<TimelineError> = PublishSubject<TimelineError>()

    private var page: Int = 0
    private var per: Int = 30
    private let disposeBag = DisposeBag()

    func fetch() {
        Firebase.User.current { me in
            guard let me = me else { return }
            me.followee.ref.observeSingleEvent(of: .value) { [weak self] snapshot in
                guard let value = snapshot.value else { return }
                guard let `self` = self else { return }
                let followeeIDs: [String]
                if value is NSNull {
                    followeeIDs = []
                } else {
                    followeeIDs = Array((value as! [String: Any]).keys)
                }
                let userIDs = followeeIDs + [me.id]
                AlgoliaRepository.shared.fetchFeed(page: self.page, userIDs: userIDs).subscribe(
                    onSuccess: { [weak self] response in
                        self?.feeds.value = response.hits
                    }, onError: { [weak self] error in
                        self?.timelineErrorSubject.onNext(.cantFetchFeedItems(error))
                    }
                ).disposed(by: self.disposeBag)
            }
        }
    }
}
