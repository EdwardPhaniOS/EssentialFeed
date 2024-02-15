//
//  ImageCommentsEndPoint.swift
//  EssentialFeedAPI
//
//  Created by Tan Vinh Phan on 03/12/2023.
//

import Foundation

public enum ImageCommentsEndPoint {
    case get(UUID)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("/v1/image/\(id)/comments")
        }
    }
    
}
