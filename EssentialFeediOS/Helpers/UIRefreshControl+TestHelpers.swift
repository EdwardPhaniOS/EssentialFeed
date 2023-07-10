//
//  UIRefreshControl+TestHelpers.swift
//  EssentialFeediOS
//
//  Created by Tan Vinh Phan on 10/07/2023.
//

import UIKit

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
    
}

