//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Tan Vinh Phan on 30/09/2023.
//

import Foundation
import EssentialFeed

public class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    
    private let decoratee: FeedImageDataLoader
    
    public init(decoratee: FeedImageDataLoader) {
        self.decoratee = decoratee
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> EssentialFeed.FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url, completion: completion)
    }
    
}
