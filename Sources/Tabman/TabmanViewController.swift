//
//  TabmanViewController.swift
//  Tabman
//
//  Created by Merrick Sapsford on 17/02/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit
import Pageboy

/// Page view controller with a bar indicator component.
open class TabmanViewController: PageboyViewController, PageboyViewControllerDelegate {
    
    // MARK: Properties
    
    /// The internally managed Tabman bar.
    internal fileprivate(set) var barView: TabmanBar?
    /// The currently attached TabmanBar (if it exists).
    internal var attachedBarView: TabmanBar?
    /// Returns the active bar, prefers attachedTabmanBar if available.
    internal var activeBarView: TabmanBar? {
        if let attachedBarView = self.attachedBarView {
            return attachedBarView
        }
        return barView
    }
    
    /// The view that is currently being used to embed the instance managed TabmanBar.
    internal var embeddingContainer: UIView?
    
    /// Configuration for the bar.
    /// Able to set items, appearance, location and style through this object.
    public var bar = TabmanBar.Config()
    
    /// Internal store for bar component transitions.
    internal var barTransitionStore = TabmanBarTransitionStore()
    
    /// Whether to automatically inset the contents of any child view controller.
    /// Defaults to true.
    public var automaticallyAdjustsChildViewInsets: Bool = true {
        didSet {
            self.automaticallyAdjustsScrollViewInsets = !automaticallyAdjustsChildViewInsets
            autoInsetEngine.isEnabled = automaticallyAdjustsChildViewInsets
            setNeedsChildAutoInsetUpdate()
        }
    }
    internal let autoInsetEngine = AutoInsetEngine()
    
    // MARK: Lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.delegate = self
        self.bar.handler = self
        
        // add bar to view
        self.createBar(with: self.bar.style)
        self.moveBar(to: self.bar.location)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setNeedsChildAutoInsetUpdate()
        updateBarWithCurrentPosition()
        
        let appearance = bar.appearance ?? .defaultAppearance
        let isBarExternal = embeddingContainer != nil || attachedBarView != nil
        activeBarView?.updateBackgroundEdgesForSystemAreasIfNeeded(for: bar.actualLocation,
                                                                     in: self,
                                                                     appearance: appearance,
                                                                     canExtend: !isBarExternal)
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let bounds = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)

        coordinator.animate(alongsideTransition: { (_) in
            self.activeBarView?.updateForCurrentPosition(bounds: bounds)
        }, completion: nil)
    }
    
    // MARK: PageboyViewControllerDelegate
    
    private var isScrollingAnimated: Bool = false
    
    open func pageboyViewController(_ pageboyViewController: PageboyViewController,
                                    willScrollToPageAt index: Int,
                                    direction: PageboyViewController.NavigationDirection,
                                    animated: Bool) {
        let viewController = dataSource?.viewController(for: self, at: index)
        setNeedsChildAutoInsetUpdate(for: viewController)
        
        if animated {
            isScrollingAnimated = true
            UIView.animate(withDuration: 0.3, animations: {
                self.activeBarView?.updatePosition(CGFloat(index), direction: direction)
                self.activeBarView?.layoutIfNeeded()
            })
        }
    }
    
    open func pageboyViewController(_ pageboyViewController: PageboyViewController,
                                    didScrollToPageAt index: Int,
                                    direction: PageboyViewController.NavigationDirection,
                                    animated: Bool) {
        isScrollingAnimated = false
        self.updateBar(with: CGFloat(index),
                       direction: direction)
    }
    
    open func pageboyViewController(_ pageboyViewController: PageboyViewController,
                                    didScrollTo position: CGPoint,
                                    direction: PageboyViewController.NavigationDirection,
                                    animated: Bool) {
        if !animated {
            self.updateBar(with: pageboyViewController.navigationOrientation == .horizontal ? position.x : position.y,
                           direction: direction)
        }
    }
    
    open func pageboyViewController(_ pageboyViewController: PageboyViewController,
                                    didReloadWith currentViewController: UIViewController,
                                    currentPageIndex: PageboyViewController.PageIndex) {
        setNeedsChildAutoInsetUpdate(for: currentViewController)
    }
}

// MARK: - Bar positional updates
private extension TabmanViewController {
    
    /// Update the bar with a new position.
    ///
    /// - Parameters:
    ///   - position: The new position.
    ///   - direction: The direction of travel.
    private final func updateBar(with position: CGFloat,
                                 direction: PageboyViewController.NavigationDirection) {
        
        let viewControllersCount = self.pageCount ?? 0
        let barItemsCount = self.activeBarView?.items?.count ?? 0
        let itemCountsAreEqual = viewControllersCount == barItemsCount
        
        if position >= CGFloat(barItemsCount - 1) && !itemCountsAreEqual {
            return
        }
        
        self.activeBarView?.updatePosition(position, direction: direction)
    }
    
