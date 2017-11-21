//
//  GeoLocationRepository.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/15.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

enum LocationError: Error {
    case failureGetLocation
}

class GeoLocationRepository {
    static let shared = GeoLocationRepository()

    private let locationManager = CLLocationManager()
    var workers: [GeoLocationWorker] = []

    private init() { }

    func requestLocation() -> Single<CLLocation?> {
        let worker = GeoLocationWorker()
        workers.append(worker)
        return worker.start()
    }

    func requestAuthorize() {
        locationManager.requestWhenInUseAuthorization()
    }
}

class GeoLocationWorker {
    var locationManager: CLLocationManager = CLLocationManager()
    var disposeBag = DisposeBag()

    func start() -> Single<CLLocation?> {
        return .create { [weak self] observer in
            self!.locationManager.rx.didUpdateLocations.subscribe(
                onNext: { event in
                    if let location = event.first {
                        observer(.success(location))
                    } else {
                        observer(.success(nil))
                    }
                },
                onError: { error in
                    observer(.error(error))
                }
            ).disposed(by: self!.disposeBag)
            self!.locationManager.startUpdatingLocation()
            return Disposables.create()
        }
    }

}
