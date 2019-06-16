//
//  ChatMessageCell.swift
//  Tinder Firestore
//
//  Created by hosam on 6/16/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import LBTATools

class ChatMessageCell: LBTAListCell<MessageModel> {
    
    let textView:UITextView = {
       let tx = UITextView()
        tx.backgroundColor = .clear
        tx.font = UIFont.systemFont(ofSize: 20)
        tx.isEditable = false
        tx.isScrollEnabled = false
        return tx
    }()
    let bubbleContainer:UIView = {
       let vi = UIView(backgroundColor: .gray)
        vi.layer.cornerRadius = 12
        return vi
    }()
    var constainedAnchor:AnchoredConstraints!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func setupViews() {
        super.setupViews()
        addSubview(bubbleContainer)
        
         constainedAnchor = bubbleContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        constainedAnchor.leading?.constant = 20
        constainedAnchor.trailing?.constant = -20
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        constainedAnchor.leading?.isActive = false
        constainedAnchor.trailing?.isActive = true
        
        bubbleContainer.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
    }
    
    override var item: MessageModel!{
        didSet{
           
            textView.text = item.text
           
            
            if item.isFromCurrentUser {
                constainedAnchor.leading?.isActive = true
                constainedAnchor.trailing?.isActive = false
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.7098039216, blue: 0.7098039216, alpha: 1)
                textView.textColor = .black
            }else {
                constainedAnchor.leading?.isActive = false
                constainedAnchor.trailing?.isActive = true
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.7294117647, blue: 1, alpha: 1)
                textView.textColor = .white
            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
