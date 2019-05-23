//
//  ViewController.swift
//  Tinder Firestore
//
//  Created by hosam on 5/21/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeVC: UIViewController {
 
//    var cardViewArray:[CardViewModel] = {
//      let producer =    [
//        UserModel(name: "kelly", imageNames: ["kelly1","kelly2","kelly3"], job: "student", age: 24),
//        Advertiser(title: "Slide out menu", brandName: "hosam mohamed", posterImageName: "slide_out_menu_poster"),
//
//            UserModel(name: "jane", imageNames: ["jane1","jane2","jane3"], job: "Music DJ", age: 23),
//
//
//        ] as [ProduceCardViewModel]
//       let viewModels = producer.map({return $0.toCardViewModel()})
//        return viewModels
//    }()
   
    var cardViewModelArray = [CardViewModel]()
    
    let topStackView = topNavigationStackView()
    let bottomStackView = HomeBottomControlsStackView()
    let cardDeskView:UIView = {
        let v = UIView()
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingButton.addTarget(self, action: #selector(handleNextVC), for: .touchUpInside)
        
        setupViews()
        setupFirestoreUserCards()
        
        fetchUsersFromFirestore()
    }
    
    func fetchUsersFromFirestore()  {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        let query =  Firestore.firestore().collection("Users")
            
        query.getDocuments { (snapshot, err) in
            hud.dismiss()
            if let err = err {
                print(err)
                return
            }
            
            snapshot?.documents.forEach({ (query) in
                let userDict  = query.data()
               let user = UserModel(dict: userDict)
                self.cardViewModelArray.append(user.toCardViewModel())
            })
            
            self.setupFirestoreUserCards()
        }
    }
    
    func setupFirestoreUserCards()  {
       cardViewModelArray.forEach { (cardVM) in
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
    
   @objc func handleNextVC()  {
        let setting = SettingVC()
        present(UINavigationController(rootViewController: setting), animated: true, completion: nil)
    }
}

