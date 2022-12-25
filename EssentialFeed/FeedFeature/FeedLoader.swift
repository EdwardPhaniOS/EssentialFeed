//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 19/12/2022.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completio: (LoadFeedResult) -> Void)
}


