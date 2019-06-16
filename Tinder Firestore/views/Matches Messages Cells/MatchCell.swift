//
//  MatchCell.swift
//  Tinder Firestore
//
//  Created by hosam on 6/15/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import LBTATools

class MatchCell: LBTAListCell<MatchesModel> {
    let profileImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "kelly1"), contentMode: .scaleAspectFill)
        im.constrainHeight(80)
        im.constrainWidth(80)
        im.layer.cornerRadius = 80 / 2
        return im
    }()
    let usernameLabel = UILabel(text: "username here", font: .systemFont(ofSize: 14, weight: .semibold), textColor: .black, textAlignment: .center, numberOfLines: 2)
    
    
    override var item: MatchesModel!{
        didSet{
            usernameLabel.text = item.name
            profileImageView.sd_setImage(with: URL(string: item.imageProfileUrl))
        }
    }
    
    override func setupViews() {
        stack(stack(profileImageView,alignment: .center).padTop(8),usernameLabel)
    }
}

