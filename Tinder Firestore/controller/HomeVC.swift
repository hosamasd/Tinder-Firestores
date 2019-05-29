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
 
   
    var cardViewModelArray = [CardViewModel]()
     fileprivate let hud = JGProgressHUD(style: .dark)
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
        bottomStackView.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomStackView.dislikeButton.addTarget(self, action: #selector(handleDisLike), for: .touchUpInside)
        setupViews()
//        setupFirestoreUserCards()
//         fetchUsersFromFirestore()
         fetchCurrentUser()
    }
    
    var topCarddView:CardView?
    
   
    
    func setupTopCardView()  {
        self.topCarddView?.removeFromSuperview()
        self.topCarddView = self.topCarddView!.nextCardView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if  Auth.auth().currentUser ==  nil {
            let reg = RegisterVC()
            reg.delgate = self
            let nav = UINavigationController(rootViewController: reg)
            present(nav, animated: true, completion: nil)

        }
    }
   
    //MARK:-user methods
    
    func fetchCurrentUser()  {
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        guard let uid = Auth.auth().currentUser?.uid else { return  }
        Firestore.firestore().collection("Users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                 self.hud.dismiss()
                return
            }
            guard let dict = snapshot?.data() else {return}
            self.user = UserModel(dict: dict)
           self.fetchUsersFromFirestore()
        }
    }
    
    func fetchUsersFromFirestore()  {
//        guard let minAge = self.user?.minSeekingAge,let maxAge=user?.maxSeekingAge else {
//            self.hud.dismiss()
//            return }
        
        let minAge = self.user?.minSeekingAge ?? SettingVC.defaultMinAgeSeeking
        let maxAge=self.user?.maxSeekingAge ?? SettingVC.defaultMaxAgeSeeking
//        let hud = JGProgressHUD(style: .dark)
//        hud.textLabel.text = "Fetching Users"
//        hud.show(in: view)
        
        //paginate here for limit users apppear
        
        let query =  Firestore.firestore().collection("Users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
            topCarddView = nil
        query.getDocuments { (snapshot, err) in
            self.hud.dismiss()
            if let err = err {
                print(err)
                return
            }
            var previousCardView:CardView?
            
            snapshot?.documents.forEach({ (query) in
                let userDict  = query.data()
               let user = UserModel(dict: userDict)
                self.cardViewModelArray.append(user.toCardViewModel())
                self.lastFetchUser = user
             let cardView =  self.fetchUserCards(user: user)
                
                //linked list as each node contain itis data and linked to other node
                
                previousCardView?.nextCardView = cardView
                previousCardView = cardView
                if self.topCarddView == nil {
                    self.topCarddView = cardView
                }
           })
            
//            self.setupFirestoreUserCards()
        }
    }
    
    func fetchUserCards(user:UserModel) ->CardView  {
        let cardView = CardView(frame: .zero)
        cardView.delgate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardDeskView.addSubview(cardView)
        cardDeskView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
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
    
   @objc func handleDisLike()  {
//        swipeCardsAnimation(angle: -15, translation: -700)
    let duration = 0.5
    
    let translation = CABasicAnimation(keyPath: "position.x")
    translation.duration = duration
    translation.toValue = -700
    translation.timingFunction = CAMediaTimingFunction(name: .easeOut)
    translation.isRemovedOnCompletion = false //for removing from view
    translation.fillMode = .forwards //for removing from view
    
    let transform = CABasicAnimation(keyPath: "transform.rotation.z")
    transform.toValue = -15 * CGFloat.pi / 180
    transform.duration = duration
    
    let card = topCarddView
    topCarddView = card?.nextCardView
    
    CATransaction.setCompletionBlock {
        card?.removeFromSuperview()
    }
    
    
    card?.layer.add(translation, forKey: "traslation")
    card?.layer.add(transform, forKey: "transform")
    CATransaction.commit()
    }
    
    fileprivate func swipeCardsAnimation(angle:CGFloat,translation:CGFloat) {
        let duration = 0.5
        
        let translation = CABasicAnimation(keyPath: "position.x")
        translation.duration = duration
        translation.toValue = translation
        translation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translation.isRemovedOnCompletion = false //for removing from view
        translation.fillMode = .forwards //for removing from view
        
        let transform = CABasicAnimation(keyPath: "transform.rotation.z")
        transform.toValue = angle * CGFloat.pi / 180
        transform.duration = duration
        
        let card = topCarddView
        topCarddView = card?.nextCardView
        
        CATransaction.setCompletionBlock {
            card?.removeFromSuperview()
        }
        
        
        card?.layer.add(translation, forKey: "traslation")
        card?.layer.add(transform, forKey: "transform")
        CATransaction.commit()
    }
    
    @objc func handleLike(){
//        swipeCardsAnimation(angle: 15, translation: 700)
        let duration = 0.5
        
        let translation = CABasicAnimation(keyPath: "position.x")
        translation.duration = duration
        translation.toValue = 700
        translation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translation.isRemovedOnCompletion = false //for removing from view
        translation.fillMode = .forwards //for removing from view
        
        let transform = CABasicAnimation(keyPath: "transform.rotation.z")
        transform.toValue = 15 * CGFloat.pi / 180
        transform.duration = duration
        
        let card = topCarddView
        topCarddView = card?.nextCardView
        
        CATransaction.setCompletionBlock {
            card?.removeFromSuperview()
        }
        
        
        card?.layer.add(translation, forKey: "traslation")
        card?.layer.add(transform, forKey: "transform")
        CATransaction.commit()
    }
}

extension HomeVC: SettingVCDelgate ,LoginVCDelgate, CardViewDelegate{
    func didRemoveCard(card: CardView) {
        self.setupTopCardView()
    }
    
    
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
