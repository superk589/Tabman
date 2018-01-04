//
//  BarItemStackView.swift
//  Tabman
//
//  Created by Merrick Sapsford on 04/01/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

public class BarItemStackView: UIView {
    
    // MARK: Properties
    
    private let stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    // MARK: Init
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    private func setUp() {
        
        addSubview(stackView)
        stackView.pinToSuperviewEdges()
    }
}
