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
            
            imageView.image = UIImage(named: cardViewModel.imageName)
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
        }
    }
    
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    fileprivate let informationLabel = UILabel()
    
    
    // Configuration
    fileprivate let treshold: CGFloat = 120
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.fillSuperview()
        
        addSubview(informationLabel)
        informationLabel.textColor = .white
        informationLabel.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        informationLabel.text = "TESRT NAME TEST NAME AGE PROFESSION"
        informationLabel.numberOfLines = 0
        
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: -16, right: 16))
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        addGestureRecognizer(panGesture)
    }

    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
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
