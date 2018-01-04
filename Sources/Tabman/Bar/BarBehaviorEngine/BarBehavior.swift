//
//  TabmanBar+Behaviors.swift
//  Tabman
//
//  Created by Merrick Sapsford on 21/11/2017.
//  Copyright © 2017 UI At Six. All rights reserved.
//

import Foundation

public enum BarBehavior {
    
    /// Autohiding the bar
    ///
    /// - never: always visible
    /// - withOneItem: hidden when only a single item is in the bar
    /// - always: always hidden
    public enum AutoHiding {
        case never
        case withOneItem
        case always
    }
    
    case autoHide(AutoHiding)
}

internal extension BarBehavior {
    
    var activistType: BarBehaviorActivist.Type? {
        switch self {
            
        case .autoHide:
            return AutoHideBarBehaviorActivist.self
        }
    }
    
    var activator: BarBehaviorActivist.Activator {
        switch self {
            
        default:
            return .onBarChange
        }
    }
}
