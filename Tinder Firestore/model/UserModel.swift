//
//  UserModel.swift
//  Tinder Firestore
//
//  Created by hosam on 5/21/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

struct UserModel {
    let name:String
    let imageName:String
    let job:String
    let age:Int
    
    func toCardViewModel() -> CardViewModel {
        let attributeText = NSMutableAttributedString( string: name , attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributeText.append(NSAttributedString(string: "    \(age)", attributes: [NSAttributedString.Key.font :  UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributeText.append(NSAttributedString(string: " \n \(job)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))

      return  CardViewModel(imageName: imageName, attributedText: attributeText, textAlignment: .left)

    }
}
