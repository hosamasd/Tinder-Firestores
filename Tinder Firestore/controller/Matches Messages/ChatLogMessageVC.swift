//
//  ChatLogMessageVC.swift
//  Tinder Firestore
//
//  Created by hosam on 6/16/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import LBTATools


class ChatLogMessageVC: LBTAListController<ChatMessageCell,MessageModel>, UICollectionViewDelegateFlowLayout {
    
    fileprivate let navBarHeight:CGFloat = 120
     lazy var customMessageNavBar = MessagesNavBar(match: match)
    fileprivate let match:MatchesModel
    
    init(match:MatchesModel) {
        self.match = match
        super.init()
    }
    
    
    
    lazy var commentView:UIView = {
      return CustominputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
    }()
    //input accessory view
    
    override var inputAccessoryView: UIView!{
        get {
            return commentView
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customMessageNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        setupCollectionView()
        setupViews()
       items = [
        .init(text:"dsfdsf dsfsdfsd fsdfsdfsdf dsgdfgfds dfgfdsgdfsg dfgfdsgdfsgdfsfgdsfgsaddfsadfasdfsdaacsddcsdaafcxzzvxc czbdfvxzc \ndfgdf dfgdfgdgvdsfdssadfasdfsadfsa", isFromCurrentUser: true),
        .init(text: "dfdsafdsafdsa", isFromCurrentUser: false),
        .init(text: "sdfsaadasDA", isFromCurrentUser: true),
        .init(text: "DSFDSFDSF DGDFGDFS DFGDFGDFGDF DFGDFGDFSGDASFGSDAFSDFDSF\n DFGNKLDNGKDJNGKJDNGK", isFromCurrentUser: false),
         .init(text:"dsfdsf dsfsdfsd fsdfsdfsdf dsgdfgfds dfgfdsgdfsg dfgfdsgdfsgdfsfgdsfgsaddfsadfasdfsdaacsddcsdaafcxzzvxc czbdfvxzc \ndfgdf dfgdfgdgvdsfdssadfasdfsadfsa", isFromCurrentUser: true),
        ]
        
        
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
    
 @objc   func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
