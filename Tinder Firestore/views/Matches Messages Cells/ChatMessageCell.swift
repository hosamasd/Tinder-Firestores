//
//  ChatMessageCell.swift
//  Tinder Firestore
//
//  Created by hosam on 6/16/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import LBTATools

class ChatMessageCell: LBTAListCell<Message> {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    override var item: Message!{
        didSet{
            backgroundColor = .red
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
