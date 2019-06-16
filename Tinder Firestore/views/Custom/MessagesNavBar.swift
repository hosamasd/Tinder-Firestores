//
//  MessagesNavBar.swift
//  Tinder Firestore
//
//  Created by hosam on 6/16/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import LBTATools
import SDWebImage

class MessagesNavBar: UIView {
    
    let backButton:UIButton = {
        let bt = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: .red)
        bt.constrainWidth(44)
        bt.constrainHeight(44)
        return bt
    } ()
    let flagButton:UIButton = {
        let bt = UIButton(image: #imageLiteral(resourceName: "flag"), tintColor: .red)
        bt.constrainWidth(44)
        bt.constrainHeight(44)
        return bt
    }()
    
    let profileImageView = CircularImageView(width: 44, image: #imageLiteral(resourceName: "kelly2"))
    let userNameLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 14), textColor: #colorLiteral(red: 0.8117647059, green: 0.4431372549, blue: 0.4549019608, alpha: 1), textAlignment: .center)
    
    fileprivate let match:MatchesModel
    
    init(match:MatchesModel) {
        self.match = match
        super.init(frame: .zero)
        
        userNameLabel.text = match.name
        profileImageView.sd_setImage(with: URL(string: match.imageProfileUrl))
        
        backgroundColor = .white
        setupShadow(opacity: 0.2, radius: 9, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        let middleStack = hstack(stack(profileImageView,userNameLabel, spacing: 8, alignment: .center), alignment: .center)
        
        hstack(backButton,middleStack,flagButton, alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
