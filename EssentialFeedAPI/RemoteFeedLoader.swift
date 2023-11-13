//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 25/12/2022.
//

import Foundation
import EssentialFeed

public final class RemoteFeedLoader: FeedLoader {
    
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = FeedLoader.Result
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(((data, response))):
                completion(RemoteFeedLoader.map(data, from: response))
            case .failure:
                completion(Result.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemsMapper.map(data, response)
            return Result.success(items)
        } catch {
            return Result.failure(error)
        }
    }
}


