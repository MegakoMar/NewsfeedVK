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

    private var feedViewModel = FeedViewModel.init(cells: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavBar()

        tableView.delegate = self
        tableView.dataSource = self

        fetcher.getFeed { (feedResponse) in
            guard let feedResponse = feedResponse else {
                return
            }

            self.feedViewModel = creatingFeedViewModel(feedResponse: feedResponse)
            self.tableView.reloadData()
        }
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

// MARK: - Creating FeedViewModel

private func creatingFeedViewModel(feedResponse: FeedResponse) -> FeedViewModel {
    let cells = feedResponse.items.map { (feedItem) in
        cellViewModel(from: feedItem, profiles: feedResponse.profiles, groups: feedResponse.groups)
    }
    return FeedViewModel.init(cells: cells)
}

// MARK: - CellViewModel

private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group]) -> FeedViewModel.Cell {
    let profile = searchProfile(for: feedItem.sourceId, profiles: profiles, groups: groups)
    let date = Date(timeIntervalSince1970: feedItem.date)

    let dateFormatter: DateFormatter = {
        let date = DateFormatter()
        date.locale = Locale(identifier: "ru_RU")
        date.dateFormat = "d MMM 'в' HH:mm"
        return date
    }()

    let dateTitle = dateFormatter.string(from: date)

    return FeedViewModel.Cell.init(
        iconGroupImage: profile.photo,
        groupName: profile.name,
        date: dateTitle,
        text: feedItem.text,
        likes: String(feedItem.likes?.count ?? 0),
        comments: String(feedItem.comments?.count ?? 0),
        shares: String(feedItem.reposts?.count ?? 0),
        views: String(feedItem.views?.count ?? 0)
    )
}

// MARK: - Seaching profils or groups with sourceID

private func searchProfile(for sourceId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresenatable {
    let profilesOrGroups: [ProfileRepresenatable] = sourceId >= 0 ? profiles : groups
    let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
    let profileRepresenatable = profilesOrGroups.first { (myProfileRepresenatable) -> Bool in
        myProfileRepresenatable.id == normalSourceId
    }
    return profileRepresenatable!
}

 // MARK: - Extension UITableViewDataSource, UITableViewDelegate

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCellId") else {
            fatalError("Unknowned cell id")
        }
        let cellViewModel = feedViewModel.cells[indexPath.row]
        if let cell = cell as? NewsfeedCell {
            cell.set(viewModel: cellViewModel)
        }
        return cell
    }
}
