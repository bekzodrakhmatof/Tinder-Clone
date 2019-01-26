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
    let cardsDeckView   = UIView()
    let bottomStackView = HomeBottomControlsStackView()
    
    let cardViewModels = [
        
        User(name: "Kelly", age: 23, profession: "Music DJ", imageName: "lady5c").toCardViewModel(),
        User(name: "Jane", age: 18, profession: "Teacher", imageName: "lady4c").toCardViewModel()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
    }
    
    //MARK: - Setup File Private Methods
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
    fileprivate func setupDummyCards() {
    
        cardViewModels.forEach { (cardViewModel) in
            
            let cardView = CardView(frame: .zero)
            cardView.imageView.image = UIImage(named: cardViewModel.imageName)
            cardView.informationLabel.attributedText = cardViewModel.attributedString
            cardView.informationLabel.textAlignment = cardViewModel.textAlignment
            
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
}

