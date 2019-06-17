//
//  MtachMessagesVC.swift
//  Tinder Firestore
//
//  Created by hosam on 6/15/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import LBTATools
import Firebase


class MtachHeaderMessagesVC: LBTAListHeaderController<RecentMessageCell,RecentMessageModel,MatchHeaderCell>, UICollectionViewDelegateFlowLayout {
    
    fileprivate let navBarHeight:CGFloat = 150
    let customNavBar = MatchesNavBar()
    var recentdDictionaryMessages = [String:RecentMessageModel]()
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        setupViews()
        setupCollectionView()
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        fetchRecentMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }
    
    override func setupHeader(_ header: MatchHeaderCell) {
        header.horzientalViewController.rootViewController = self
    }
    
    //MARK:-collectionView methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let recentMess = self.items[indexPath.item]
        let dict = ["name":recentMess.name,"imageProfileUrl":recentMess.imageProfileUrl,"uid":recentMess.uid]
        let match = MatchesModel(dict: dict)
        let chatLog = ChatLogMessageVC(match: match)
        navigationController?.pushViewController(chatLog, animated: true)
        
    }
    
   //MARK:-user methods
    
     func didSelectMatchFromHeader(match:MatchesModel) {
        let chatLog = ChatLogMessageVC(match: match)
        navigationController?.pushViewController(chatLog, animated: true)
    }
    
    fileprivate   func setupViews()  {
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(),size: .init(width: 0, height: navBarHeight))
        
        collectionView.contentInset.top = navBarHeight
        
    }
    
    fileprivate  func setupCollectionView()  {
        collectionView.backgroundColor = .white
        collectionView.scrollIndicatorInsets.top = 150
        collectionView.contentInset.top = 150
    }
    
    
    fileprivate func fetchRecentMessages()  {
        
        guard let uids = Auth.auth().currentUser?.uid else { return  }
        let collection = Firestore.firestore().collection("Matches-Messages").document(uids).collection("Recent-Messages")
        listener =   collection.addSnapshotListener { (queryListen, err) in
            if let err=err{
                print(err)
            }
            queryListen?.documentChanges.forEach({ (changes) in
                if changes.type == .added || changes.type == .modified{
                    let dict = changes.document.data()
                    let recentMessage = RecentMessageModel(dict: dict)
                    
                    self.recentdDictionaryMessages[recentMessage.uid] = recentMessage
                }
            })
            self.refreshData()
        }
    }
    
    fileprivate  func refreshData()  {
        let values = Array(recentdDictionaryMessages.values)
        items = values.sorted(by: { (rm1, rm2) -> Bool in
            return rm1.timestamp.compare(rm2.timestamp) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    @objc fileprivate func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("no retain cycles here")
    }
    
}