    /// Update the bar with the currently active position.
    /// Called after any layout changes.
    private final func updateBarWithCurrentPosition() {
        guard let currentPosition = self.currentPosition, !isScrollingAnimated else {
            return
        }
        
        let position = self.navigationOrientation == .horizontal ? currentPosition.x : currentPosition.y
        updateBar(with: position, direction: .neutral)
    }
}

// MARK: - Bar Reloading / Layout
internal extension TabmanViewController {
    
    /// Remove a bar from it's superview and clear up.
    ///
    /// - Parameter bar: The bar to destroy.
    final func destroyBar(_ bar: inout TabmanBar?) {
        bar?.removeFromSuperview()
        bar = nil
    }
    
    /// Initialize a new bar with a style.
    ///
    /// - Parameter style: The style.
    final func createBar(with style: TabmanBar.Style) {
        guard let barType = style.rawType else {
            return
        }
        
        // create the bar with a new style
        let bar = barType.init()
        bar.transitionStore = self.barTransitionStore
        bar.dataSource = self
        bar.responder = self
        bar.behaviorEngine.activeBehaviors = self.bar.behaviors
        bar.isHidden = (bar.items?.count ?? 0) == 0 // hidden if no items
        if let appearance = self.bar.appearance {
            bar.appearance = appearance
        }

        self.barView = bar
    }
    
    /// Update the bar with a new screen location.
    ///
    /// - Parameter location: The new location.
    final func moveBar(to location: BarLocation) {
        guard self.embeddingContainer == nil else {
            self.embedBar(in: self.embeddingContainer!)
            return
        }
        
        guard let bar = self.barView else {
            return
        }
        guard bar.superview == nil || bar.superview === self.view else {
            return
        }
        
        // use style preferred location if no exact location specified.
        var location = location
        if location == .preferred {
            location = self.bar.style.preferredLocation
        }
        
        // ensure bar is always on top
        // Having to use CGFloat cast due to CGFloat.greatestFiniteMagnitude causing 
        // "zPosition should be within (-FLT_MAX, FLT_MAX) range" error.
        bar.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        
        bar.removeFromSuperview()
        self.view.addSubview(bar)
        
        // move tab bar to location
        switch location {
            
        case .top:
            bar.barAutoPinToTop(topLayoutGuide: self.topLayoutGuide)
        case .bottom:
            bar.barAutoPinToBotton(bottomLayoutGuide: self.bottomLayoutGuide)
            
        default:()
        }
        self.view.layoutIfNeeded()
        
        let position = self.navigationOrientation == .horizontal ? self.currentPosition?.x : self.currentPosition?.y
        bar.updatePosition(position ?? 0.0, direction: .neutral)
        
        setNeedsChildAutoInsetUpdate()
    }
}

// MARK: - TabmanBarDataSource, TabmanBarResponder
extension TabmanViewController: TabmanBarDataSource, TabmanBarResponder {
    
    public func items(for bar: TabmanBar) -> [BarItem]? {
        if let itemCountLimit = bar.itemCountLimit {
            guard self.bar.items?.count ?? 0 <= itemCountLimit else {
                print("TabmanBar Error:\nItems in bar.items exceed the available count for the current bar style: (\(itemCountLimit)).")
                print("Either reduce the number of items or use a different style. Escaping now.")
                return nil
            }
        }
        
        return self.bar.items
    }
    
    public func bar(_ bar: TabmanBar, shouldSelectItemAt index: Int) -> Bool {
        return self.bar.delegate?.bar(shouldSelectItemAt: index) ?? true
    }
    
    public func bar(_ bar: TabmanBar, didSelectItemAt index: Int) {
        self.scrollToPage(.at(index: index), animated: true)
    }
}

// MARK: - TabmanBarConfigHandler
extension TabmanViewController: TabmanBarConfigHandler {
    
    func config(_ config: TabmanBar.Config, didUpdate style: TabmanBar.Style) {
        guard self.attachedBarView == nil else {
            return
        }
        
        self.destroyBar(&self.barView)
        self.createBar(with: style)
        self.moveBar(to: config.location)
    }
    
    func config(_ config: TabmanBar.Config, didUpdate location: BarLocation) {
        guard self.attachedBarView == nil else {
            return
        }

        self.moveBar(to: location)
    }
    
    func config(_ config: TabmanBar.Config, didUpdate appearance: TabmanBar.Appearance) {
        self.activeBarView?.appearance = appearance
    }
    
    func config(_ config: TabmanBar.Config, didUpdate items: [BarItem]?) {
        activeBarView?.reloadData()
        setNeedsChildAutoInsetUpdate()
    }
    
    func config(_ config: TabmanBar.Config, didUpdate behaviors: [BarBehavior]?) {
        activeBarView?.behaviorEngine.activeBehaviors = behaviors
        setNeedsChildAutoInsetUpdate()
    }
}
