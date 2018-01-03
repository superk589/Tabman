//
//  TabmanBlockIndicator.swift
//  Tabman
//
//  Created by Merrick Sapsford on 09/03/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

internal class TabmanBlockIndicator: TabmanBarIndicator {
    
    //
    // MARK: Properties
    //
    
    override var intrinsicContentSize: CGSize {
        self.superview?.layoutIfNeeded()
        return self.superview?.bounds.size ?? .zero
    }
    
    /// The color of the indicator.
    override public var tintColor: UIColor! {
        didSet {
            self.backgroundColor = tintColor
        }
    }
    
    //
    // MARK: Lifecycle
    //
    
    override func preferredLayerPosition() -> TabmanBarIndicator.LayerPosition {
        return .background
    }
    
    public override func constructIndicator() {
        
        self.tintColor = TabmanBar.Appearance.defaultAppearance.indicator.color
    }
    
    override func itemTransitionType() -> TabmanItemTransition.Type? {
        return TabmanItemMaskTransition.self
    }
}
