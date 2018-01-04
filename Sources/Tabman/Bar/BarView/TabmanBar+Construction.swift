//
//  TabmanBar+Construction.swift
//  Tabman
//
//  Created by Merrick Sapsford on 15/03/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit
import PureLayout
import Pageboy

// MARK: - TabmanBar construction
extension TabmanBar {

    /// Reconstruct the bar for a new style or data set.
    internal func clearAndConstruct(then completion: () -> Void) {
        self.indicatorWidth?.isActive = false
        self.indicatorLeftMargin?.isActive = false
        self.clear()
        
        // no items yet
        guard let items = self.items else {
            return
        }
        
        construct(in: contentView, for: items)
        if let indicator = self.indicator {
            add(indicator: indicator, to: contentView)
        }
        
        completion()
    }
    
    /// Remove all components and subviews from the bar.
    private func clear() {
        self.contentView.removeAllSubviews()
    }
    
}
