//
//  RegisterVC.swift
//  Tinder Firestore
//
//  Created by hosam on 5/22/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
    lazy var selectedPhotoButton:UIButton = {
        let bt = UIButton(title: "Select Photo", titleColor: .black, font: .systemFont(ofSize: 32, weight: .heavy), backgroundColor: .white, target: self, action: #selector(handleSelectPhoto))
        bt.layer.cornerRadius = 6
        bt.constrainHeight(constant: 250)
        return bt
    }()
    lazy var emailTextField:CustomTextField = {
       let tf = CustomTextField(padding: 16)
        tf.keyboardType = .emailAddress
        tf.placeholder = "enter your email"
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 25
        
        
        return tf
    }()
    lazy var nameTextField:CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "enter your full name"
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 25
        
        return tf
    }()
    lazy var passwordTextField:CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.isSecureTextEntry = true
        tf.placeholder = "enter your password"
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 25
        
        
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupGradiantLayer()
        setupViews()
    }
    
    func setupGradiantLayer()  {
        let layer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.989370048, green: 0.3686362505, blue: 0.3827736974, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8902122974, green: 0.1073872522, blue: 0.4597495198, alpha: 1)
        
        layer.colors = [topColor.cgColor,bottomColor.cgColor]
        layer.locations = [0,1]
        view.layer.addSublayer(layer)
        layer.frame = view.bounds
    }
    func setupViews()  {
        let arragedView = [
        selectedPhotoButton,
        nameTextField,
        emailTextField,
        passwordTextField
        ]
        
        let mainStack = UIStackView(arrangedSubviews: arragedView)
        mainStack.axis = .vertical
        mainStack.spacing = 10
        
        view.addSubview(mainStack)
        mainStack.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 32, bottom: 0, right: 32))
        mainStack.centerYInSuperview()
    }
   @objc func handleSelectPhoto()  {
        print(321)
    }
}


