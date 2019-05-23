//
//  SettingCell.swift
//  Tinder Firestore
//
//  Created by hosam on 5/23/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    
    let textEditable:CustomTextField = {
       let tx = CustomTextField(padding: 16, height: 40)
        
        return tx
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        backgroundColor = .white
        addSubview(textEditable)
        
        textEditable.fillSuperview()
    }
}
