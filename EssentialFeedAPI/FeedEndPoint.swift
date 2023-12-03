//
//  FeedEndPoint.swift
//  EssentialFeedAPI
//
//  Created by Tan Vinh Phan on 03/12/2023.
//

import Foundation

public enum FeedEndPoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}
