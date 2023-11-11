//
//  ImageCommentMapper.swift
//  EssentialFeedAPI
//
//  Created by Tan Vinh Phan on 11/11/2023.
//

import Foundation

final class ImageCommentMapper {
    
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedImageCommentsLoader.Error.invalidData
        }
        
        return root.items
    }
    
}
