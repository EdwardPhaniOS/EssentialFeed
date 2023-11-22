//
//  FeedViewControllerTest+Localizaton.swift
//  EssentialFeediOSTests
//
//  Created by Tan Vinh Phan on 05/08/2023.
//

import Foundation
import XCTest
import EssentialFeed

extension FeedUIIntegrationTests {
    
    var loadError: String {
        localized("GENERIC_CONNECTION_ERROR", table: "Shared")
    }
    
    func localized(_ key: String, table: String = "Feed", file: StaticString = #file, line: UInt = #line) -> String {
        let bundle = Bundle(for: FeedPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        
        if value == key {
            XCTFail("Missing localized string for key \(key) in table \(table)", file: file, line: line)
        }
        return value
    }
}
