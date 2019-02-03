//
//  HomeController.swift
//  Tinder
//
//  Created by Bekzod Rakhmatov on 23/01/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {

    let topStackView    = TopNavigationStackView()
    let cardsDeckView   = UIView()
    let bottomStackView = HomeBottomControlsStackView()
    
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettingsButton), for: .touchUpInside)
        
        setupLayout()
        fetchUsersFromFirebase()
    }
    
    fileprivate func fetchUsersFromFirebase() {
        
        let query = Firestore.firestore().collection("users")
        
        query.getDocuments { (snapshot, error) in
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                
                let userDictionary = documentSnapshot.data()
                
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                print(userDictionary)
                self.setupFirestoreUserCards()
            })
        }
    }
    
    @objc fileprivate func handleSettingsButton() {
        
        let registrationController = RegistrationController()
        present(registrationController, animated: true, completion: nil)
        
    }
    
    //MARK: - Setup File Private Methods
    fileprivate func setupLayout() {
        
        view.backgroundColor = .white
        
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
    fileprivate func setupFirestoreUserCards() {
    
        cardViewModels.forEach { (cardViewModel) in
            
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardViewModel
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
}

