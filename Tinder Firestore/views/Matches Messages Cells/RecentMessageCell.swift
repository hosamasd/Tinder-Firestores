//
//  RecentMessageCell.swift
//  Tinder Firestore
//
//  Created by hosam on 6/17/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import LBTATools

class RecentMessageCell: LBTAListCell<RecentMessageModel> {
    let profileImageView = CircularImageView(width: 94, image: #imageLiteral(resourceName: "lady4c"))
    let usernameLabel = UILabel(text: "username here", font: .boldSystemFont(ofSize: 18), textColor: .black)
     let textLabel = UILabel(text: "our text \n here", font: .systemFont(ofSize: 14, weight: .semibold), textColor: .lightGray,numberOfLines: 2)
    
    override var item: RecentMessageModel!{
        didSet {
            profileImageView.sd_setImage(with: URL(string: item.imageProfileUrl))
            usernameLabel.text = item.name
            textLabel.text = item.text
        }
    }
    override func setupViews() {
        super.setupViews()
        hstack(profileImageView,stack(usernameLabel,textLabel,spacing: 4).padTop(-20),spacing: 8,alignment: .center).padLeft(16)
        
        addSeparatorView(leadingAnchor: usernameLabel.leadingAnchor)
    }
}
