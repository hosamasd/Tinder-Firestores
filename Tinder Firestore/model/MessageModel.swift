//
//  MessageModel.swift
//  Tinder Firestore
//
//  Created by hosam on 6/16/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import Firebase

struct MessageModel {
    let text,fromId,toId:String
    let timestamp:Timestamp
    let isFromCurrentUser:Bool
    
    init(dict: [String:Any]) {
        self.text = dict["text"] as? String ?? ""
        self.fromId = dict["fromId"] as? String ?? ""
        self.toId = dict["toId"] as? String ?? ""
         self.timestamp = dict["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isFromCurrentUser = Auth.auth().currentUser?.uid == fromId
    }
}
