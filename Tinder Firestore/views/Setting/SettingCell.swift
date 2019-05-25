//
//  SettingCell.swift
//  Tinder Firestore
//
//  Created by hosam on 5/23/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    
    let textEditable:CustomTextField = {
       let tx = CustomTextField(padding: 16, height: 40)
        
        return tx
    }()
    
   
   
    
   override func setupViews()  {
        backgroundColor = .white
        addSubview(textEditable)
        
        textEditable.fillSuperview()
    }
}
