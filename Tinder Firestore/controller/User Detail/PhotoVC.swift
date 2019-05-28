//
//  PhotoVC.swift
//  Tinder Firestore
//
//  Created by hosam on 5/28/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class PhotoVC: UIViewController {
    var imageView = UIImageView()
    
    init(image:String) {
        if let url = URL(string: image) {
            self.imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
}
