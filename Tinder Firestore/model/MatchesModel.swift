//
//  MatchesModel.swift
//  Tinder Firestore
//
//  Created by hosam on 6/15/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

struct MatchesModel {
    let name,imageProfileUrl:String 
    
    init(dict: [String:Any]) {
        self.name = dict["name"] as? String ?? ""
        self.imageProfileUrl = dict["imageProfileUrl"] as? String ?? ""
    }
}
