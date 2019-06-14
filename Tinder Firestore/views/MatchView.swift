//
//  MatchView.swift
//  Tinder Firestore
//
//  Created by hosam on 5/29/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class MatchView: UIView {
    
    lazy var views = [
        itsAMatchImageView,
        descriptionLabel,
        cureentUserImage,
        cardUserImage,
        sendMessageButton,
        keepSwipingButton
    ]
    var currentUser:UserModel!
    var cardID:String!{
        didSet{
            let query = Firestore.firestore().collection("Users").document(cardID)
            query.getDocument { (snapshot, err) in
                if let err = err{
                    print(err)
                    return
                }
                guard let data = snapshot?.data() else {return}
                let user = UserModel(dict: data)
                
                self.descriptionLabel.text = "You and \(user.name ?? "") have liked\neach other"
                guard let url = URL(string: user.imageUrl1 ?? "") else {return}
                self.cardUserImage.sd_setImage(with: url)
                
                guard let currentUserUrl = URL(string: self.currentUser.imageUrl1 ?? "") else {return}
                self.cureentUserImage.sd_setImage(with: currentUserUrl, completed: { (_, _, _, _) in
                    self.setupAnimations()
                })
                
            }
        }
    }
    
    let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    fileprivate  let imageWidth: CGFloat = 140
    fileprivate let itsAMatchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let cureentUserImage:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        im.clipsToBounds = true
        im.contentMode = .scaleAspectFill
        im.layer.cornerRadius = 140 / 2
        im.layer.borderWidth = 2
        im.layer.borderColor = UIColor.white.cgColor
        
        return im
    }()
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You and X have liked\neach other"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    let cardUserImage:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "lady4c"))
        im.clipsToBounds = true
        im.contentMode = .scaleAspectFill
        im.layer.cornerRadius = 140 / 2
        im.layer.borderWidth = 2
        im.layer.borderColor = UIColor.white.cgColor
        im.alpha = 0
        return im
    }()
    
    lazy var sendMessageButton: UIButton = {
        let button = SendMessageButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    lazy var  keepSwipingButton: UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleKeepSwipe), for: .touchUpInside)
        return button
    }()
    
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurEffect()
        setupViews()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- uset methods
    
    func setupAnimations()  {
        views.forEach({$0.alpha = 1})
        let angle = 30 * CGFloat.pi / 180
        
        cureentUserImage.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        cardUserImage.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        
        sendMessageButton.transform = CGAffineTransform(translationX: -400, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: 400, y: 0)
        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
            //first animation translation
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.cureentUserImage.transform = CGAffineTransform(rotationAngle: -angle)
                self.cardUserImage.transform = CGAffineTransform(rotationAngle: angle)
            })
            
            //second animation rotation
            UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.3, animations: {
                self.cureentUserImage.transform = .identity
                self.cardUserImage.transform = .identity
                
            })
        })
        
        UIView.animate(withDuration: 0.7, delay: 0.6 * 1.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            
            self.sendMessageButton.transform = .identity
            self.keepSwipingButton.transform = .identity
        })
    }
    
   fileprivate func setupViews()  {
        views.forEach { (v) in
            addSubview(v)
            v.alpha = 0
        }
        
        itsAMatchImageView.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 300, height: 80))
        itsAMatchImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        descriptionLabel.anchor(top: nil, leading: leadingAnchor, bottom: cureentUserImage.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 50))
        cureentUserImage.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 16),size: .init(width: 140, height: 140))
        cureentUserImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cardUserImage.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil,padding: .init(top: 0, left: 16, bottom: 0, right: 0),size: .init(width: 140, height: 140))
        cardUserImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        sendMessageButton.anchor(top: cureentUserImage.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 60))
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, leading: sendMessageButton.leadingAnchor, bottom: nil, trailing: sendMessageButton.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 60))
    }
    
  fileprivate  func setupBlurEffect()  {
        visualEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapRemoved)))
        addSubview(visualEffect)
        visualEffect.fillSuperview()
        visualEffect.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.visualEffect.alpha = 1
        }) { (_) in
            
        }
    }
    
    //TODO:- handle methods
    
    @objc func handleSend()  {
        print(123)
    }
    
    @objc func handleKeepSwipe()  {
        print(123)
    }
    
    @objc  func handleTapRemoved()  {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.visualEffect.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}
