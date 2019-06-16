//
//  MatchesModel.swift
//  Tinder Firestore
//
//  Created by hosam on 6/15/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

struct MatchesModel {
    let name,imageProfileUrl,uid:String
    
    init(dict: [String:Any]) {
        self.uid = dict["uid"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.imageProfileUrl = dict["imageProfileUrl"] as? String ?? ""
    }
}
