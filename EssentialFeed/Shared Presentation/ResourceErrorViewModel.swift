//
//  ResourceErrorViewModel.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 17/08/2023.
//

import Foundation

public struct ResourceErrorViewModel {
    public let message: String?
    
    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: .none)
    }
    
    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
