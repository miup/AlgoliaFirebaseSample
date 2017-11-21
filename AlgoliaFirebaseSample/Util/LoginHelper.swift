//
//  LoginHelper.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/12.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Foundation
import Firebase
import FacebookLogin
import FacebookCore
import RxSwift

final class LoginHelper {

    private enum LoginError: Error {
        case cancelled
        case facebookLoginFailed
        case phoneNumberLoginFailed
        case userNotFound
    }

    static func signUpWith(email: String, password: String, viewController: ViewController) -> Single<Void> {
        viewController.showIndicator()
        return Auth.auth().rx.createUserWith(email: email, password: password)
            .flatMap { Firebase.User.rx.create(id: $0.uid) }
            .do(
                onNext: { _ in viewController.hideIndicator()},
                onError: { _ in viewController.hideIndicator() }
            )
    }

    static func loginWith(email: String, password: String, viewController: ViewController) -> Single<Void> {
        viewController.showIndicator()
        return Auth.auth().rx.signInWith(email: email, password: password)
            .flatMap { Firebase.User.rx.create(id: $0.uid) }
            .do(
                onNext: { _ in viewController.hideIndicator()},
                onError: { _ in viewController.hideIndicator() }
        )
    }
}
