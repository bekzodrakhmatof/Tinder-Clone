//
//  SwipePhotosController.swift
//  Tinder
//
//  Created by Bekzod Rakhmatov on 04/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit

class SwipePhotosController: UIPageViewController, UIPageViewControllerDataSource {
    
    var controllers = [UIViewController]()
    
    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
                let photoController = PhotoController(imageUrl: imageUrl)
                return photoController
            })
            
            setViewControllers([controllers.first!], direction: .forward, animated: false, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        view.backgroundColor = .white
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
       
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        
        if index == 0 { return nil }
        return controllers[index - 1]
    }
}

class PhotoController: UIViewController {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "jane3"))
    
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
