//
//  BarPageIndicator+Styles.swift
//  Tabman
//
//  Created by Merrick Sapsford on 03/01/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import Foundation

public extension BarPageIndicator {
    
    /// The style of indicator to display.
    ///
    /// - clear: No visible indicator.
    /// - line: Horizontal line pinned to bottom of bar.
    /// - dot: Circular centered dot pinned to the bottom of the bar.
    /// - chevron: Centered chevron pinned to the bottom of the bar.
    /// - custom: A custom defined indicator.
    public enum Style {
        case clear
        case line
        case dot
        case chevron
        case custom(type: BarPageIndicator.Type)
    }
}

internal extension BarPageIndicator.Style {
    
    var rawType: BarPageIndicator.Type? {
        switch self {
        case .line:
            return LinePageIndicator.self
        case .dot:
            return DotPageIndicator.self
        case .chevron:
            return ChevronPageIndicator.self
        case .custom(let type):
            return type
        case .clear:
            return ClearPageIndicator.self
        }
    }
}
