//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Tan Vinh Phan on 20/06/2023.
//

import UIKit
import EssentialFeed

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL)
}

final class FeedViewController: UITableViewController {
    private var feedLoader: FeedLoader?
    private var imageLoader: FeedImageDataLoader?
    private var tableModel = [FeedImage]()
    
    convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
        self.init()
        self.feedLoader = feedLoader
        self.imageLoader = imageLoader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        feedLoader?.load(completion: { [weak self] result in
            switch result {
            case let .success(feed):
                self?.tableModel = feed
                self?.tableView.reloadData()
            case .failure: break
            }
            self?.refreshControl?.endRefreshing()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = cellModel.location == nil
        cell.locationLabel.text = cellModel.location
        cell.descriptionLabel.text = cellModel.description
        imageLoader?.loadImageData(from: cellModel.url)
        return cell
    }
    
}
