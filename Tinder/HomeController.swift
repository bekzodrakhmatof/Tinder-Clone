//
//  HomeController.swift
//  Tinder
//
//  Created by Bekzod Rakhmatov on 23/01/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    let topStackView    = TopNavigationStackView()
    let blueView        = UIView()
    let bottomStackView = HomeBottomControlsStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blueView.backgroundColor = .blue
        
        setupLayout()
    }
    
    //MARK: - FILEPRIVATE
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, blueView, bottomStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}

