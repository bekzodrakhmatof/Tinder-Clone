//
//  SwipePhotosController.swift
//  Tinder
//
//  Created by Bekzod Rakhmatov on 04/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit

class SwipePhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var controllers = [UIViewController]()
    
    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
                let photoController = PhotoController(imageUrl: imageUrl)
                return photoController
            })
            
            setViewControllers([controllers.first!], direction: .forward, animated: false, completion: nil)
            
            setupBarViews()
        }
    }
    
    fileprivate let barsStackView = UIStackView(arrangedSubviews: [])
    fileprivate let deselctedBarColor = UIColor(white: 0, alpha: 0.1)
    
    fileprivate func setupBarViews() {
        
        cardViewModel.imageUrls.forEach { (_) in
            
            let barView = UIView()
            barView.backgroundColor = deselctedBarColor
            barView.layer.cornerRadius = 2
            barsStackView.addArrangedSubview(barView)
        }
        
        barsStackView.arrangedSubviews.first?.backgroundColor = .white
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        
        view.addSubview(barsStackView)
        
        let paddingTop = UIApplication.shared.statusBarFrame.height + 8
        barsStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: 8, bottom: 0, right: -8), size: .init(width: 0, height: 4))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        view.backgroundColor = .white
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let currentPhotoController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentPhotoController}) {
            barsStackView.arrangedSubviews.forEach({$0.backgroundColor =  deselctedBarColor})
            barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
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
