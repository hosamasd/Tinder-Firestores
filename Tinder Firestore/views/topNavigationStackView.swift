//
//  HomeTopControlsStackView.swift
//  Tinder Firestore
//
//  Created by hosam on 5/21/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class topNavigationStackView: UIStackView {

    let messageButton = UIButton()
    let settingButton = UIButton()
    let fireImageView = UIImageView(image: #imageLiteral(resourceName: "search_unselected"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fireImageView.contentMode = .scaleAspectFit
        
        settingButton.setImage(#imageLiteral(resourceName: "plus_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
         messageButton.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [settingButton,UIView(),fireImageView,UIView(),messageButton].forEach { (v) in
            addArrangedSubview(v)
        }
        
        
        distribution = .equalCentering
        constrainHeight(constant: 80)
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
