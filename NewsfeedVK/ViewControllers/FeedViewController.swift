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

    var cellLayoutCallculator: NewsfeedCellLayoutCalculator = NewsfeedCellLayoutCalculator()

    private var feedResponse: FeedResponse?
    private var nextFrom: String?

    var refreshControll: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControll
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavBar()
        tableView.addSubview(refreshControll)

        tableView.delegate = self
        tableView.dataSource = self

        getNewsfeed()
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

        let photoAttachments = self.photoAttachments(feedItem: feedItem)

        let sizes = cellLayoutCallculator.sizes(postText: feedItem.text, photoAttachments: photoAttachments)

        return FeedViewModel.Cell.init(
            iconGroupImage: profile.photo,
            groupName: profile.name,
            date: dateTitle,
            text: feedItem.text,
            likes: formattedCounter(feedItem.likes?.count),
            comments: formattedCounter(feedItem.comments?.count),
            shares: formattedCounter(feedItem.shares?.count),
            views: formattedCounter(feedItem.views?.count),
            photoAttachments: photoAttachments,
            sizes: sizes
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

    // MARK: - Set First Image from Attachment

    private func photoAttachment(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttachment? {
        guard let photos = feedItem.attachments?.compactMap({ (attachment) in
            attachment.photo
        }), let firstPhoto = photos.first else {
            return nil
        }
        return FeedViewModel.FeedCellPhotoAttachment.init(
            photoUrl: firstPhoto.url,
            width: firstPhoto.width,
            height: firstPhoto.height
        )
    }

    // MARK: - Set array of photos

    private func photoAttachments(feedItem: FeedItem) -> [FeedViewModel.FeedCellPhotoAttachment] {
        guard let attachments = feedItem.attachments else {
            return []
        }
        return attachments.compactMap({ (attachment) -> FeedViewModel.FeedCellPhotoAttachment? in
            guard let photo = attachment.photo else {
                return nil
            }
            return FeedViewModel.FeedCellPhotoAttachment.init(photoUrl: photo.url,
                                                              width: photo.width,
                                                              height: photo.height
            )
        })
    }

    // MARK: - Refreshing Data

    @objc private func refresh() {
        getNewsfeed()
    }

    // MARK: - Getting Newsfeed

    private func getNewsfeed() {
        fetcher.getFeed(nextBatchFrom: nil) { (feedResponse) in
            guard let feedResponse = feedResponse else {
                return
            }

            self.feedResponse = feedResponse
            self.nextFrom = feedResponse.nextFrom
            self.feedViewModel = self.creatingFeedViewModel(feedResponse: feedResponse)
            self.tableView.reloadData()
            self.refreshControll.endRefreshing()
        }
    }

    private func getNextBatch(nextBatchFrom: String?) {
        fetcher.getFeed(nextBatchFrom: self.nextFrom ) { (feedResponse) in
            guard let feed = feedResponse else {
                return
            }
            guard nextBatchFrom != feed.nextFrom else {
                return
            }

            if self.feedResponse == nil {
                self.feedResponse = feed
            } else {
                self.feedResponse?.items.append(contentsOf: feed.items)
                self.feedResponse?.nextFrom = feed.nextFrom

                var profiles = feed.profiles
                if let oldProfiles = self.feedResponse?.profiles {
                    let oldProfilesFiltered = oldProfiles.filter({ (oldProfile) -> Bool in
                        !feed.profiles.contains(where: {$0.id == oldProfile.id})
                    })
                    profiles.append(contentsOf: oldProfilesFiltered)
                }
                self.feedResponse?.profiles = profiles

                var groups = feed.groups
                if let oldGroups = self.feedResponse?.groups {
                    let oldGroupsFiltered = oldGroups.filter({ (oldGroup) -> Bool in
                        !feed.groups.contains(where: {$0.id == oldGroup.id})
                    })
                    groups.append(contentsOf: oldGroupsFiltered)
                }
                self.feedResponse?.groups = groups
            }

            guard let feedResponse = self.feedResponse else {
                return
            }
            self.feedViewModel = self.creatingFeedViewModel(feedResponse: feedResponse)
            self.tableView.reloadData()
//            self.refreshControll.endRefreshing()
        }
    }

    // MARK: - Formatting Counter

    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else {
            return nil
        }
        var counterString = String(counter)
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
        }
        return counterString
    }

    // MARK: - ScrollViewDidEndDragging

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.05 {
            print("nextFrom: \(nextFrom)")
            getNextBatch(nextBatchFrom: nextFrom)
        }
    }
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeigth
    }
}
