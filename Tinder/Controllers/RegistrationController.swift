//
//  RegistrationController.swift
//  Tinder
//
//  Created by Bekzod Rakhmatov on 27/01/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {
    
    // UI Components

    let selectPhotoButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        
        let textField = CustomTextField(padding: 16, height: 44)
        textField.placeholder = "Enter full name"
        
        return textField
    }()
    
    let emailTextField: CustomTextField = {
        
        let textField = CustomTextField(padding: 16, height: 44)
        textField.placeholder = "Enter email"
        textField.keyboardType = .emailAddress
    
        return textField
    }()
    
    let passwordTextField: CustomTextField = {
        
        let textField = CustomTextField(padding: 16, height: 44)
        textField.placeholder = "Enter password"
        textField.backgroundColor = .white
        
        return textField
    }()
    
    let registerButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8111879826, green: 0.1042452082, blue: 0.3321437836, alpha: 1)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.clipsToBounds = true
        button.layer.cornerRadius = 22
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationObservers()
        setupGradientLayer()
        setupLayout()
        
        setupTapGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func setupTapGesture() {
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }
    
    @objc fileprivate func handleTap(_ gesture: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
    
    fileprivate func setupNotificationObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardHide(_ notification: Notification) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.transform = .identity
            
        }, completion: nil)
    }
    
    @objc fileprivate func handleKeyboardShow(_ notification: Notification) {

        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keybaordFrame = value.cgRectValue
        print(keybaordFrame)
        
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        print(bottomSpace)
        
        let differnce = keybaordFrame.height - bottomSpace
        
        self.view.transform = CGAffineTransform(translationX: 0, y: -differnce - 8)
    }
    
    fileprivate func setupGradientLayer() {
        
        let gradientLayer = CAGradientLayer()
        
        let topColor = #colorLiteral(red: 0.9880711436, green: 0.3838337064, blue: 0.3728808165, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8920591474, green: 0.1065689698, blue: 0.4587435722, alpha: 1)
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        
        view.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = view.bounds
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        fullNameTextField,
        emailTextField,
        passwordTextField,
        registerButton
        ])
    
    fileprivate func setupLayout() {
        
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: -50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
