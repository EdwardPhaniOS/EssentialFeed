//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 03/09/2023.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
    
}
