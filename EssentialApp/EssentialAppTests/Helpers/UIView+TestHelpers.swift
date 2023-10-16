//
//  UIView+TestHelpers.swift
//  EssentialFeediOS
//
//  Created by Tan Vinh Phan on 16/10/2023.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.main.run(until: Date())
    }
    
}
