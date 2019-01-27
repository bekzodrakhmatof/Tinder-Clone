//
//  CardView.swift
//  Tinder
//
//  Created by Bekzod Rakhmatov on 26/01/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var cardViewModel: CardViewModel! {
        
        didSet {
            
            imageView.image = UIImage(named: cardViewModel.imageNames.first ?? "")
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            // Dummy bars for now
            (0..<cardViewModel.imageNames.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barView)
            }
            
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
            
        }
    }
    
    fileprivate func setupImageIndexObserver() {
        
        cardViewModel.imageIndexObserver = { [weak self] (imageIndex, image) in
            
            self?.imageView.image = image
            
            self?.barsStackView.arrangedSubviews.forEach { (view) in
                
                view.backgroundColor = self?.barDeselectedColor
            }
            
            self?.barsStackView.arrangedSubviews[imageIndex].backgroundColor = .white
        }
    }
    
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    fileprivate let informationLabel = UILabel()
    let gradientLayer = CAGradientLayer()
    
    
    // Configuration
    fileprivate let treshold: CGFloat = 120
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        addGestureRecognizer(tapGesture)
    }
    
    fileprivate func setupLayout() {
        
        layer.cornerRadius = 10
    
        clipsToBounds = true
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.fillSuperview()
        
        setupBarsStackView()
        
        // Add gradian layer
        setupGradianLayer()
        
        addSubview(informationLabel)
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
        
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: -16, right: 16))
    }
    
    fileprivate let barsStackView = UIStackView()
    
    fileprivate func setupBarsStackView() {
        
        addSubview(barsStackView)
        
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: -8), size: .init(width: 0, height: 4))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        
    }
    
    fileprivate func setupGradianLayer() {
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        
        gradientLayer.frame = self.frame
        
    }
    
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        
        
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        
        if shouldAdvanceNextPhoto {
            
            cardViewModel.advaceToNextPhoto()
        } else {
            
            cardViewModel.goToPreviousPhoto()
        }
    }

    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        
        // Rotation
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        
        let shouldDismissCard = gesture.translation(in: nil).x > treshold || gesture.translation(in: nil).x < -treshold
        let frameToSide = gesture.translation(in: nil).x
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                
                self.frame = CGRect(x: frameToSide * 10, y: 0, width: self.frame.size.width, height: self.frame.size.height)
                
            } else {
                
                self.transform = .identity
            }
            
        }) { (_) in
            
            self.transform = .identity
            
            if shouldDismissCard {
                
                self.removeFromSuperview()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
