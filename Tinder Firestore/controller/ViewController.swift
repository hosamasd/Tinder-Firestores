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
    let cardDeskView:UIView = {
        let v = UIView()
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDumyCard()
    }
    
    func setupDumyCard()  {
        let cardView = CardView(frame: .zero)
        cardDeskView.addSubview(cardView)
        cardView.fillSuperview()
    }
    func setupViews()  {
        view.backgroundColor = .white
        
        let mainStack = UIStackView(arrangedSubviews: [topStackView,cardDeskView,bottomStackView])
        mainStack.bringSubviewToFront(cardDeskView) // to make it hide the other
        mainStack.axis = .vertical
        
        view.addSubview(mainStack)
        mainStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
}

