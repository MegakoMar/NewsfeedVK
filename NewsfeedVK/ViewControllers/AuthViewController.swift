//
//  ViewController.swift
//  NewsfeedVK
//
//  Created by Роман Комаров on 15.05.2020.
//  Copyright © 2020 Роман Комаров. All rights reserved.
//

import UIKit
import VKSdkFramework

class AuthViewController: UIViewController {
    @IBOutlet weak var authButton: UIButton!

    private var authService: AuthService!

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavBar()
        configAuthButton()

        authService = SceneDelegate.shared().authService
    }


    // MARK: - Configuration authButton

    private func configAuthButton() {
        authButton.layer.cornerRadius = 10
    }

    // MARK: - Configuatrion NavigationBar

    private func configNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    // MARK: - Settings action of authButton

    @IBAction func authButtonAction(_ sender: UIButton) {
        authService.wakeUpSession()
    }
}

