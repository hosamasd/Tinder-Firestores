//
//  MatchesNavBar.swift
//  Tinder Firestore
//
//  Created by hosam on 6/15/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import LBTATools

class MatchesNavBar: UIView {
    
    let backButton = UIButton(image: #imageLiteral(resourceName: "app_icon"), tintColor: .lightGray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let logoImageIcon = UIImageView(image: #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysOriginal), contentMode: .scaleAspectFit)
        logoImageIcon.tintColor = #colorLiteral(red: 0.8117647059, green: 0.4431372549, blue: 0.4549019608, alpha: 1)
        let messageLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 20), textColor: #colorLiteral(red: 0.8117647059, green: 0.4431372549, blue: 0.4549019608, alpha: 1), textAlignment: .center)
        let feedLabel = UILabel(text: "Feed", font: .boldSystemFont(ofSize: 20), textColor: .gray, textAlignment: .center)
        
        setupShadow(opacity: 0.2, radius: 9, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        stack(logoImageIcon.withHeight(50),hstack(messageLabel,feedLabel,distribution: .fillEqually)).padTop(10)
        
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0),size: .init(width: 34, height: 34))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
