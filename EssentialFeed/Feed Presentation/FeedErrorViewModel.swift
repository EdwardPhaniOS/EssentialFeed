//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 17/08/2023.
//

import Foundation

struct FeedErrorViewModel {
    let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: .none)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
