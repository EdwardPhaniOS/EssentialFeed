//
//  EssentialAppUIAcceptanceTests.swift
//  EssentialAppUIAcceptanceTests
//
//  Created by Tan Vinh Phan on 07/10/2023.
//

import XCTest

final class EssentialAppUIAcceptanceTests: XCTestCase {

    func test_onLauch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let app = XCUIApplication()
        
        app.launch()
        
        XCTAssertEqual(app.cells.count, 22)
        XCTAssertEqual(app.cells.firstMatch.images.count, 1)
    }
}
