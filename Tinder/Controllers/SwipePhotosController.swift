//
//  SwipePhotosController.swift
//  Tinder
//
//  Created by Bekzod Rakhmatov on 04/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit

class SwipePhotosController: UIPageViewController, UIPageViewControllerDataSource {

    let controllers = [
    
        PhotoController(image: #imageLiteral(resourceName: "jane1")),
        PhotoController(image: #imageLiteral(resourceName: "kelly1")),
        PhotoController(image: #imageLiteral(resourceName: "jane2")),
        PhotoController(image: #imageLiteral(resourceName: "photo_placeholder")),
        PhotoController(image: #imageLiteral(resourceName: "slide_out_menu_poster")),
        PhotoController(image: #imageLiteral(resourceName: "lady5c")),
        PhotoController(image: #imageLiteral(resourceName: "jane3"))
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        view.backgroundColor = .white
    
        setViewControllers([controllers.first!], direction: .forward, animated: false, completion: nil)
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
    
    init(image: UIImage) {
        imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFit
    }
}
