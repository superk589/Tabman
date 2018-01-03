//
//  BarPageIndicator.swift
//  Tabman
//
//  Created by Merrick Sapsford on 03/03/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

/// The lifecycle for an indicator.
public protocol BarPageIndicatorLifecycle {
    
    /// Construct the indicator
    func construct()
}

internal protocol TabmanIndicatorDelegate: class {
    
    func indicator(requiresLayoutInvalidation indicator: BarPageIndicator)
}

/// Indicator that highlights the currently visible page.
open class BarPageIndicator: UIView, BarPageIndicatorLifecycle {

    // MARK: Types

    /// The layer (Z) position of the indicator in relation to the bar contents.
    ///
    /// - background: Behind bar contents.
    /// - foreground: In front of bar contents.
    internal enum LayerPosition {
        case background
        case foreground
    }

    // MARK: Properties
    
    weak var delegate: TabmanIndicatorDelegate?
    
    /// Whether the indicator can support a progressive style.
    public private(set) var isProgressiveCapable: Bool = true
    
    //
    // MARK: Init
    //
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initIndicator()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initIndicator()
    }
    
    private func initIndicator() {
        construct()
    }
    
    //
    // MARK: Lifecycle
    //
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let layerPosition = self.preferredLayerPosition()
        switch layerPosition {
        case .background:
            self.superview?.sendSubview(toBack: self)
        default:
            self.superview?.bringSubview(toFront: self)
        }
    }
    
    open func construct() {
        fatalError("construct() should be implemented in TabmanBarIndicator subclasses.")
    }
    
    /// The preferred layer position for the indicator.
    ///
    /// - Returns: Preferred layer position.
    internal func preferredLayerPosition() -> LayerPosition {
        return .foreground
    }
    
    /// The type of item transition to use with this indicator. (Internal use only)
    ///
    /// - Returns: The item transition type.
    internal func itemTransitionType() -> TabmanItemTransition.Type? {
        return nil
    }
}

internal extension BarPageIndicator.Style {
    
    static func fromType(_ type: BarPageIndicator.Type?) -> BarPageIndicator.Style {
        guard let type = type else {
            return .clear
        }
        
        switch type {
        case is LinePageIndicator.Type:
            return .line
            
        case is DotPageIndicator.Type:
            return .dot
            
        default:
            return .custom(type: type)
        }
    }
}
