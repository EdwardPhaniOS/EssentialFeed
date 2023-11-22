//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 17/08/2023.
//

import Foundation

public class FeedPresenter {
    public static var title: String {
        NSLocalizedString("FEED_VIEW_TITLE",
                          tableName: "Feed",
                          bundle: Bundle(for: FeedPresenter.self),
                          comment: "Title for the feed view")
    }
    
    public static func map(_ feed: [FeedImage]) -> FeedViewModel {
        FeedViewModel(feed: feed)
    }
}
