//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 19/12/2022.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)
}

extension LoadFeedResult: Equatable where Error: Equatable { }

protocol FeedLoader {
    associatedtype Error: Swift.Error
    
    func load(completio: (LoadFeedResult<Error>) -> Void)
}


