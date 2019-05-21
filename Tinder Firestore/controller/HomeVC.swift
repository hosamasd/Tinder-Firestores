//
//  ViewController.swift
//  Tinder Firestore
//
//  Created by hosam on 5/21/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
//    var userArray = [
//        UserModel(name: "hosam", imageName: "screen", job: "student", age: 24),
//        UserModel(name: "zaki", imageName: "holiday", job: "techer", age: 28)
// ]
    var cardViewArray:[CardViewModel] = {
      let producer =    [
        Advertiser(title: "Slide out menu", brandName: "hosam mohamed", posterImageName: "slide_out_menu_poster"),
            UserModel(name: "hosam", imageName: "lady5c", job: "student", age: 24),
            UserModel(name: "zaki", imageName: "lady4c", job: "techer", age: 28),
            UserModel(name: "Kelly", imageName: "lady5c", job: "Music DJ", age: 23),
            UserModel(name: "Jane", imageName: "lady4c", job: "Teacher", age: 18),
            Advertiser(title: "Slide Out Menu", brandName: "Lets Build That App", posterImageName: "slide_out_menu_poster"),
            UserModel(name: "Jane", imageName: "lady4c", job: "Teacher", age: 18)
            
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
            cardView.card = cardVM
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

