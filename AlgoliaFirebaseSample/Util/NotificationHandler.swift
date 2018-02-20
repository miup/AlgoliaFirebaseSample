//
//  NotificationHandler.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2018/02/20.
//  Copyright © 2018 kazuya-miura. All rights reserved.
//

import Tsuchi

struct PushNotification: PushNotificationPayload {
    let aps: APS?
}

enum Topic: TopicType {
    case userAction(userID: String)

    var rawValue: String {
        switch self {
        case .userAction(let userID):
            return "user-action-\(userID)"
        }
    }
}

class NotificationHandler {
    static let shared = NotificationHandler()

    private init() {
        // initialize your tsuchi settings
        Tsuchi.shared.showsNotificationBannerOnPresenting = true

        Tsuchi.shared.didRefreshRegistrationTokenActionBlock = { token in
            // save token to your Database
        }

        Tsuchi.shared.subscribe(PushNotification.self) { result in
            switch result {
            case let .success((payload, mode)):
                print("reiceived: \(payload), mode: \(mode)")
            case let .failure(error):
                print("error: \(error)")
            }
        }
    }

    func register() {
        Tsuchi.shared.register { granted in
            if granted {
                print("success registration")
            } else {
                print("failure registration")
            }
        }
    }

    func unregister() {
        Tsuchi.shared.unregister {
            print("unregister")
        }
    }

    func subscribe(topic: Topic) {
        Tsuchi.shared.subscribe(toTopic: topic)
    }

    func unsubscribe(topic: Topic) {
        Tsuchi.shared.unsubscribe(fromTopic: topic)
    }
}
