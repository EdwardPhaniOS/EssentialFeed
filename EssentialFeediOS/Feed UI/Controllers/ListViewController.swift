//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Tan Vinh Phan on 20/06/2023.
//

import UIKit
import EssentialFeed

public protocol CellController {
    
    func view(in tableView: UITableView) -> UITableViewCell
    func preload()
    func cancelLoad()
    
}

public final class ListViewController: UITableViewController, UITableViewDataSourcePrefetching, ResourceLoadingView, ResourceErrorView {
    
    @IBOutlet weak var errorView: ErrorView!
    
    private var loadingController = [IndexPath: CellController]()
    
    public var onRefresh: (() -> Void)?
    
    private var tableModel = [CellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.sizeTableHeaderToFit()
    }
    
    @IBAction private func refresh() {
        onRefresh?()
    }
    
    public func display(_ cellControllers: [CellController]) {
        loadingController = [:]
        tableModel = cellControllers
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        if viewModel.isLoading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
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
    
    private func cellController(forRowAt indexPath: IndexPath) -> CellController {
        let controller = tableModel[indexPath.row]
        loadingController[indexPath] = controller
        return tableModel[indexPath.row]
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        loadingController[indexPath]?.cancelLoad()
        loadingController[indexPath] = nil
    }
    
}
