//
//  FeedViewController.swift
//  NewsfeedVK
//
//  Created by Роман Комаров on 16.05.2020.
//  Copyright © 2020 Роман Комаров. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavBar()
        fetcher.getFeed { (feedResponse) in
            guard let feedResponse = feedResponse else {
                return
            }
            feedResponse.items.map({ (feedItem) in
//                print(feedItem.date)
            })
        }

        tableView.delegate = self
        tableView.dataSource = self
//        tableView.reloadData()
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

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCellId") else {
            fatalError("Unknowned cell id")
        }

//        if let cell = cell as? NewsfeedCell {
//            cell.nameGroupLabel.text = "Название группы"
//            cell.dateLabel.text = "18.05.2020"
//        }
        return cell
    }
}
