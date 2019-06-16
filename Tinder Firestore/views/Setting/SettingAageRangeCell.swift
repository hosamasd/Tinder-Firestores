//
//  SettingAageRangeCell.swift
//  Tinder Firestore
//
//  Created by hosam on 5/25/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class SettingAageRangeCell: BaseCell {
    
    var users:UserModel? {
        didSet{
            
        let minAge = users?.minSeekingAge ?? SettingVC.defaultMinAgeSeeking
        let maxAge  = users?.maxSeekingAge ?? SettingVC.defaultMaxAgeSeeking
        
            minAgeLabel.text = "Min: \(minAge)"
            maxAgeLabel.text = "Max: \(maxAge)"
            minSlider.value = Float(minAge)
            maxSlider.value = Float(maxAge)
    }
    }
    
    let minAgeLabel:UILabel = {
        let la = UILabel()
        
        la.text = "Min: 20"
        la.constrainWidth(100)
        return la
    }()
    let minSlider:UISlider = {
        let sl = UISlider()
        sl.minimumValue = 20
        sl.maximumValue = 100
        
        return sl
    }()
    let maxSlider:UISlider = {
        let sl = UISlider()
        sl.minimumValue = 20
        sl.maximumValue = 100
        
        return sl
    }()
    let maxAgeLabel:UILabel = {
        let la = UILabel()
        la.constrainWidth(100)
        la.text = "Max: 20"
        return la
    }()
    
    override func setupViews() {
        backgroundColor = .white
        let minStack = UIStackView(arrangedSubviews: [minAgeLabel,minSlider])
        minStack.axis = .horizontal
        minStack.spacing = 5
        
        let maxStack = UIStackView(arrangedSubviews: [maxAgeLabel,maxSlider])
        minStack.axis = .horizontal
        minStack.spacing = 5
        
        let mainStack = UIStackView(arrangedSubviews: [minStack,maxStack])
        mainStack.axis = .vertical
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
}
