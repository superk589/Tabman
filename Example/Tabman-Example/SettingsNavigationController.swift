//
//  SettingsNavigationController.swift
//  Tabman-Example
//
//  Created by Merrick Sapsford on 27/02/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

class SettingsNavigationController: UINavigationController {
    
    // MARK: Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        self.modalPresentationCapturesStatusBarAppearance = false
        self.modalPresentationStyle = .overFullScreen
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        self.view.addSubview(blurView)
        self.view.sendSubviewToBack(blurView)
        blurView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // On iOS 11 add rounded corners
        if #available(iOS 11, *) {
            view.clipsToBounds = true
            view.layer.cornerRadius = 16.0
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            view.layer.shadowOffset = .zero
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowRadius = 16.0
            view.layer.shadowOpacity = 0.5
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var titleTextAttributes: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.black]
        if #available(iOS 8.2, *) {
            titleTextAttributes[.font] = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.regular)
        }
        self.navigationBar.titleTextAttributes = titleTextAttributes
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
}
