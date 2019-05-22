//
//  CardView.swift
//  Tinder Firestore
//
//  Created by hosam on 5/21/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var cardViewModel:CardViewModel! {
        didSet{
          mainImage.image = UIImage(named: cardViewModel.imageNames.first ?? "" )
            userInfo.attributedText = cardViewModel.attributedText
            userInfo.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageNames.count).forEach { (_) in
                let vi = UIView()
                vi.backgroundColor = barDeselctedItem
                barStackView.addArrangedSubview(vi)
                
                barStackView.arrangedSubviews.first?.backgroundColor = .white

                setupImageNndexObserver()
            }
        }
    }
    
    func setupImageNndexObserver()  {
        cardViewModel.imageIndexObserver = { [weak self] (index,image) in
         self?.mainImage.image = image
            self?.barStackView.arrangedSubviews.forEach { (v) in
                v.backgroundColor = self?.barDeselctedItem
            }
            
            self?.barStackView.arrangedSubviews[index].backgroundColor = .white

        }
    }
    //Configuration values
    fileprivate let threShold:CGFloat = 90
    fileprivate let barDeselctedItem = UIColor(white: 0, alpha: 0.1)
    
    let barStackView = UIStackView()
let gradiantLayer = CAGradientLayer()
  fileprivate  let mainImage:UIImageView = {
    let im = UIImageView()
       im.clipsToBounds = true
        im.layer.cornerRadius = 12
        
        return im
    }()
   fileprivate let userInfo:UILabel = {
        let la = UILabel(string: "hosam", font: .boldSystemFont(ofSize: 30), numberOfLines: 0)
       la.textColor = .white
        return la
    }()
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
         setupGradiantLayer()
        
        setupViews()
       setupGestures()
    }
    
    func setupGestures ()  {
    addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapped)))
    }
    
    func setupBarStackView()  {
        addSubview(barStackView)
        barStackView.anchor(top: mainImage.topAnchor, leading: mainImage.leadingAnchor, bottom: nil, trailing: mainImage.trailingAnchor,padding: .init(top: 8, left: 8, bottom: 0, right: 8),size: .init(width: 0, height: 4))
barStackView.spacing = 4
        barStackView.distribution = .fillEqually
        
    }
    
    func setupGradiantLayer()  {
       
        gradiantLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradiantLayer.locations = [0.5,1.1]
//        gradiantLayer.frame = self.frame //frame is zero
//        gradiantLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        layer.addSublayer(gradiantLayer)
    }
    
    override func layoutSubviews() {
        gradiantLayer.frame = self.frame
    }
    
    func setupViews()  {
        
         addSubview(mainImage)
         setupBarStackView()
        addSubview(userInfo)
        
        mainImage.fillSuperview(padding: .init(top: 12, left: 12, bottom: 12, right: 12))
        userInfo.anchor(top: nil, leading: mainImage.leadingAnchor, bottom: mainImage.bottomAnchor, trailing: mainImage.trailingAnchor,padding: .init(top: 0, left: 16, bottom: 20, right: 0))
        
    }
    
    fileprivate func handleChaneged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        //rotate
        // radian to degree
        let degree:CGFloat = translation.x / 20 // divide by 20 for slow operation only
        let angle = degree * .pi / 180
        
        
        let rotateTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotateTransform.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(gesture:UIPanGestureRecognizer) {
        let translateDirection:CGFloat = gesture.translation(in: nil).x > 1 ? 1 : -1
        let shouldDismisCard = abs(gesture.translation(in: nil).x) > threShold
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            if shouldDismisCard {
                self.frame = CGRect(x: 1000 * translateDirection, y: 0, width: self.frame.width, height: self.frame.height)
            }else {
                self.transform = .identity
            }
        }){(_) in
            self.transform = .identity
            self.removeFromSuperview()
//            self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
        }
    }
    
    @objc  func handleTapped(gesture:UITapGestureRecognizer)  {
        let tapPosition = gesture.location(in: nil)
        let shouldGoNextPhoto = tapPosition.x > frame.width / 2 ? true : false
        
        if shouldGoNextPhoto {
            cardViewModel.goToNextPhoto()
        }else {
            cardViewModel.goToPreviousPhoto()
       }
    }
    
    @objc func handlePan(gesture:UIPanGestureRecognizer)  {
        
        switch gesture.state {
           
        case .began:
            superview?.subviews.forEach({ (subView) in
                subView.layer.removeAllAnimations()  //solve multi animation occures in screen
            })
        case .changed:
            handleChaneged(gesture)
        case .ended:
            handleEnded(gesture: gesture)
        default:
            ()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
