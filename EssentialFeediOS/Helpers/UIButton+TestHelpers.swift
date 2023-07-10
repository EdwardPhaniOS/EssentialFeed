//
//  UIButton+TestHelpers.swift
//  EssentialFeediOS
//
//  Created by Tan Vinh Phan on 10/07/2023.
//

import UIKit

extension UIButton {
    public func simulateTap() {
        simulate(event: .touchUpInside)
    }
    
}

