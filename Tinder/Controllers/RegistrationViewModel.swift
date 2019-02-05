//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by Bekzod Rakhmatov on 27/01/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    var bindableImage         = Bindable<UIImage>()
    var bindableIsFormValid   = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()
    
    var fullName: String? { didSet { checkForValidity() } }
    var email: String?    { didSet { checkForValidity() } }
    var password: String? { didSet { checkForValidity() } }
    
    func checkForValidity() {
        
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && bindableImage.value != nil
        bindableIsFormValid.value = isFormValid
    }
    
    func perfromRegistration(completion: @escaping (Error?) -> ()) {
        
        guard let email = email, let password = password else { return }
        
        bindableIsRegistering.value = true
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                
                completion(error)
                return
            }
            
            self.saveImageToFirebase(completion: completion)

        }
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()) {
        
        // You can only upload
        let fileName = UUID().uuidString
        let reference = Storage.storage().reference(withPath: "/images/\(fileName).jpg")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        reference.putData(imageData, metadata: nil, completion: { (_, err) in
            
            if let err = err {
                completion(err)
                return
            }
            
            reference.downloadURL(completion: { (url, error) in
                
                if let error = error {
                    completion(error)
                    return
                }
                
                let imageUrl = url?.absoluteString ?? ""
                
                self.bindableIsRegistering.value = false
                self.saveInfoToFirestore(imageURL: imageUrl, completion: completion)
            })
        })
    }
    
    fileprivate func saveInfoToFirestore(imageURL: String, completion: @escaping (Error?) -> ()) {
        
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        let documentData: [String: Any] = [
            "fullName": fullName ?? "",
            "uid": uid,
            "imageUrl1": imageURL,
            "age": SettingsController.defaultMinSeekingAge,
            "minSeekingAge": SettingsController.defaultMinSeekingAge,
            "maxSeekingAge": SettingsController.defaultMaxSeekingAge
            ]
        
        Firestore.firestore().collection("users").document(uid).setData(documentData) { (error) in
            
            if let error = error {
                
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
}
