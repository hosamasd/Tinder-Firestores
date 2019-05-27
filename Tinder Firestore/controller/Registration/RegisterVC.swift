//
//  RegisterVC.swift
//  Tinder Firestore
//
//  Created by hosam on 5/22/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
class RegisterVC: UIViewController {
    
    let registerViewModel = RegistrationViewModel()
    var delgate:LoginVCDelgate?
    let gradiantLayer = CAGradientLayer()
    var registerHUD = JGProgressHUD(style: .dark)
    
    lazy var selectPhotoButtonWidthAnchor = selectedPhotoButton.widthAnchor.constraint(equalToConstant: 275)
    lazy var selectPhotoButtonHeightAnchor = selectedPhotoButton.heightAnchor.constraint(equalToConstant: 275)
    
    lazy var selectedPhotoButton:UIButton = {
        let bt = UIButton(title: "Select Photo", titleColor: .black, font: .systemFont(ofSize: 32, weight: .heavy), backgroundColor: .white, target: self, action: #selector(handleSelectPhoto))
        bt.layer.cornerRadius = 16
        bt.imageView?.contentMode = .scaleAspectFill
        bt.clipsToBounds = true
        
        return bt
    }()
    lazy var emailTextField:CustomTextField = {
        let tf = CustomTextField(padding: 16, height: 50)
        tf.keyboardType = .emailAddress
        tf.placeholder = "enter your email"
        tf.text = "h@h.com"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        
        return tf
    }()
    lazy var nameTextField:CustomTextField = {
        let tf = CustomTextField(padding: 16, height: 50)
        tf.placeholder = "enter your full name"
        tf.text = "hosam"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    lazy var passwordTextField:CustomTextField = {
        let tf = CustomTextField(padding: 16, height: 50)
        tf.isSecureTextEntry = true
        tf.placeholder = "enter your password"
        tf.text = "123456"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    lazy var registerButton:UIButton = {
        let bt = UIButton(title: "Register", titleColor: .white, font: .systemFont(ofSize: 20, weight: .heavy), backgroundColor: UIColor.lightGray, target: self, action: #selector(handleRegister))
        bt.setTitleColor(.gray, for: .disabled)
        bt.isEnabled = false
        bt.layer.cornerRadius = 22
        bt.constrainHeight(constant: 44)
        return bt
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
    lazy var loginButton:UIButton = {
        let bt = UIButton(title: "Go To Login", titleColor: .white, font: .systemFont(ofSize: 20, weight: .heavy), backgroundColor: #colorLiteral(red: 0.8902122974, green: 0.1073872522, blue: 0.4597495198, alpha: 1)
            , target: self, action: #selector(handleLogin))
        bt.constrainHeight(constant: 44)
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
            mainStack.distribution = .fillEqually
            selectPhotoButtonHeightAnchor.isActive = false
            selectPhotoButtonWidthAnchor.isActive = true
        }else {
            mainStack.axis = .vertical
            mainStack.distribution = .fill
            selectPhotoButtonWidthAnchor.isActive = false
            selectPhotoButtonHeightAnchor.isActive = true
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
        registerViewModel.bindableIsFormValidate.bind { [unowned self ] (isValidForm) in
            guard let isValid = isValidForm else {return}
            self.registerButton.isEnabled = isValid
            if isValid {
                self.registerButton.backgroundColor = #colorLiteral(red: 0.8273344636, green: 0.09256268293, blue: 0.324395299, alpha: 1)
                self.registerButton.setTitleColor(.white, for: .normal)
            }else {
                self.registerButton.backgroundColor = UIColor.lightGray
                self.registerButton.setTitleColor(.gray, for: .normal)
            }
        }
        
        registerViewModel.bindableImage.bind(observer: { [unowned self ] (img) in
            self.selectedPhotoButton.setImage(img?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: .normal)
            
        }) 
        
        registerViewModel.bindableIsRegistraing.bind { [unowned self] (isReg) in
            if isReg == true {
                self.registerHUD.textLabel.text = "Register"
                self.registerHUD.show(in: self.view)
                
            }else {
                self.registerHUD.dismiss()
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
        view.addSubview(loginButton)
        mainStack.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        mainStack.centerYInSuperview()
        loginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 50, bottom: 50, right: 50))
        loginButton.centerYAnchor
    }
    
    fileprivate func setupNotificationObservers() {
        //when make notification you should remove them to avoid retain cycle
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowing), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDismissKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    fileprivate func setupGestures()  {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard)))
    }
    
    fileprivate func animateView(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.transform = .identity
        })
    }
    
    fileprivate func showHUDWithError(err:Error){
        registerHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registration Faield"
        hud.detailTextLabel.text = err.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    //TODO:-handle methods
    
     @objc func handleRegister()  {
        self.handleDismissKeyboard()
        
        registerViewModel.performRegistration { (err) in
            if let err = err {
                self.showHUDWithError(err: err)
                return
            }
            self.dismiss(animated: true, completion: {
                self.delgate?.performFetchData()
            })
        }
   }
    
    @objc func handleSelectPhoto()  {
        let imagePickers = UIImagePickerController()
        imagePickers.delegate = self
        imagePickers.sourceType = .photoLibrary
        
        present(imagePickers, animated: true, completion: nil)
    }
    
    @objc  func handleKeyboardShowing(notify:Notification)  {
        guard let value = notify.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        
        let bottomSpace = view.frame.height - mainStack.frame.origin.y - mainStack.frame.height
        let difference = keyboardFrame.height - bottomSpace
        view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        
    }
    
    
    @objc func handleDismissKeyboard()  {
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
    
    @objc func handleLogin(){
        let login = LoginVC()
        present(login, animated: true, completion: nil)
    }
}

extension RegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if  let image = info[.originalImage] as? UIImage {
            registerViewModel.bindableImage.value = image
            dismiss(animated: true, completion: nil)
        }
        
    }
}

