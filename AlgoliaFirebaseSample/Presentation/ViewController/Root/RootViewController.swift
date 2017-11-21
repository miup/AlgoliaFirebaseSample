//
//  RootViewController.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/12.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import Firebase

class RootViewController: UIViewController {

    enum RouteType: Equatable {
        case entrance
        case main(Firebase.User)

        static func == (lhs: RouteType, rhs: RouteType) -> Bool {
            switch (lhs, rhs) {
            case (.entrance, .entrance): return true
            case (.main, .main): return true
            default: return false
            }
        }
    }

    static let shared = RootViewController()

    private (set) var currentViewController: UIViewController? {
        didSet {
            guard let currentViewController = currentViewController else { return }

            addChild(currentViewController)
            currentViewController.view.frame = view.bounds

            guard let oldViewController = oldValue else { return }

            view.sendSubview(toBack: currentViewController.view)
            UIViewController.transition(from: oldViewController, to: currentViewController) { [weak oldViewController] in
                oldViewController?.removeFromParent()
            }
        }
    }

    private let disposeBag = DisposeBag()

    let userDidLoginSubject = PublishSubject<Void>()
    let currentRoutingType = Variable<RouteType?>(nil)

    private init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bind()
    }

    private func bind() {
        Observable.merge(
            .just(Auth.auth().currentUser),
            Auth.auth().rx.addStateDidChangeListener().map { $1 }.filter { $0 == nil }, // only signout
            userDidLoginSubject.map { Auth.auth().currentUser }
            )
            .flatMapLatest { authUser -> Single<Firebase.User?> in
                authUser.flatMap { Firebase.User.rx.observeSingle($0.uid, eventType: .value) } ?? .just(nil)
            }
            .map { user -> RouteType in
                guard let user = user else { return .entrance }
                return .main(user)
            }
            .bind(to: currentRoutingType)
            .disposed(by: disposeBag)

        currentRoutingType.asObservable()
            .filterNil()
            .distinctUntilChanged()
            .bind { [weak self] routeType in
                guard let `self` = self else { return }
                switch routeType {
                case .entrance:
                    self.currentViewController = EntranceViewController.instantiate()
                case .main(let user):
                    self.currentViewController = TabBarController.build(with: user)
                }
            }
            .disposed(by: disposeBag)
    }
}
