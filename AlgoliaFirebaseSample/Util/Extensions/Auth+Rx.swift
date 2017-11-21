//
//  Auth+Rx.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/12.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//


import Foundation
import Firebase
import RxSwift

enum AuthError: Error {
    case currentAuthUserNotFound
}

extension Reactive where Base: Auth {
    func addStateDidChangeListener() -> Observable<(Auth, User?)> {
        return .create { observer in
            let handle = self.base.addStateDidChangeListener { auth, user in
                observer.on(.next((auth, user)))
            }
            return Disposables.create {
                self.base.removeStateDidChangeListener(handle)
            }
        }
    }

    func createUserWith(email: String, password: String) -> Single<User> {
        return .create { [weak base] observer in
            base?.createUser(withEmail: email, password: password) { user, error in
                switch makeResult(user, error) {
                case .success(let user):
                    observer(.success(user))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    func signInWith(email: String, password: String) -> Single<User> {
        return .create { [weak base] observer in
            base?.signIn(withEmail: email, password: password) { user, error in
                switch makeResult(user, error) {
                case .success(let user):
                    observer(.success(user))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    func signOut() -> Single<Void> {
        return .create { [weak base] observer in
            do {
                try base?.signOut()
                observer(.success(()))
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
}

extension Reactive where Base: User {
    func link(with credential: AuthCredential) -> Single<User> {
        return .create { [weak base] observer in
            base?.link(with: credential) { authUser, error in
                switch makeResult(authUser, error) {
                case .success(let user):
                    observer(.success(user))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    func unlink(with provider: String) -> Single<User> {
        return .create { [weak base] observer in
            base?.unlink(fromProvider: provider) { authUser, error in
                switch makeResult(authUser, error) {
                case .success(let user):
                    observer(.success(user))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}
