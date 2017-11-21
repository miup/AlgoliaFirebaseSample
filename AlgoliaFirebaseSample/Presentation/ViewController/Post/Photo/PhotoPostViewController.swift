//
//  PhotoPostViewController.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/16.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import Instantiate
import Salada
import RxSwift
import CoreLocation
import Alertift

class PhotoPostViewController: ViewController, StoryboardInstantiatable {
    private var image: File?
    private var disposeBag = DisposeBag()

    @IBOutlet weak var locationEnabledSwitch: UISwitch!
    @IBOutlet weak var imageView: UIImageView!

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

    func bind() { }

    @objc func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapImageView(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }

    @IBAction func didTapPostbutton(_ sender: Any) {
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
            .flatMap { [weak self] location -> Single<(Firebase.Photo, CLLocation?)> in
                if (self?.locationEnabledSwitch.isOn ?? true) && location == nil {
                    return Single.error((Firebase.Post.PostError.cantGetLocation))
                }

                return Firebase.Photo.rx.create(image: self!.image!).map { photo in
                    (photo, location)
                }
            }
            .flatMap { [weak self] (arg) -> Single<Firebase.Post> in
                let (photo, location) = arg
                return Firebase.Post.rx.create(
                    contentType: Firebase.Post.ContentType.photo,
                    contentID: photo.id,
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

extension PhotoPostViewController: UIImagePickerControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        guard let image: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        imageView.image = image
        let imageData = UIImageJPEGRepresentation(image, 1.0)!
        self.image = File(data: imageData, mimeType: .jpeg)
    }
}

extension PhotoPostViewController: UINavigationControllerDelegate { }

