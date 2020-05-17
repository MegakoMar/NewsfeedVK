//
//  FeedViewController.swift
//  NewsfeedVK
//
//  Created by Роман Комаров on 16.05.2020.
//  Copyright © 2020 Роман Комаров. All rights reserved.
//

import UIKit
import Alamofire

class FeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private let netWorkService: Networking = NetWorkService()
    private let params = ["filters": "post"]

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavBar()
        netWorkService.request(path: API.newsFeed, params: params, completition: { (url) in
            guard let url = url else {
                return
            }
            AF.request(url).responseJSON { (response) in
                print(response)
            }

        })

//        tableView.delegate = self
//        tableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.navigationBar.barStyle = .black
    }


    // MARK: - Configuatrion NavigationBar

    private func configNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor(red: 60/255, green: 92/255, blue: 255/255, alpha: 1)
        self.title = "Лента"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
}

// MARK: - Extension UITableViewDataSource, UITableViewDelegate

//extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//}
