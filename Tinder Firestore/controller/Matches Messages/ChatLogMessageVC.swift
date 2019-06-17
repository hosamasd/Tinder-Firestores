//
//  ChatLogMessageVC.swift
//  Tinder Firestore
//
//  Created by hosam on 6/16/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import LBTATools
import Firebase



class ChatLogMessageVC: LBTAListController<ChatMessageCell,MessageModel>, UICollectionViewDelegateFlowLayout {
    
   
    
    fileprivate let navBarHeight:CGFloat = 120
     lazy var customMessageNavBar = MessagesNavBar(match: match)
    fileprivate let match:MatchesModel
    
    init(match:MatchesModel) {
        self.match = match
        super.init()
    }
    
    lazy var commentView:CustominputAccessoryView = {
        let cv = CustominputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        cv.sendButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
      return cv
    }()
    
   
    var currentUser:UserModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customMessageNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        setupCollectionView()
        setupGestures()
        setupViews()
        fetchMessages()
        fetchCurrentUser()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    func fetchCurrentUser()  {
         guard let uids = Auth.auth().currentUser?.uid else { return  }
        Firestore.firestore().collection("Users").document(uids).getDocument { (snapshot, err) in
            if let err = err {
                print("failed to reterive messages ",err)
                return
            }
              let dict = snapshot?.data() ?? [:]
            self.currentUser = UserModel(dict: dict )
            
        }
       
    }
    
   
    //input accessory view
    
    override var inputAccessoryView: UIView!{
        get {
            return commentView
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //check that popped up from nav stack
        if isMovingFromParent {
            listener?.remove()
        }
    }
  
    //MARK:-collectionView methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedCellSize = ChatMessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 10000))
        estimatedCellSize.item = items[indexPath.item]
        estimatedCellSize.layoutIfNeeded()
        
        let estimatedHeight = estimatedCellSize.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        
        return .init(width: view.frame.width, height: estimatedHeight.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0 )
    }
    
    func setupGestures()  {
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard)))
    }
    
   
    
    func setupCollectionView()  {
        collectionView.keyboardDismissMode = .interactive
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset.top = navBarHeight
        collectionView.scrollIndicatorInsets.top = navBarHeight
        
    }
    
    func setupViews()  {
        
        
        view.addSubview(customMessageNavBar)
        customMessageNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(),size: .init(width: 0, height: navBarHeight))
        
        
        
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    var listener:ListenerRegistration?
    
    func fetchMessages()  {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return  }
        let query = Firestore.firestore().collection("Matches-Messages").document(currentUserUid).collection(match.uid).order(by: "timestamp")
        
      listener =  query.addSnapshotListener { (querySnap, err) in
            if let err = err {
                print("failed to reterive messages ",err)
                return
            }
            querySnap?.documentChanges.forEach({ (changes) in
                let dict = changes.document.data()
                self.items.append(.init(dict: dict))
            })
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0,self.items.count - 1], at: .bottom, animated: true)
        }
        
        
    }
    
  @objc  func handleDismissKeyboard()  {
        view.endEditing(true)
    }
    
 @objc   func handleBack()  {
        navigationController?.popViewController(animated: true)
    }

    @objc func handleKeyboardShow()  {
        collectionView.scrollToItem(at: [0,items.count - 1], at: .bottom, animated: true)
    }
    
@objc func handleSendMessage()  {
    let comment = commentView.textView.text ?? ""
    
    saveToFromMessages(comment: comment)
    saveToRecentMessages(comment: comment)
    }
   
    func saveToRecentMessages(comment:String)  {
        guard let uids = Auth.auth().currentUser?.uid else { return  }
        let data:[String:Any] = ["text":comment,"uid":match.uid,"imageProfileUrl":match.imageProfileUrl,"timestamp":Timestamp(date: Date()),"name":match.name]
        
        Firestore.firestore().collection("Matches-Messages").document(uids).collection("Recent-Messages").document(match.uid).setData(data) { (err) in
            if let err = err {
                print("failed to save", err)
                return
            }
            print("hosammmmmmm")
        }
        
        //save to other hand
         guard let currentUsers = self.currentUser else { return  }
         let toData:[String:Any] = ["text":comment,"uid":uids,"imageProfileUrl":currentUsers.imageUrl1 ?? "","timestamp":Timestamp(date: Date()),"name":currentUsers.name ?? ""]
        Firestore.firestore().collection("Matches-Messages").document(match.uid).collection("Recent-Messages").document(uids).setData(toData) 
    }
    
    func saveToFromMessages (comment:String)  {
    guard let currentUserUid = Auth.auth().currentUser?.uid else { return  }
    let collection = Firestore.firestore().collection("Matches-Messages").document(currentUserUid).collection(match.uid)
    let data:[String:Any] = ["text":comment,"fromId":currentUserUid,"toId":match.uid,"timestamp":Timestamp(date: Date())]
    
    collection.addDocument(data: data) { (err) in
    if let err = err {
    print("failed to save ",err)
    return
    }
    self.commentView.textView.text = nil
    self.commentView.placeHolderLabel.isHidden = false
    }
    
    let toCollection = Firestore.firestore().collection("Matches-Messages").document(match.uid).collection(currentUserUid)
    
    toCollection.addDocument(data: data) { (err) in
    if let err = err {
    print("failed to save ",err)
    return
    }
    self.commentView.textView.text = nil
    self.commentView.placeHolderLabel.isHidden = false
    
    }
    }
    
    deinit {
        print("no retain cycles here")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
