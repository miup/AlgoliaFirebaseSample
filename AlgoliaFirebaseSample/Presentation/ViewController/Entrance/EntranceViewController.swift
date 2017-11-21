//
//  EntranceViewController.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/12.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import Alertift
import RxSwift
import Instantiate
import InstantiateStandard
import SwiftRegExp
import RxOptional

class EntranceViewController: ViewController, StoryboardInstantiatable {
    private enum LoginMethod {
        case password
    }

    private let signInErrorSubject = PublishSubject<Error>()

    private let disposeBag = DisposeBag()

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
        let emailValidation = emailTextField.rx.text.asDriver().filterNil().map {
            try! RegExp(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", options: .caseInsensitive).isMatching($0)
        }.asObservable()

        let passwordValidation = passwordTextField.rx.text.asDriver().filterNil().map {
            $0.count >= 8
        }.asObservable()

        Observable
            .combineLatest([emailValidation, passwordValidation])
            .map { !$0.contains(false) }
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        Observable
            .combineLatest([emailValidation, passwordValidation])
            .map { !$0.contains(false) }
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        loginButton.rx.tap
            .do(onNext: { [weak self] in self?.showIndicator() })
            .flatMap {
                LoginHelper.loginWith(email: self.emailTextField.text!, password: self.passwordTextField.text!, viewController: self)
                    .map { true }
                    .catchError { [weak self] error in
                        self?.signInErrorSubject.onNext(error)
                        return .just(false)
                }
            }
            .do(onNext: { [weak self] _ in self?.hideIndicator() })
            .filter { $0 }.map { _ in () }
            .bind(onNext: RootViewController.shared.userDidLoginSubject.onNext)
            .disposed(by: disposeBag)

        signUpButton.rx.tap
            .do(onNext: { [weak self] in self?.showIndicator() })
            .flatMap {
                LoginHelper.signUpWith(email: self.emailTextField.text!, password: self.passwordTextField.text!, viewController: self)
                    .map { true }
                    .catchError { [weak self] error in
                        self?.signInErrorSubject.onNext(error)
                        return .just(false)
                }
            }
            .do(onNext: { [weak self] _ in self?.hideIndicator() })
            .filter { $0 }.map { _ in () }
            .bind(onNext: RootViewController.shared.userDidLoginSubject.onNext)
            .disposed(by: disposeBag)

        signInErrorSubject
            .subscribe(onNext: { [weak self] error in
                print(error)
                self?.showSignInFailedAlert()
            })
            .disposed(by: disposeBag)
    }

    func showSignInFailedAlert() {
        Alertift
            .alert(title: "ログイン", message: "ログインに失敗しました。再度お試しください。")
            .action(.default("OK"))
            .show(on: self)
    }
}
