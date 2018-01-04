//
//  TabmanViewController+Attachment.swift
//  Tabman
//
//  Created by Merrick Sapsford on 03/01/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

// MARK: - External TabmanBar attach/detachment.
public extension TabmanViewController {
    
    /// Attach a TabmanBar that is somewhere in the view hierarchy.
    /// This will replace the TabmanViewController managed instance.
    ///
    /// - Parameter bar: The bar to attach.
    public func attach(bar: TabmanBar) {
        guard self.attachedBarView == nil else {
            fatalError("Tabman - You must detach the currently attached bar before attempting to attach a new bar.")
        }
        
        self.barView?.isHidden = true
        setNeedsChildAutoInsetUpdate()
        
        // hook up new bar
        bar.dataSource = self
        bar.responder = self
        bar.transitionStore = self.barTransitionStore
        if let appearance = self.bar.appearance {
            bar.appearance = appearance
        }
        bar.isHidden = true
        self.attachedBarView = bar
        
        bar.reloadData()
    }
    
    /// Detach a currently attached external TabmanBar.
    /// This will reinstate the TabmanViewController managed instance.
    ///
    /// - Returns: The detached bar.
    @discardableResult public func detachAttachedBar() -> TabmanBar? {
        guard let bar = self.attachedBarView, self.attachedBarView === bar else {
            return nil
        }
        
        bar.dataSource = nil
        bar.responder = nil
        bar.transitionStore = nil
        bar.isHidden = false
        self.attachedBarView = nil
        
        self.barView?.reloadData()
        self.view.layoutIfNeeded()
        
        setNeedsChildAutoInsetUpdate()
        
        return bar
    }
}
