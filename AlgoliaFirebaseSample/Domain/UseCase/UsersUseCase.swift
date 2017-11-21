//
//  UsersUseCase.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/18.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth

class UsersUseCase {

    enum UsersError {
        case cantFetchUser(Error)
    }

    let users: Variable<[Algolia.User]> = Variable<[Algolia.User]>([])
    let text: Variable<String?> = Variable<String?>(nil)
    let usersErrorSubject: PublishSubject<UsersError> = PublishSubject<UsersError>()
    private var page: Int = 0
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
                self?.fetch()
            })
            .disposed(by: disposeBag)
    }
        

    func fetch() {
        AlgoliaRepository.shared
            .fetchUser(page: page, text: text.value)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    self?.users.value = response.hits.filter { $0.objectID != uid }
                }, onError: { [weak self] error in
                    self?.usersErrorSubject.onNext(.cantFetchUser(error))
                }
            ).disposed(by: disposeBag)
    }
}
