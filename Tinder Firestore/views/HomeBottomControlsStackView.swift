//
//  HomeBottomControlsStackView.swift
//  Tinder Firestore
//
//  Created by hosam on 5/21/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let subViewsBottom = [#imageLiteral(resourceName: "cancel_shadow"),#imageLiteral(resourceName: "gear"),#imageLiteral(resourceName: "like_selected"),#imageLiteral(resourceName: "send2"),#imageLiteral(resourceName: "right_arrow_shadow")].map { (img) -> UIView in
            let button = UIButton()
            button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        
        subViewsBottom.forEach { (v) in
            addArrangedSubview(v)
        }
        distribution = .fillEqually
        constrainHeight(constant: 80)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
