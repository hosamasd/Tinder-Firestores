//
//  UserDdetailVC.swift
//  Tinder Firestore
//
//  Created by hosam on 5/27/19.
//  Copyright © 2019 hosam. All rights reserved.
//
import UIKit

class UserDetailVC: UIViewController {
    
    lazy var scrollView:UIScrollView = {
       let sv = UIScrollView()
        sv.delegate = self
sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        return sv
    }()
    let imageView:UIImageView = {
       let im = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
       im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        
        return im
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "User name 30\nDoctor\nSome bio text down below"
        label.numberOfLines = 0
        return label
    }()
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        return button
    }()
    
    // 3 bottom control buttons
    
    lazy var dislikeButton = self.createButton(image: #imageLiteral(resourceName: "dismiss_circle"), selector: #selector(handleDislike))
    lazy var superLikeButton = self.createButton(image: #imageLiteral(resourceName: "super_like_circle"), selector: #selector(handleDislike))
    lazy var likeButton = self.createButton(image: #imageLiteral(resourceName: "like_circle"), selector: #selector(handleDislike))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViews()
        setupVisualBlurEffectView()
        setupBottomControls()
    }
    
    
  fileprivate  func setupViews()  {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        
        scrollView.fillSuperview()
        scrollView.addSubview(imageView)
        scrollView.addSubview(infoLabel)
    scrollView.addSubview(dismissButton)
    
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        infoLabel.anchor(top: imageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
    dismissButton.anchor(top: imageView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 24), size: .init(width: 50, height: 50))
    }
    
    fileprivate func setupBottomControls() {
        let stackView = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton, likeButton])
        stackView.distribution = .fillEqually
        stackView.spacing = -32
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 80))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    }
    
    fileprivate func setupVisualBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    //TODO:- handle methods
    
    @objc fileprivate func handleDislike() {
        print("Disliking")
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.dismiss(animated: true)
    }
}

extension UserDetailVC:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let valueY = scrollView.contentOffset.y
        print(valueY)
        var width = view.frame.width - valueY * 2
        width = max(view.frame.width, width)
        imageView.frame =  CGRect(x: min(0,valueY), y: min(0,valueY), width: width, height: width )
    }
}
