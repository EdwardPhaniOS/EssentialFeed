//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Tan Vinh Phan on 11/07/2023.
//

import UIKit
import EssentialFeed

final class FeedImageCellController {
    
    private(set) var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func view() -> UITableViewCell {
        let cell = FeedImageCell()
        
        cell.locationContainer.isHidden = model.location == nil
        cell.locationLabel.text = model.location
        cell.descriptionLabel.text = model.description
        cell.feedImageView.image = nil
        cell.feedImageRetryButton.isHidden = true
        
        loadImage(forCell: cell)
        
        return cell
    }
    
    func preload() {
        task = imageLoader.loadImageData(from: model.url, completion: { _ in })
    }
    
    func loadImage(forCell cell: UITableViewCell) {
        guard let cell = cell as? FeedImageCell else { return }
        
        cell.feedImageContainer.startShimmering()
        let loadImage = { [weak self, weak cell] in
            guard let self = self else { return }
            
            self.task = self.imageLoader.loadImageData(from: self.model.url, completion: { [weak cell] result in
                let data = try? result.get()
                let image = data.map(UIImage.init) ?? nil
                cell?.feedImageView.image = image
                cell?.feedImageRetryButton.isHidden = image != nil
                cell?.feedImageContainer.stopShimmering()
            })
        }
        
        cell.onRetry = loadImage
        loadImage()
    }
    
    func cancelLoad() {
        task?.cancel()
    }
    
}
