//
//  UIView+Utils.swift
//  Tabman
//
//  Created by Merrick Sapsford on 21/02/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

// MARK: - Utilities
internal extension UIView {
    
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
}
