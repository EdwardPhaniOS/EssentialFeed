//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 25/12/2022.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

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
        client.get(from: url) { result in
            
            switch result {
            case let .success(data, response):
                if response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) {
                    completion(Result.success(root.items))
                } else {
                    completion(Result.failure(.invalidData))
                }
            case .failure:
                completion(Result.failure(.connectivity))
            }
        }
    }
}

private struct Root: Decodable {
    let items: [FeedItem]
}
