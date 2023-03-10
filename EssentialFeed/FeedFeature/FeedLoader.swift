//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 19/12/2022.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}


