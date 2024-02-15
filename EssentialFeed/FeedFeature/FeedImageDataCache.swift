//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 02/10/2023.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Error>
    
    @available(*, deprecated)
    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
    
    func save(_ data: Data, for url: URL) throws
}

public extension FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws {}
    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void) {}
}
