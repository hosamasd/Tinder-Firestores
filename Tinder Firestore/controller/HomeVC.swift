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
     var user:UserModel?
     var lastFetchUser:UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingButton.addTarget(self, action: #selector(handleNextVC), for: .touchUpInside)
        bottomStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        setupViews()
//        setupFirestoreUserCards()
//         fetchUsersFromFirestore()
         fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if  Auth.auth().currentUser?.uid ==  nil {
            let login = LoginVC()
            login.delgate = self
            let nav = UINavigationController(rootViewController: login)
            present(nav, animated: true, completion: nil)
            
        }
    }
   
    //MARK:-user methods
    
    func fetchCurrentUser()  {
        guard let uid = Auth.auth().currentUser?.uid else { return  }
        Firestore.firestore().collection("Users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            guard let dict = snapshot?.data() else {return}
            self.user = UserModel(dict: dict)
           self.fetchUsersFromFirestore()
        }
    }
    
    func fetchUsersFromFirestore()  {
        guard let minAge = self.user?.minSeekingAge,let maxAge=user?.maxSeekingAge else { return }
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        
        //paginate here for limit users apppear
        
        let query =  Firestore.firestore().collection("Users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
            
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
                self.lastFetchUser = user
                self.fetchUserCards(user: user)
           })
            
//            self.setupFirestoreUserCards()
        }
    }
    
    func fetchUserCards(user:UserModel)  {
        let cardView = CardView(frame: .zero)
        cardView.delgate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardDeskView.addSubview(cardView)
        cardDeskView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    func setupFirestoreUserCards()  {
       cardViewModelArray.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardDeskView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
  fileprivate  func setupViews()  {
       
        view.backgroundColor = .white
        
        let mainStack = UIStackView(arrangedSubviews: [topStackView,cardDeskView,bottomStackView])
    
        mainStack.bringSubviewToFront(cardDeskView) // to make it hide the other
        mainStack.axis = .vertical
        
        view.addSubview(mainStack)
       mainStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
    }
    
    //TODO:-handle methods
    
 @objc   func handleRefresh()  {
       fetchUsersFromFirestore()
    }
    
   @objc func handleNextVC()  {
        let setting = SettingVC()
    setting.delgate = self
        present(UINavigationController(rootViewController: setting), animated: true, completion: nil)
    }
}

extension HomeVC: SettingVCDelgate ,LoginVCDelgate, CardViewDelegate{
    
    func performFetchData() {
        fetchCurrentUser()
    }
    
    func didTapMoreInfo(card:CardViewModel) {
        print("Home controller going to show user details now")
        let userDetailsController = UserDetailVC()
        userDetailsController.cardView = card
        present(userDetailsController, animated: true)
    }
    
    func didSaveChange() {
        fetchCurrentUser()
    }
    
    
}
