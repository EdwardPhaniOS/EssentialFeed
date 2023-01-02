//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 25/12/2022.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
   
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult<Error>
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(FeedItemsMapper.map(data, response))
            case .failure:
                completion(Result.failure(.connectivity))
            }
        }
    }
    
    
}


