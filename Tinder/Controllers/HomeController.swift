//
//  HomeController.swift
//  Tinder
//
//  Created by Bekzod Rakhmatov on 23/01/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import JGProgressHUD

class HomeController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
    
    let topStackView    = TopNavigationStackView()
    let cardsDeckView   = UIView()
    let bottomControls = HomeBottomControlsStackView()
    
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettingsButton), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefreshButton), for: .touchUpInside)
        setupLayout()
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            
            let loginController = LoginController()
            loginController.loginDelegate = self
            let navigationController = UINavigationController(rootViewController: loginController)
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    func didFinishLoggingIn() {
        
        fetchCurrentUser()
    }
    
    fileprivate var user: User?
    
    fileprivate func fetchCurrentUser() {
        
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        Firestore.firestore().fetchCurrentUser { (user, error) in
            
            if let error = error {
                print("Error, \(error)")
                return
            }
            
            self.user = user
            self.fetchUsersFromFirebase()
        }
    }
    
    @objc fileprivate func handleRefreshButton() {
        
        fetchUsersFromFirebase()
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirebase() {
        
        guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else { return }
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThan: minAge).whereField("age", isLessThan: maxAge)
        
        query.getDocuments { (snapshot, error) in
            
            hud.dismiss()
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                    self.setupCardFromUser(user: user)
                }
//                self.cardViewModels.append(user.toCardViewModel())
//                self.lastFetchedUser = user
                
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardView.cardViewDelegate = self
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    func didTapMoreInfo() {
        
        let userDetailsController = UserDetailsController()
        present(userDetailsController, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleSettingsButton() {
        
        let settingsController = SettingsController()
        settingsController.settingDelegate = self
        let navigationController = UINavigationController(rootViewController: settingsController)
        present(navigationController, animated: true, completion: nil)
        
    }
    
    func didSaveSettings() {
        
        fetchCurrentUser()
    }
    
    //MARK: - Setup File Private Methods
    fileprivate func setupLayout() {
        
        view.backgroundColor = .white
        
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
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

