//
//  HomeBottomControlsStackView.swift
//  Tinder Firestore
//
//  Created by hosam on 5/21/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {

    lazy var refreshButton = createButton(image:#imageLiteral(resourceName: "refresh_circle"))
    lazy var dislikeButton = createButton(image:#imageLiteral(resourceName: "dismiss_circle"))
    lazy var superLikeButton = createButton(image:#imageLiteral(resourceName: "super_like_circle"))
    lazy var likeButton = createButton(image:#imageLiteral(resourceName: "like_circle"))
    lazy var specialButton = createButton(image:#imageLiteral(resourceName: "boost_circle"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let subViewsBottom = [refreshButton,dislikeButton,superLikeButton,likeButton,specialButton]
        
        subViewsBottom.forEach { (v) in
            addArrangedSubview(v)
        }
        distribution = .fillEqually
        constrainHeight(80)
    }
    
    func createButton(image:UIImage) -> UIButton {
        let bt = UIButton()
        bt.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        bt.imageView?.contentMode = .scaleAspectFill
       return bt
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
