//
//  TabmanViewController+Embedding.swift
//  Tabman
//
//  Created by Merrick Sapsford on 03/04/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

// MARK: - Internal TabmanBar embedding in external view.
public extension TabmanViewController {
    
    /// Embed the TabmanBar in an external view.
    /// This will add the bar to the specified view, and pin the bar edges to the view edges.
    ///
    /// - Parameter view: The view to embed the bar in.
    @available(*, deprecated: 1.0.4, message: "Use embedBar(in: )")
    public func embedBar(inView view: UIView) {
        embedBar(in: view)
    }
    
    /// Embed the TabmanBar in an external view.
    /// This will add the bar to the specified view, and pin the bar edges to the view edges.
    ///
    /// - Parameter view: The view to embed the bar in.
    public func embedBar(in view: UIView) {
        guard let bar = self.barView else {
            return
        }
        guard self.embeddingContainer == nil || view === self.embeddingContainer else {
            fatalError("Tabman - The bar must be disembedded from the view it is currently embedded in first. Use disembedBar().")
        }
        
        self.embeddingContainer = view
        
        bar.removeFromSuperview()
        view.addSubview(bar)
        bar.autoPinEdgesToSuperviewEdges()
        setNeedsChildAutoInsetUpdate()
        
        view.layoutIfNeeded()
    }
    
    /// Disembed the TabmanBar from an external view if it is currently embedded.
    public func disembedBar() {
        guard let bar = self.barView, self.embeddingContainer != nil else {
            return
        }
        
        bar.removeFromSuperview()
        self.embeddingContainer = nil
        
        self.updateBar(with: self.bar.location)
    }
}
