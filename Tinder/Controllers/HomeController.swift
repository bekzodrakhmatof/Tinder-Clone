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
        bottomControls.likeButton.addTarget(self, action: #selector(handleLikeButton), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislikeButton), for: .touchUpInside)
        setupLayout()
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            
            let registrationController = RegistrationController()
            registrationController.loginControllerDelegate = self
            let navigationController = UINavigationController(rootViewController: registrationController)
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
        
        let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThan: minAge).whereField("age", isLessThan: maxAge)
        
        topCardView = nil
        
        query.getDocuments { (snapshot, error) in
            
            hud.dismiss()
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            var prevoiusCardView: CardView?
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                    
                    let cardView = self.setupCardFromUser(user: user)
                    
                    prevoiusCardView?.nextCardView = cardView
                    prevoiusCardView = cardView
                    
                    if self.topCardView == nil {
                        
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    var topCardView: CardView?
    
    @objc func handleLikeButton() {
        
        saveSwipeInformationToFirestore(didLike: 1)
        performSwipeAnimation(translation: 700, angle: 15)

    }
    
    @objc func handleDislikeButton() {
        
        saveSwipeInformationToFirestore(didLike: 0)
        performSwipeAnimation(translation: -700, angle: -10)
        
    }
    
    fileprivate func saveSwipeInformationToFirestore(didLike: Int) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let cardUID = topCardView?.cardViewModel.uid else { return }
        
        let documentData = [cardUID: didLike]
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshotData, error) in
            if let error = error {
                print("Failed to fetch swipe document: ",error)
                return
            }
            
            if snapshotData?.exists == true {
                
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { (error) in
                    if let error = error {
                        print("Failed to update swipe data: ",error)
                        return
                    }
                    
                    print("Successfully updated swiped...")
                }
            } else {
                
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (error) in
                    if let error = error {
                        print("Failed to save swipe data: ",error)
                        return
                    }
                    
                    print("Successfully saved swiped...")
                }
            }
        }
    }
    
    func didRemoveCard(cardView: CardView) {
        
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        
        let duration = 0.7
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let coardView = topCardView
        topCardView = coardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            coardView?.removeFromSuperview()
        }
        
        coardView?.layer.add(translationAnimation, forKey: "translation")
        coardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView {
        
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardView.cardViewDelegate = self
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        
        return cardView
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        
        let userDetailsController = UserDetailsController()
        userDetailsController.cardViewModel = cardViewModel
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
