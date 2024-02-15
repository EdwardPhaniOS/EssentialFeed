//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Tan Vinh Phan on 23/11/2023.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
