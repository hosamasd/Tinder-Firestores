//
//  MtachMessagesVC.swift
//  Tinder Firestore
//
//  Created by hosam on 6/15/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import LBTATools
import Firebase



class MtachMessagesVC: LBTAListController<MatchCell,MatchesModel>, UICollectionViewDelegateFlowLayout {
    
     fileprivate let navBarHeight:CGFloat = 150
     let customNavBar = MatchesNavBar()
   var matchesArray = [MatchesModel]()
    
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = items[indexPath.item]
        
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
        guard let uids = Auth.auth().currentUser?.uid else { return  }
        Firestore.firestore().collection("Matches-Messages").document(uids).collection("Matches").getDocuments { (querySnap, err) in
            if let err=err{
                print(err)
            }
            querySnap?.documents.forEach({ (snapshotDocument) in
                guard let dict =  snapshotDocument.data() as? [String:Any] else{return}
                let newMatches = MatchesModel(dict: dict)
                self.matchesArray.append(newMatches)
                self.items = self.matchesArray
                self.collectionView.reloadData()
            })
        }
    }
    
   @objc func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
}
