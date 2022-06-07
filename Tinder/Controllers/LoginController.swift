//
//  LoginController.swift
//  Tinder
//
//  Created by Bekzod Rakhmatov on 03/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol LoginControllerDelegate {
    func didFinishLoggingIn()
}

class LoginController: UIViewController {
    
    var loginDelegate: LoginControllerDelegate?
    
    lazy var emailTextField: UITextField = {
        let textField = CustomTextField(padding: 22, height: 44)
        textField.placeholder = "Enger email"
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = CustomTextField(padding: 22, height: 44)
        textField.placeholder = "Enter password"
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.3459398746, green: 0.340980351, blue: 0.3452142477, alpha: 1), for: .disabled)
        button.backgroundColor = #colorLiteral(red: 0.6714041233, green: 0.6664924026, blue: 0.6706650853, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var backToRegisterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate let loginViewModel = LoginViewModel()
    fileprivate let loginHUD = JGProgressHUD(style: .dark)
    
    fileprivate func setupTapGesture() {
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap() {
        
        self.view.endEditing(true)
    }
    
    @objc fileprivate func handleTextField(textField: UITextField) {
        
        if textField == emailTextField {
            
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
    }
    
    @objc fileprivate func handleLoginButton() {
        
        loginViewModel.performLogin { (error) in
            self.loginHUD.dismiss()
            if let error = error {
                print("Failed to login: \(error)")
            }
            
            self.dismiss(animated: true, completion: {
                self.loginDelegate?.didFinishLoggingIn()
            })
        }
    }
    
    @objc fileprivate func handleBackButton() {
        
        navigationController?.popViewController(animated: true)
    }
    
    lazy var verticalStackView: UIStackView = {
        let stacView = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            loginButton
            ])
        stacView.axis = .vertical
        stacView.spacing = 8
        return stacView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupLayout()
        setupTapGesture()
        setupBindables()
    }
    
    fileprivate func setupBindables() {
        loginViewModel.isFormValid.bind { [unowned self] (isFormValid) in
            
            guard let ifFormValid = isFormValid else { return }
            self.loginButton.isEnabled = ifFormValid
            self.loginButton.backgroundColor = ifFormValid ? #colorLiteral(red: 0.8252845407, green: 0, blue: 0.3240153193, alpha: 1) : .lightGray
        }
        
        loginViewModel.isLogedIn.bind { [unowned self] (isRegistering) in
            
            if isRegistering == true {
                self.loginHUD.textLabel.text = "Registering..."
                self.loginHUD.show(in: self.view)
            } else {
                self.loginHUD.dismiss()
            }
        }
    }
    
    let gradientLayer = CAGradientLayer()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupGradientLayer() {
        
        let topColor    = #colorLiteral(red: 0.9880711436, green: 0.3838337064, blue: 0.3728808165, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8920591474, green: 0.1065689698, blue: 0.4587435722, alpha: 1)
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        
        view.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupLayout() {
        
        navigationController?.isNavigationBarHidden = true
        view.addSubview(verticalStackView)
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: -50))
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(backToRegisterButton)
        backToRegisterButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}
