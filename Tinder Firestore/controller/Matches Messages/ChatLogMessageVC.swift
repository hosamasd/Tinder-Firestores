//
//  ChatLogMessageVC.swift
//  Tinder Firestore
//
//  Created by hosam on 6/16/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import LBTATools

struct Message {
    let name:String
}

class ChatLogMessageVC: LBTAListController<ChatMessageCell,Message>, UICollectionViewDelegateFlowLayout {
    
    fileprivate let navBarHeight:CGFloat = 120
     lazy var customMessageNavBar = MessagesNavBar(match: match)
    fileprivate let match:MatchesModel
    
    init(match:MatchesModel) {
        self.match = match
        super.init()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customMessageNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        setupViews()
        items = [
        .init(name: "hosam"),
        .init(name: "zaki"),
        .init(name: "ziead")
        
        ]
        
        
    }
    
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0 )
    }
    func setupViews()  {
        collectionView.backgroundColor = .white
        
        view.addSubview(customMessageNavBar)
        customMessageNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(),size: .init(width: 0, height: navBarHeight))
        
        collectionView.contentInset.top = navBarHeight
        
    }
    
 @objc   func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
