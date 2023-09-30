//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 30/09/2023.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
