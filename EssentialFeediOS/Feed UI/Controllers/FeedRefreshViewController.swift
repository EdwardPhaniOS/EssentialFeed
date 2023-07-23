//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Tan Vinh Phan on 11/07/2023.
//

import UIKit
import EssentialFeed

protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRequest()
}

class FeedRefreshViewController: NSObject, FeedLoadingView {
    
    private(set) lazy var view = loadView()
    
    private let delegate: FeedRefreshViewControllerDelegate
    
    init(delegate: FeedRefreshViewControllerDelegate) {
        self.delegate = delegate
    }
    
    var onRefresh: (([FeedImage]) -> Void)?
    
    @objc func refresh() {
        delegate.didRequestFeedRequest()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}

