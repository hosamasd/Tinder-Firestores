//
//  ViewController.swift
//  Tinder Firestore
//
//  Created by hosam on 5/21/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
 
    var cardViewArray:[CardViewModel] = {
      let producer =    [
        UserModel(name: "kelly", imageNames: ["kelly1","kelly2","kelly3"], job: "student", age: 24),
        Advertiser(title: "Slide out menu", brandName: "hosam mohamed", posterImageName: "slide_out_menu_poster"),
        
            UserModel(name: "jane", imageNames: ["jane1","jane2","jane3"], job: "Music DJ", age: 23),
        
            
        ] as [ProduceCardViewModel]
       let viewModels = producer.map({return $0.toCardViewModel()})
        return viewModels
    }()
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
        cardViewArray.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardDeskView.addSubview(cardView)
            cardView.fillSuperview()
        }
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

