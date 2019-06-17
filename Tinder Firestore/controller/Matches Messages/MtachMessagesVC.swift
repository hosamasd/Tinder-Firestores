//
//  MtachMessagesVC.swift
//  Tinder Firestore
//
//  Created by hosam on 6/15/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import LBTATools
import Firebase

class HorizentalMatchMessageVC: LBTAListController<MatchCell,MatchesModel>,UICollectionViewDelegateFlowLayout {
    
    var rootViewController:MtachMessagesVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        fetchMatches()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 110, height: view.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 4, bottom: 0, right: 16)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = self.items[indexPath.item]
        rootViewController?.didSelectMatchFromHeader(match: match)
    }
    
    func fetchMatches()  {
        var matchesArray = [MatchesModel]()
        guard let uids = Auth.auth().currentUser?.uid else { return  }
        Firestore.firestore().collection("Matches-Messages").document(uids).collection("Matches").getDocuments { (querySnap, err) in
            if let err=err{
                print(err)
            }
            querySnap?.documents.forEach({ (snapshotDocument) in
                guard let dict =  snapshotDocument.data() as? [String:Any] else{return}
                let newMatches = MatchesModel(dict: dict)
                matchesArray.append(newMatches)
                self.items = matchesArray
                self.collectionView.reloadData()
            })
        }
    }
}

class MatchHeaderCell: UICollectionReusableView {
    let newMatchesLabel = UILabel(text: "New Matches", font: .boldSystemFont(ofSize: 20), textColor: #colorLiteral(red: 1, green: 0.4, blue: 0.4274509804, alpha: 1))
    let horzientalViewController = HorizentalMatchMessageVC()
    
    let messageLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 20), textColor: #colorLiteral(red: 1, green: 0.4, blue: 0.4274509804, alpha: 1))

    override init(frame: CGRect) {
        super.init(frame: frame)
       
        horzientalViewController.view.backgroundColor = .green
        stack(stack(newMatchesLabel).padLeft(20),horzientalViewController.view,stack(messageLabel).padLeft(20),spacing: 20).withMargins(.init(top: 20, left: 0, bottom: 20, right: 0))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MtachMessagesVC: LBTAListHeaderController<MatchCell,MatchesModel,MatchHeaderCell>, UICollectionViewDelegateFlowLayout {
    
     fileprivate let navBarHeight:CGFloat = 150
     let customNavBar = MatchesNavBar()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
       setupViews()
        fetchMatches()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = items[indexPath.item]
        
        let chatLog = ChatLogMessageVC(match: match)
        navigationController?.pushViewController(chatLog, animated: true)
        
    }
    
    override func setupHeader(_ header: MatchHeaderCell) {
        header.horzientalViewController.rootViewController = self
    }
    
    func didSelectMatchFromHeader(match:MatchesModel) {
        let chatLog = ChatLogMessageVC(match: match)
        navigationController?.pushViewController(chatLog, animated: true)
    }
    
    func setupViews()  {
        collectionView.backgroundColor = .white
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(),size: .init(width: 0, height: navBarHeight))
        
        collectionView.contentInset.top = navBarHeight
        
    }
   
    
    func fetchMatches()  {
        var matchesArray = [MatchesModel]()
        guard let uids = Auth.auth().currentUser?.uid else { return  }
        Firestore.firestore().collection("Matches-Messages").document(uids).collection("Matches").getDocuments { (querySnap, err) in
            if let err=err{
                print(err)
            }
            querySnap?.documents.forEach({ (snapshotDocument) in
                guard let dict =  snapshotDocument.data() as? [String:Any] else{return}
                let newMatches = MatchesModel(dict: dict)
                matchesArray.append(newMatches)
                self.items = matchesArray
                self.collectionView.reloadData()
            })
        }
    }
    
   @objc func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
}
