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
struct CardViewModel {

    // we will design MVVM design pattern
    let imageNames:[String]
    let attributedText:NSAttributedString
    let textAlignment:NSTextAlignment
    
}
