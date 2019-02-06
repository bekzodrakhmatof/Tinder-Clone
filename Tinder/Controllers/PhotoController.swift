//
//  PhotoController.swift
//  Tinder
//
//  Created by Bekzod Rakhmatov on 05/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit

class PhotoController: UIViewController {

    let imageView = UIImageView(image: #imageLiteral(resourceName: "photo_placeholder"))
    
    init(imageUrl: String) {
        
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
}
