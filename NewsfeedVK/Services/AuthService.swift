//
//  AuthService.swift
//  NewsfeedVK
//
//  Created by Роман Комаров on 16.05.2020.
//  Copyright © 2020 Роман Комаров. All rights reserved.
//

import Foundation
import VKSdkFramework

protocol AuthServiceDelegate: class {
    func authServiceShouldShow(viewController: UIViewController)
    func authServiceSingIn()
    func authServiceSingInDidFail()
}

class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {

    private let appID = "7468016"
    private let vkSdk: VKSdk

    weak var delegate: AuthServiceDelegate?

    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }

    override init() {
        vkSdk = VKSdk.initialize(withAppId: appID)
        super.init()
//        print("VKSdk.initialize")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }

    // MARK: - wakeUpSession

    func wakeUpSession() {
        let scope = ["offline", "wall", "friends"]
        VKSdk.wakeUpSession(scope, complete: { (state, error) in
            switch state {

            case .initialized:
//                print("initialized")
                VKSdk.authorize(scope)
            case .authorized:
//                print("authorized")
                self.delegate?.authServiceSingIn()
            default:
                self.delegate?.authServiceSingInDidFail()
            }
        })
    }

    // MARK: - Methods of VKSdkDelegate and VKSdkUIDelegate

    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        if result.token != nil {
            delegate?.authServiceSingIn()
        }
    }

    func vkSdkUserAuthorizationFailed() {
        print(#function)
        delegate?.authServiceSingInDidFail()
    }

    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        delegate?.authServiceShouldShow(viewController: controller)
    }

    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
}
