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
        
        let textField = CustomTextField(padding: 16)
        textField.placeholder = "Enter full name"
        textField.backgroundColor = .white
    
        return textField
    }()
    
    let emailTextField: CustomTextField = {
        
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "Enter email"
        textField.keyboardType = .emailAddress
        textField.backgroundColor = .white
        
        return textField
    }()
    
    let passwordTextField: CustomTextField = {
        
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "Enter password"
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    let registerButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8111879826, green: 0.1042452082, blue: 0.3321437836, alpha: 1)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        setupLayout()
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
    
    fileprivate func setupLayout() {
        
        let stackView = UIStackView(arrangedSubviews: [
            selectPhotoButton,
            fullNameTextField,
            emailTextField,
            passwordTextField,
            registerButton
            ])
        
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: -50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
