//
//  Advertiser.swift
//  Tinder Firestore
//
//  Created by hosam on 5/21/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

struct Advertiser: ProduceCardViewModel {
    let title:String
     let brandName:String
     let posterImageName:String
    
    func toCardViewModel() -> CardViewModel {
        let attributeText = NSMutableAttributedString( string: title , attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributeText.append(NSAttributedString(string: "\n\(brandName)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .bold)]))
        
        return  CardViewModel(imageName: posterImageName, attributedText: attributeText, textAlignment: .center)
        
    }
}
