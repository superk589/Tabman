//
//  UIView+Utils.swift
//  Tabman
//
//  Created by Merrick Sapsford on 21/02/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

internal extension UIView {
    
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    @available (iOS 11, *)
    func pinToSafeArea(layoutGuide: UILayoutGuide) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            self.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            self.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
            ])
    }
}
