//
//  CardView.swift
//  Tinder Firestore
//
//  Created by hosam on 5/21/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var card:CardViewModel? {
        didSet{
            guard let cards = card else { return }
           mainImage.image = UIImage(named: cards.imageName )
            userInfo.attributedText = cards.attributedText
            userInfo.textAlignment = cards.textAlignment
        }
    }
    
    //Configuration values
    fileprivate let threShold:CGFloat = 90
    
    
    let mainImage:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "holiday"))
        im.clipsToBounds = true
        im.layer.cornerRadius = 12
        
        return im
    }()
    let userInfo:UILabel = {
        let la = UILabel(string: "hosam", font: .boldSystemFont(ofSize: 30), numberOfLines: 0)
       la.textColor = .white
        return la
    }()
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupViews()
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
    }
    
    func setupViews()  {
       
      
        addSubview(mainImage)
        addSubview(userInfo)
        
        mainImage.fillSuperview(padding: .init(top: 12, left: 12, bottom: 12, right: 12))
        userInfo.anchor(top: nil, leading: mainImage.leadingAnchor, bottom: mainImage.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 16, bottom: 20, right: 0))
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
    
    @objc func handlePan(gesture:UIPanGestureRecognizer)  {
        switch gesture.state {
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
