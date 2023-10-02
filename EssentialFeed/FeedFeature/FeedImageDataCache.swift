//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 02/10/2023.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
