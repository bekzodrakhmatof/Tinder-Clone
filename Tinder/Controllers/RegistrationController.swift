//
//  RegistrationController.swift
//  Tinder
//
//  Created by Bekzod Rakhmatov on 27/01/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

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
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        
        let textField = CustomTextField(padding: 16, height: 44)
        textField.placeholder = "Enter full name"
        textField.addTarget(self, action: #selector(handleTextChange(_:)), for: .editingChanged)
        
        return textField
    }()
    
    let emailTextField: CustomTextField = {
        
        let textField = CustomTextField(padding: 16, height: 44)
        textField.placeholder = "Enter email"
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(handleTextChange(_:)), for: .editingChanged)
    
        return textField
    }()
    
    let passwordTextField: CustomTextField = {
        
        let textField = CustomTextField(padding: 16, height: 44)
        textField.placeholder = "Enter password"
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextChange(_:)), for: .editingChanged)
        
        return textField
    }()
    
    let registerButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.setTitleColor(#colorLiteral(red: 0.3459398746, green: 0.340980351, blue: 0.3452142477, alpha: 1), for: .disabled)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.6714041233, green: 0.6664924026, blue: 0.6706650853, alpha: 1)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.clipsToBounds = true
        button.layer.cornerRadius = 22
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        return button
    }()
    
    let goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationObservers()
        setupGradientLayer()
        setupLayout()
        setupTapGesture()
        setupRegistrationViewModelObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc fileprivate func handleGoToLogin() {
        
        let loginController = LoginController()
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    @objc fileprivate func handleSelectPhoto() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    let registeringHUD = JGProgressHUD(style: .dark)
    
    @objc fileprivate func handleRegisterButton() {
        
        self.handleTap()
        
        registrationViewModel.bindableIsRegistering.value = true
        registrationViewModel.perfromRegistration { [weak self] (error) in
            
            if let error = error {
                
                self?.showHUDWithError(error: error)
                return
            }
            
            print("Finished registering")
        }
    }
    
    fileprivate func showHUDWithError(error: Error) {
        
        registeringHUD.dismiss(animated: true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    let registrationViewModel = RegistrationViewModel()
    
    //MARK: - Register Model View Bindable
    fileprivate func setupRegistrationViewModelObservers() {
        
        registrationViewModel.bindableIsFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else  { return }
            self.registerButton.isEnabled = isFormValid
            if isFormValid {
                
                self.registerButton.backgroundColor = #colorLiteral(red: 0.8111879826, green: 0.1042452082, blue: 0.3321437836, alpha: 1)
                
            } else {
                
                self.registerButton.backgroundColor = #colorLiteral(red: 0.6714041233, green: 0.6664924026, blue: 0.6706650853, alpha: 1)
            }
        }
        
        registrationViewModel.bindableImage.bind { [unowned self] (image) in
            
            self.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registrationViewModel.bindableIsRegistering.bind { [unowned self] (isRegistering) in
            
            if isRegistering == true {
                
                self.registeringHUD.textLabel.text = "Register"
                self.registeringHUD.show(in: self.view)
            } else {
                self.registeringHUD.dismiss(animated: true)
            }
        }
    }
    
    @objc fileprivate func handleTextChange(_ textField: UITextField) {
        
        if textField == fullNameTextField {
            
            registrationViewModel.fullName = textField.text
            
        } else if textField == emailTextField {
            
            registrationViewModel.email = textField.text
            
        } else {
            
            registrationViewModel.password = textField.text
        }
    }
    
    fileprivate func setupTapGesture() {
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap() {
        
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
        let bottomSpace = view.frame.height - overllStackView.frame.origin.y - overllStackView.frame.height
        let differnce = keybaordFrame.height - bottomSpace
        
        self.view.transform = CGAffineTransform(translationX: 0, y: -differnce - 8)
    }
    
    let gradientLayer = CAGradientLayer()
    
    fileprivate func setupGradientLayer() {
        
        let topColor    = #colorLiteral(red: 0.9880711436, green: 0.3838337064, blue: 0.3728808165, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8920591474, green: 0.1065689698, blue: 0.4587435722, alpha: 1)
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        
        view.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = view.bounds
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradientLayer.frame = view.bounds
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        if self.traitCollection.verticalSizeClass == .compact {
            
            overllStackView.axis = .horizontal
        } else {
            
            overllStackView.axis = .vertical
        }
    }
    
    lazy var verticalStackView: UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [
            fullNameTextField,
            emailTextField,
            passwordTextField,
            registerButton
            ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        return stackView
    }()
    
    lazy var overllStackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        verticalStackView
        ])
    
    fileprivate func setupLayout() {
        
        navigationController?.isNavigationBarHidden = true
        view.addSubview(overllStackView)
        overllStackView.axis = .horizontal
        overllStackView.spacing = 24
        
        selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        
        overllStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: -50))
        overllStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        
        dismiss(animated: true, completion: nil)
    }
}
