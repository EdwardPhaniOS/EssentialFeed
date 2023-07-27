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
    
    @IBOutlet private var view: UIRefreshControl?
    
    var delegate: FeedRefreshViewControllerDelegate?
    
    var onRefresh: (([FeedImage]) -> Void)?
    
    @IBAction func refresh() {
        delegate?.didRequestFeedRequest()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view?.beginRefreshing()
        } else {
            view?.endRefreshing()
        }
    }
    
}

