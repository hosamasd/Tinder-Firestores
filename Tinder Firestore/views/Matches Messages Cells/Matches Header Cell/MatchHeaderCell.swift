//
//  MatchHeaderCell.swift
//  Tinder Firestore
//
//  Created by hosam on 6/17/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import LBTATools

class MatchHeaderCell: UICollectionReusableView {
    let newMatchesLabel = UILabel(text: "New Matches", font: .boldSystemFont(ofSize: 20), textColor: #colorLiteral(red: 1, green: 0.4, blue: 0.4274509804, alpha: 1))
    let horzientalViewController = HorizentalMatchMessageVC()
    
    let messageLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 20), textColor: #colorLiteral(red: 1, green: 0.4, blue: 0.4274509804, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        horzientalViewController.view.backgroundColor = .green
        stack(stack(newMatchesLabel).padLeft(20),horzientalViewController.view,stack(messageLabel).padLeft(20),spacing: 20).withMargins(.init(top: 20, left: 0, bottom: 20, right: 0))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
