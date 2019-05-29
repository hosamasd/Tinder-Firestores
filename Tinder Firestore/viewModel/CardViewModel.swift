//
//  CardViewModel.swift
//  Tinder Firestore
//
//  Created by hosam on 5/21/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

protocol ProduceCardViewModel {
     func toCardViewModel() -> CardViewModel
}

class CardViewModel {

    // we will design MVVM design pattern
    let uid:String
    
    let imageNames:[String]
    let attributedText:NSAttributedString
    let textAlignment:NSTextAlignment
    
    init(uid:String,imageNames:[String],attributedText:NSAttributedString,textAlignment:NSTextAlignment) {
        self.textAlignment = textAlignment
        self.attributedText = attributedText
        self.imageNames = imageNames
        self.uid = uid
    }
    
    fileprivate var imageIndex = 0 {
        didSet{
            let imageUrl = imageNames[imageIndex]
            imageIndexObserver?(imageIndex,  imageUrl)
    }
    }
    
    //reactive programming
    var imageIndexObserver: ((Int,String?)->())?
    
    func goToNextPhoto()  {
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    
    func goToPreviousPhoto()  {
        imageIndex = max(0, imageIndex - 1)
    }
    
}
