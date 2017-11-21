//
//  DiaryPostViewController.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/12.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import Instantiate
import CoreLocation
import RxSwift
import RxCocoa
import Salada
import Alertift
import RxOptional
import RxKeyboard

class DiaryPostViewController: ViewController, StoryboardInstantiatable {

    private var image: File?
    private var disposeBag = DisposeBag()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField! {
        didSet {
            titleTextField.addCloseButton()
        }
    }
    @IBOutlet weak var detailTextView: UITextView! {
        didSet {
            detailTextView.addCloseButton()
        }
    }
    @IBOutlet weak var locationEnabledSwitch: UISwitch!
    @IBOutlet weak var scrollView: UIScrollView!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = "投稿"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        title = "投稿"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationButton()
        bind()
    }

    func addNavigationButton() {
        let bbi = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel(_:)))
        navigationItem.rightBarButtonItem = bbi
    }

    func bind() {
        RxKeyboard.instance.visibleHeight.drive(
            onNext: { [weak self] height in
                let tabBarHeight: CGFloat = self?.tabBarController?.tabBar.frame.height ?? 0
                self?.scrollView.contentInset.bottom = height - tabBarHeight
            }
        ).disposed(by: disposeBag)
    }

    @IBAction func didTapImageView(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }

    @objc func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapPostButton(_ sender: Any) {
        showIndicator()

        Observable
            .just(locationEnabledSwitch.isOn)
            .flatMap { isLocationEnabled -> Single<CLLocation?> in
                if isLocationEnabled {
                    return GeoLocationRepository.shared.requestLocation()
                } else {
                    return Single.just(nil)
                }
            }
            .flatMap { [weak self] location -> Single<(Firebase.Diary, CLLocation?)> in
                if (self?.locationEnabledSwitch.isOn ?? true) && location == nil {
                    return Single.error((Firebase.Post.PostError.cantGetLocation))
                }

                return Firebase.Diary.rx.create(
                    title: self?.titleTextField.text ?? "",
                    detail: self?.detailTextView.text ?? "",
                    image: self?.image)
                    .map { diary in
                        (diary, location)
                    }
            }
            .flatMap { [weak self] (diary, location) -> Single<Firebase.Post> in
                Firebase.Post.rx.create(
                    contentType: Firebase.Post.ContentType.diary,
                    contentID: diary.id,
                    lng: location?.coordinate.longitude,
                    lat: location?.coordinate.latitude,
                    isLocationEnabled: self?.locationEnabledSwitch.isOn ?? false)
            }
            .asSingle()
            .flatMap { post -> Single<Void> in
                Firebase.User.rx.current().asObservable().filterNil().map { user in
                    user.posts.insert(post)
                }.asSingle()
            }
            .subscribe(
                onSuccess: { [weak self] diary in
                    self?.hideIndicator()
                    self?.dismiss(animated: true)
                },
                onError: { [weak self] error in
                    print(error)
                    guard let `self` = self else { return }
                    self.hideIndicator()
                    Alertift.alert(title: "失敗", message: "ざんねん").action(.default("OK")).show(on: self, completion: nil)
                }
            ).disposed(by: disposeBag)
    }

}

extension DiaryPostViewController: UIImagePickerControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        guard let image: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        imageView.image = image
        let imageData = UIImageJPEGRepresentation(image, 1.0)!
        self.image = File(data: imageData, mimeType: .jpeg)
    }
}

extension DiaryPostViewController: UINavigationControllerDelegate { }
