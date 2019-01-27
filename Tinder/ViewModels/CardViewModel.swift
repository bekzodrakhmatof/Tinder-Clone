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
    
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        
        self.imageNames       = imageNames
        self.attributedString = attributedString
        self.textAlignment    = textAlignment
    }
    
    fileprivate var imageIndex = 0 {
        
        didSet {
            
            let imageName = imageNames[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, image)
        }
    }
    
    // Reactive programming
    var imageIndexObserver: ((Int, UIImage?) -> ())?
    
    func advaceToNextPhoto() {
        
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    
    func goToPreviousPhoto() {
        
        imageIndex = max(0, imageIndex - 1)
    }
}
