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
    
    var topCarddView:CardView?
    var swipes = [String:Any]()
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
     var users  = [String:UserModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        setupGestures()
        setupViews()
        fetchCurrentUser()
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
    
    fileprivate  func fetchCurrentUser()  {
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        guard let uid = Auth.auth().currentUser?.uid else { return  }
        Firestore.firestore().collection("Users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(123)
                self.hud.dismiss()
                return
            }
            guard let dict = snapshot?.data() else {return}
            self.user = UserModel(dict: dict)
            self.fetchSwipes()
            
        }
    }
    
    fileprivate func setupGestures() {
        topStackView.settingButton.addTarget(self, action: #selector(handleNextVC), for: .touchUpInside)
        topStackView.messageButton.addTarget(self, action: #selector(handleMessages), for: .touchUpInside)
        bottomStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomStackView.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomStackView.dislikeButton.addTarget(self, action: #selector(handleDisLike), for: .touchUpInside)
    }
    
 
    
    fileprivate func setupTopCardView()  {
        self.topCarddView?.removeFromSuperview()
        self.topCarddView = self.topCarddView!.nextCardView
    }
    
    fileprivate  func fetchSwipes()  {
        guard let uidds = Auth.auth().currentUser?.uid else{return}
        guard let currentUid = self.user?.uid else { return  }
        Firestore.firestore().collection("Swipes").document(uidds).getDocument { (snapshot, err) in
            if err != nil {
                print(err)
                return
            }
            self.fetchUsersFromFirestore()
        }
        
    }
    
    fileprivate func fetchUsersFromFirestore()  {
        
        let minAge = self.user?.minSeekingAge ?? SettingVC.defaultMinAgeSeeking
        let maxAge=self.user?.maxSeekingAge ?? SettingVC.defaultMaxAgeSeeking
        
        //paginate here for limit users apppear
        
        let query =  Firestore.firestore().collection("Users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge).limit(to: 10)
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
                
                self.users[user.uid ?? ""] = user
                let isNotCurrentUser = user.uid! != Auth.auth().currentUser?.uid
                //                let hasNotSwipedBefore = self.swipes[user.uid!] == nil
                let hasNotSwipedBefore = true
                if isNotCurrentUser && hasNotSwipedBefore {
                    let cardView =  self.fetchUserCards(user: user)
                    //linked list as each node contain itis data and linked to other node
                    
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    if self.topCarddView == nil {
                        self.topCarddView = cardView
                    }
                }
             })
        }
    }
    
    fileprivate func fetchUserCards(user:UserModel) ->CardView  {
        let cardView = CardView(frame: .zero)
        cardView.delgate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardDeskView.addSubview(cardView)
        cardDeskView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    fileprivate func setupFirestoreUserCards()  {
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
    
   fileprivate func saveSwipeToFirestore( value:Int)  {
        
        guard let uid = Auth.auth().currentUser?.uid else { return  }
        guard let cardUID = topCarddView?.cardViewModel.uid else { return  }
        let data = [cardUID:value]
        
        Firestore.firestore().collection("Swipes").document(uid).getDocument { (snapshot, err) in
            if err != nil {
                print(err)
                return
            }
            
            if snapshot?.exists == true{
                Firestore.firestore().collection("Swipes").document(uid).updateData(data) { (err) in
                    if err != nil {
                        print(err)
                        return
                    }
                    
                    if value == 1 {
                        self.checkIfMatchesSwiping(uid: cardUID)
                    }
                }
            }else {
                Firestore.firestore().collection("Swipes").document(uid).setData(data) { (err) in
                    if err != nil {
                        print(err)
                        return
                    }
                    if value == 1 {
                        self.checkIfMatchesSwiping(uid: cardUID)
                    }
                }
            }
        }
   }
    
  fileprivate  func checkIfMatchesSwiping(uid:String)  {
        guard let uidds = Auth.auth().currentUser?.uid else{return}
        Firestore.firestore().collection("Swipes").document(uidds).getDocument { (snapshot, err) in
            if err != nil {
                print(err)
                return
            }
            guard let data = snapshot?.data() else {return}
            let hasMatched = data[uid] as? Int == 1
            
            if hasMatched {
                self.presentMatchView(uid:uid)
                guard let cardUser = self.users[uid] else {return}
                let data = ["name":cardUser.name ?? "","uid":uid,"imageProfileUrl":cardUser.imageUrl1 ?? "","timestamp":Timestamp(date: Date())] as [String : Any]
                
                Firestore.firestore().collection("Matches-Messages").document(uidds).collection("Matches").document(uid).setData(data, completion: { (err) in
                    if let err = err {
                        print("failed to save ",err)
                    }
                })
                
                //same for current user
                guard let currentUser = self.user else {return}
                let otherData = ["name":currentUser.name ?? "","uid":currentUser.uid ?? "","imageProfileUrl":currentUser.imageUrl1 ?? "","timestamp":Timestamp(date: Date())] as [String : Any]
                
                Firestore.firestore().collection("Matches-Messages").document(uid).collection("Matches").document(uidds).setData(otherData, completion: { (err) in
                    if let err = err {
                        print("failed to save ",err)
                    }
                })
            }
        }
    }
    
   fileprivate func presentMatchView(uid:String)  {
        let matchView = MatchView()
        matchView.cardID = uid
        matchView.currentUser = self.user
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    
    
    //TODO:-handle methods
    
    @objc fileprivate func handleMessages()  {
        let newMewss = MtachHeaderMessagesVC()
        navigationController?.pushViewController(newMewss, animated: true)
        
    }
    
    @objc  fileprivate func handleRefresh()  {
        cardDeskView.subviews.forEach({$0.removeFromSuperview()})
        fetchUsersFromFirestore()
    }
    
    @objc fileprivate func handleNextVC()  {
        let setting = SettingVC()
        setting.delgate = self
        let nav =   UINavigationController(rootViewController: setting)
        
        present(nav, animated: true, completion: nil)
    }
    
    @objc  func handleDisLike()  {
        
        saveSwipeToFirestore(value: 0)
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
    @objc  func handleLike(){
        saveSwipeToFirestore(value: 1)
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
