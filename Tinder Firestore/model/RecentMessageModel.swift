//
//  RecentMessageModel.swift
//  Tinder Firestore
//
//  Created by hosam on 6/17/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import Firebase

struct RecentMessageModel {
    let text,name,imageProfileUrl,uid:String
    let timestamp:Timestamp
    init(dict: [String:Any]) {
        self.uid = dict["uid"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
         self.text = dict["text"] as? String ?? ""
        self.imageProfileUrl = dict["imageProfileUrl"] as? String ?? ""
        self.timestamp = dict["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
