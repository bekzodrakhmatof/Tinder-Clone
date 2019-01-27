//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by Bekzod Rakhmatov on 27/01/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    
    var fullName: String? {
        didSet {
            
            checkForValidity()
        }
    }
    var email: String? {
        didSet {
            
            checkForValidity()
        }
    }
    var password: String? {
        didSet {
            
            checkForValidity()
        }
    }
    
    fileprivate func checkForValidity() {
        
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
    
    var bindableIsFormValid = Bindable<Bool>()
}
