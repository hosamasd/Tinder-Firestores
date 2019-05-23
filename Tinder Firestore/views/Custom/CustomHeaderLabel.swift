//
//  HeaderLabel.swift
//  Tinder Firestore
//
//  Created by hosam on 5/23/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class CustomHeaderLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
}
