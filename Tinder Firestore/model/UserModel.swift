//
//  UserModel.swift
//  Tinder Firestore
//
//  Created by hosam on 5/21/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

struct UserModel: ProduceCardViewModel {
    var name:String?
    var job:String?
    var age:Int?
    var imageUrl1:String?
    var uid:String?
    
    init(dict: [String:Any]) {
        self.age = dict["age"] as? Int ?? 0
        self.job = dict["job"] as? String  ?? ""
        self.name = dict["fullName"] as? String ?? ""
         self.imageUrl1 = dict["imageUrl1"] as? String  ?? ""
  }
    
    func toCardViewModel() -> CardViewModel {
        let attributeText = NSMutableAttributedString( string: name ?? "" , attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 34, weight: .heavy)])
        let ageString = age != nil ? "\(age!)": "N\\A"
        attributeText.append(NSAttributedString(string: "    \(ageString)", attributes: [NSAttributedString.Key.font :  UIFont.systemFont(ofSize: 24, weight: .regular)]))
        let jobString = job != nil ? job! : "Not Avaiable"
        attributeText.append(NSAttributedString(string: " \n \(jobString)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))

      return  CardViewModel(imageNames: [imageUrl1 ?? ""], attributedText: attributeText, textAlignment: .left)

    }
}
