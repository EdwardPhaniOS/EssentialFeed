//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Tan Vinh Phan on 11/07/2023.
//

import Foundation

public protocol FeedImageDataLoaderTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    @available(*, deprecated)
    @discardableResult
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
    
    func loadImageData(from url: URL) throws -> Data
}

extension FeedImageDataLoader {
    
    public func loadImageData(from url: URL) throws -> Data {
        return Data()
    }

    public func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask {
        return NullFeedImageDataLoaderTask()
    }
}

class NullFeedImageDataLoaderTask: FeedImageDataLoaderTask {
    func cancel() { }
}
