//
//  CardView.swift
//  Tinder Firestore
//
//  Created by hosam on 5/21/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(card:CardViewModel)
    func didRemoveCard(card:CardView)
}

class CardView: UIView {
    
    var delgate:CardViewDelegate?
    //Configuration values
    fileprivate let threShold:CGFloat = 90
    fileprivate let barDeselctedItem = UIColor(white: 0, alpha: 0.1)
    
    let swipingViewController = SwipingPhotoVC(isCarViewMode: true)
    let barStackView = UIStackView()
    let gradiantLayer = CAGradientLayer()
    
    var nextCardView:CardView? 
    
    var cardViewModel:CardViewModel! {
        didSet{
            //            let image = cardViewModel.imageNames.first ?? ""
            //            if let url = URL(string: image) {
            //                mainImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "photo_placeholder"), options: .continueInBackground) // if user not have any phoho
            //            }
            swipingViewController.cardsUser = cardViewModel
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
    
    
    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleMoreInfo() {
        // use a delegate instead, much more elegant
        
        delgate?.didTapMoreInfo(card: self.cardViewModel)
    }
    
    
    func setupImageNndexObserver()  {
        cardViewModel.imageIndexObserver = { [weak self] (index,imageUrl) in
            //            if let url = URL(string: imageUrl ?? "") {
            //                self?.mainImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "photo_placeholder"), options: .continueInBackground) // if user not have any phoho
            //           }
            self?.barStackView.arrangedSubviews.forEach { (v) in
                v.backgroundColor = self?.barDeselctedItem
            }
            
            self?.barStackView.arrangedSubviews[index].backgroundColor = .white
            
        }
    }
    
    //replaceing this wit swiping page VC
    //    fileprivate  let mainImage:UIImageView = {
    //        let im = UIImageView()
    //        im.clipsToBounds = true
    //        im.layer.cornerRadius = 12
    //
    //        return im
    //    }()
    
    
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
        setupBarStackView()
    }
    
    func setupGestures ()  {
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapped)))
    }
    
    
    func setupBarStackView()  {
        var swipingPhoto = swipingViewController.view!
        addSubview(barStackView)
        barStackView.anchor(top: swipingPhoto.topAnchor, leading: swipingPhoto.leadingAnchor, bottom: nil, trailing: swipingPhoto.trailingAnchor,padding: .init(top: 8, left: 8, bottom: 0, right: 8),size: .init(width: 0, height: 4))
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
        var swipingPhoto = swipingViewController.view!
        addSubview(swipingPhoto)
        //        setupBarStackView()
        addSubview(userInfo)
        
        
        swipingPhoto.fillSuperview(padding: .init(top: 12, left: 12, bottom: 12, right: 12))
        userInfo.anchor(top: nil, leading: swipingPhoto.leadingAnchor, bottom: swipingPhoto.bottomAnchor, trailing: swipingPhoto.trailingAnchor,padding: .init(top: 0, left: 16, bottom: 20, right: 0))
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 30, right: 16), size: .init(width: 44, height: 44))
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
        
        if shouldDismisCard {
            guard let home = delgate as? HomeVC else { return  }
            if translateDirection == 1 {
                home.handleLike()
            }else {
                home.handleDisLike()
            }
        }else {
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                if shouldDismisCard {
                    self.frame = CGRect(x: 1000 * translateDirection, y: 0, width: self.frame.width, height: self.frame.height)
                }else {
                    self.transform = .identity
                }
                
            })
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
