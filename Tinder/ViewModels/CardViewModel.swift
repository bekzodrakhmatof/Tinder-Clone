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

struct CardViewModel {
    
    let imageName: String
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
}
