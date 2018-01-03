//
//  TabmanClearIndicator.swift
//  Tabman
//
//  Created by Merrick Sapsford on 17/03/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

internal class ClearPageIndicator: PageIndicator {

    //
    // MARK: Lifecycle
    //
    
    override func construct() {
        // do nothing
    }
    
    override func itemTransitionType() -> TabmanItemTransition.Type? {
        return TabmanItemColorCrossfadeTransition.self
    }
}
