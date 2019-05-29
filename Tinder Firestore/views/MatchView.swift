//
//  MatchView.swift
//  Tinder Firestore
//
//  Created by hosam on 5/29/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class MatchView: UIView {
     let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let cureentUserImage:UIImageView = {
      let im = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        im.clipsToBounds = true
        im.contentMode = .scaleAspectFill
        im.layer.cornerRadius = 140 / 2
        im.layer.borderWidth = 2
        im.layer.borderColor = UIColor.white.cgColor
        
        return im
    }()
    let cardUserImage:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "lady4c"))
        im.clipsToBounds = true
        im.contentMode = .scaleAspectFill
        im.layer.cornerRadius = 140 / 2
        im.layer.borderWidth = 2
        im.layer.borderColor = UIColor.white.cgColor
        
        return im
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurEffect()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
    addSubview(cureentUserImage)
        addSubview(cardUserImage)
        
        cureentUserImage.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor,padding: .zero,size: .init(width: 140, height: 140))
        cureentUserImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cardUserImage.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil,padding: .init(top: 0, left: 32, bottom: 0, right: 0),size: .init(width: 140, height: 140))
        cardUserImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setupBlurEffect()  {
        visualEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapRemoved)))
        addSubview(visualEffect)
        visualEffect.fillSuperview()
        visualEffect.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.visualEffect.alpha = 1
        }) { (_) in
            
        }
    }
    
  @objc  func handleTapRemoved()  {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
        self.visualEffect.alpha = 0
    }) { (_) in
        self.removeFromSuperview()
    }
    }
}
