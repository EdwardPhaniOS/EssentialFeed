//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 25/12/2022.
//

import Foundation

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(data, response):
                completion(self.map(data, response))
            case .failure:
                completion(Result.failure(.connectivity))
            }
        }
    }
    
    private func map(_ data: Data, _ response: HTTPURLResponse) -> Result {
        if let items = try? FeedItemsMapper.map(data, response) {
            return .success(items)
        } else {
            return .failure(.invalidData)
        }
    }
}


