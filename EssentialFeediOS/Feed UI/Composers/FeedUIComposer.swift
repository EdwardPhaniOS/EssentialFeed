//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Tan Vinh Phan on 13/07/2023.
//

import UIKit
import EssentialFeed

public final class FeedUIComposer {
    
    private init() {}
    
    public static func feedComposeWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let refreshController = FeedRefreshViewController(viewModel: FeedViewModel(feedLoader: feedLoader))
        let feedController = FeedViewController(refreshController: refreshController)
        refreshController.onRefresh = adaptFeedToCellControllers(forwardingTo: feedController, loader: imageLoader)
        
        return feedController
    }
    
        private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
            return { [weak controller] feed in
                controller?.tableModel = feed.map({ model in
                    FeedImageCellController(viewModel: FeedImageViewModel(model: model, imageLoader: loader, imageTransformer: { UIImage(data: $0) }))
                })
            }
        }
}
