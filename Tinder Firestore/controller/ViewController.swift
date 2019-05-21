//
//  ViewController.swift
//  Tinder Firestore
//
//  Created by hosam on 5/21/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let topStackView = topNavigationStackView()
    let bottomStackView = HomeBottomControlsStackView()
    let blueView:UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews()  {
        view.backgroundColor = .white
        
        let mainStack = UIStackView(arrangedSubviews: [topStackView,blueView,bottomStackView])
        mainStack.axis = .vertical
        
        view.addSubview(mainStack)
        mainStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
}

