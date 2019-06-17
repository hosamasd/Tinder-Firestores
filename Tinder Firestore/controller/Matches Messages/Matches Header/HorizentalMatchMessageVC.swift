//
//  HorizentalMatchMessageVC.swift
//  Tinder Firestore
//
//  Created by hosam on 6/17/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import LBTATools
import Firebase

class HorizentalMatchMessageVC: LBTAListController<MatchCell,MatchesModel>,UICollectionViewDelegateFlowLayout {
    
    weak var rootViewController:MtachHeaderMessagesVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        fetchMatches()
    }
    
    //MARK:-collectionView methods
    
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
    
    //MARK:-user methods
    
   fileprivate func fetchMatches()  {
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

