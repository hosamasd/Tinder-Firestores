//
//  RegisterVC.swift
//  Tinder Firestore
//
//  Created by hosam on 5/22/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
    let registerViewModel = RegistrationViewModel()
    
    let gradiantLayer = CAGradientLayer()
    lazy var selectedPhotoButton:UIButton = {
        let bt = UIButton(title: "Select Photo", titleColor: .black, font: .systemFont(ofSize: 32, weight: .heavy), backgroundColor: .white, target: self, action: #selector(handleSelectPhoto))
        bt.layer.cornerRadius = 6
        bt.constrainHeight(constant: 250)
        bt.constrainWidth(constant: 275)
        
        return bt
    }()
    lazy var emailTextField:CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.keyboardType = .emailAddress
        tf.placeholder = "enter your email"
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        
        return tf
    }()
    lazy var nameTextField:CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "enter your full name"
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    lazy var passwordTextField:CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.isSecureTextEntry = true
        tf.placeholder = "enter your password"
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    lazy var verticalStackView:UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            nameTextField,
            emailTextField,
            passwordTextField,
            registerButton
            ])
        sv.axis = .vertical
        sv.spacing = 8
        sv.distribution = .fillEqually
        return sv
    }()
    lazy var mainStack = UIStackView(arrangedSubviews: [
        selectedPhotoButton,
        verticalStackView
        ])
    
    lazy var registerButton:UIButton = {
        let bt = UIButton(title: "Register", titleColor: .white, font: .systemFont(ofSize: 20, weight: .heavy), backgroundColor: UIColor.lightGray, target: self, action: #selector(handleRegister))
        bt.setTitleColor(.gray, for: .disabled)
        bt.isEnabled = false
        bt.layer.cornerRadius = 25
        bt.constrainHeight(constant: 50)
        return bt
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradiantLayer()
        setupViews()
        setupNotificationObservers()
        setupGestures()
        setupRegisterViewModelObserver()
    }
    
    //TODO:- landscape mode
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            mainStack.axis = .horizontal
        }else {
            mainStack.axis = .vertical
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradiantLayer.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self) // for avoiding retain cycle!
    }
    
    
    //MARK:-user methods
    
    fileprivate func setupRegisterViewModelObserver(){
        registerViewModel.isFormValidate = { (isValidForm) in
            self.registerButton.isEnabled = isValidForm
            if isValidForm {
                self.registerButton.backgroundColor = #colorLiteral(red: 0.8273344636, green: 0.09256268293, blue: 0.324395299, alpha: 1)
                self.registerButton.setTitleColor(.white, for: .normal)
            }else {
                self.registerButton.backgroundColor = UIColor.lightGray
                self.registerButton.setTitleColor(.gray, for: .normal)
            }
  }
    }
    
    fileprivate  func setupGradiantLayer()  {
        
        let topColor = #colorLiteral(red: 0.989370048, green: 0.3686362505, blue: 0.3827736974, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8902122974, green: 0.1073872522, blue: 0.4597495198, alpha: 1)
        
        gradiantLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        gradiantLayer.locations = [0,1]
        view.layer.addSublayer(gradiantLayer)
        gradiantLayer.frame = view.bounds
    }
    
    fileprivate  func setupViews()  {
        
        mainStack.axis = .horizontal
        mainStack.spacing = 8
        
        view.addSubview(mainStack)
        mainStack.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 32, bottom: 0, right: 32))
        mainStack.centerYInSuperview()
    }
    
    fileprivate func setupNotificationObservers() {
        //when make notification you should remove them to avoid retain cycle
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowing), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    fileprivate func setupGestures()  {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewTapped)))
    }
    
    fileprivate func animateView(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.transform = .identity
        })
    }
    
    //TODO:-handle methods
    
    @objc func handleRegister()  {
        print(023)
    }
    
    @objc func handleSelectPhoto()  {
        print(321)
    }
    
    @objc  func handleKeyboardShowing(notify:Notification)  {
        guard let value = notify.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame)
        
        let bottomSpace = view.frame.height - mainStack.frame.origin.y - mainStack.frame.height
        let difference = keyboardFrame.height - bottomSpace
        view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        
    }
    
    @objc  func handleKeyboardDismiss()  {
        animateView()
    }
    
    @objc func handleViewTapped()  {
        view.endEditing(true)
        
        animateView()
    }
    
    @objc func handleTextChange(text:UITextField)  {
        if text == emailTextField {
            registerViewModel.email = text.text
        }else  if text == nameTextField {
            registerViewModel.fullName = text.text
        }else {
            registerViewModel.password = text.text
        }
    }
}


