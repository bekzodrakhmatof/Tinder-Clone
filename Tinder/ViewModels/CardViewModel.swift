//
//  CardViewModel.swift
//  Tinder
//
//  Created by Bekzod Rakhmatov on 26/01/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit

protocol ProducesCardViewModel {
    
    func toCardViewModel() -> CardViewModel
}


class CardViewModel {
    
    let uid: String
    let imageUrls: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(uid: String, imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        
        self.uid              = uid
        self.imageUrls        = imageNames
        self.attributedString = attributedString
        self.textAlignment    = textAlignment
    }
    
    fileprivate var imageIndex = 0 {
        
        didSet {
            
            let imageUrl = imageUrls[imageIndex]
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }
    
    // Reactive programming
    var imageIndexObserver: ((Int, String?) -> ())?
    
    func advaceToNextPhoto() {
        
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)
    }
    
    func goToPreviousPhoto() {
        
        imageIndex = max(0, imageIndex - 1)
    }
}
