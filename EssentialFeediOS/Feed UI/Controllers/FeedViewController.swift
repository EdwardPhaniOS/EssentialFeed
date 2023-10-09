//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Tan Vinh Phan on 20/06/2023.
//

import UIKit
import EssentialFeed

public protocol FeedViewControllerDelegate {
    func didRequestFeedRequest()
}

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching, FeedLoadingView, FeedErrorView {
    
    @IBOutlet weak var errorView: ErrorView!
    
    public var delegate: FeedViewControllerDelegate?
    
    private var tableModel = [FeedImageCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
   
    public override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    @IBAction private func refresh() {
        delegate?.didRequestFeedRequest()
    }
    
    public func display(_ cellControllers: [FeedImageCellController]) {
        tableModel = cellControllers
    }
    
    public func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }
    
    public func display(_ viewModel: FeedErrorViewModel) {
        guard let message = viewModel.message else {
            errorView.hideMessage()
            return
        }
        errorView.show(message: message)
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad(forRowAt:))
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        return tableModel[indexPath.row]
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
    
}
