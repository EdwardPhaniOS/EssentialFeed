//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by Tan Vinh Phan on 25/06/2023.
//

import UIKit

public final class FeedImageCell: UITableViewCell {
    public let locationContainer = UIView()
    public let locationLabel = UILabel()
    public let descriptionLabel = UILabel()
    public let feedImageContainer = UIView()
    public let feedImageView = UIImageView()
    public let feedImageRetryButton = UIButton()
    
    public var imageData: Data?
    
    func setFeedImage(imageData: Data?) {
        self.imageData = imageData
        self.feedImageView.image = imageData.map(UIImage.init) ?? nil
    }
}
