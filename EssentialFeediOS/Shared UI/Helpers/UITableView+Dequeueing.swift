//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Tan Vinh Phan on 29/07/2023.
//

import UIKit

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
    
}
