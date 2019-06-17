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
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customMessageNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        setupCollectionView()
        setupGestures()
        setupViews()
        fetchMessages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
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
    
    func fetchMessages()  {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return  }
        let query = Firestore.firestore().collection("Matches-Messages").document(currentUserUid).collection(match.uid).order(by: "timestamp")
        
        query.addSnapshotListener { (querySnap, err) in
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
    
    guard let currentUserUid = Auth.auth().currentUser?.uid else { return  }
    let collection = Firestore.firestore().collection("Matches-Messages").document(currentUserUid).collection(match.uid)
    let data:[String:Any] = ["text":comment,"fromId":currentUserUid,"toId":match.uid,"timestamp":Timestamp(date: Date())]
    
    collection.addDocument(data: data) { (err) in
        if let err = err {
            print("failed to save ",err)
            return
        }
        print("data saved")
        self.commentView.textView.text = nil
        self.commentView.placeHolderLabel.isHidden = false
    }
    
    let toCollection = Firestore.firestore().collection("Matches-Messages").document(match.uid).collection(currentUserUid)
    
    toCollection.addDocument(data: data) { (err) in
        if let err = err {
            print("failed to save ",err)
            return
        }
        
        print("data saved")
        self.commentView.textView.text = nil
        self.commentView.placeHolderLabel.isHidden = false
        
    }
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
