//
//  AgeRangeCell.swift
//  Tinder
//
//  Created by Bekzod Rakhmatov on 03/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit

class AgeRangeCell: UITableViewCell {
    
    let minSlider: UISlider = {
        
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let maxSlider: UISlider = {
        
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let minLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Min: 18"
        return label
    }()
    
    let maxLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Max: 88"
        return label
    }()
    
    class AgeRangeLabel: UILabel {
        
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let padding: CGFloat = 16
        let topStackView = UIStackView(arrangedSubviews: [minLabel, minSlider])
        topStackView.spacing = padding
        
        let bottomStackView = UIStackView(arrangedSubviews: [maxLabel, maxSlider])
        bottomStackView.spacing = padding
        
        let overallStackView = UIStackView(arrangedSubviews: [
            
                topStackView,
                bottomStackView
            ])
        
        overallStackView.axis = .vertical
        overallStackView.distribution = .fillEqually
        overallStackView.spacing = padding
        addSubview(overallStackView)
        overallStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: padding, left: padding, bottom: -padding, right: -padding))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
