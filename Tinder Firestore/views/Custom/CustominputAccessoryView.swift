//
//  CustominputAccessoryView.swift
//  Tinder Firestore
//
//  Created by hosam on 6/16/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class CustominputAccessoryView: UIView {
    let textView:UITextView = {
        let tx = UITextView()
        
        tx.isScrollEnabled = false
        tx.font = UIFont.systemFont(ofSize: 16)
        return tx
    }()
    let placeHolderLabel = UILabel(text: "Enter Message", font: .systemFont(ofSize: 16), textColor: .lightGray)
    
    let sendButton = UIButton(title: "Send", titleColor: .black, font: .boldSystemFont(ofSize: 14), target: nil, action: nil)
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -12), color: .lightGray)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChanged), name: UITextView.textDidChangeNotification, object: nil)
        
        
        
        hstack(textView,sendButton.withSize(.init(width: 60, height: 60)),alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: sendButton.leadingAnchor,padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        placeHolderLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
    }
    
    @objc  func handleTextChanged()  {
        placeHolderLabel.isHidden = textView.text.count != 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self) //for avoiding retain cycle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
