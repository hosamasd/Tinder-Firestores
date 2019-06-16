//
//  LoginVC.swift
//  Tinder Firestore
//
//  Created by hosam on 5/25/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import LBTATools
import Firebase
import JGProgressHUD

protocol LoginVCDelgate {
    func performFetchData()
}

class LoginVC: UIViewController {
    
    let loginViewModel = LoginViewModel ()
    var delgate:LoginVCDelgate? 
    var registerHUD = JGProgressHUD(style: .dark)
     let gradiantLayer = CAGradientLayer()
    
    lazy var emailTextField:CustomTextField = {
        let tf = CustomTextField(padding: 16, height: 50)
        tf.keyboardType = .emailAddress
        tf.placeholder = "enter your email"
        tf.text = "h@h.com"
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
    lazy var loginButton:UIButton = {
        let bt = UIButton(title: "Login", titleColor: .white, font: .systemFont(ofSize: 20, weight: .heavy), backgroundColor: .lightGray, target: self, action: #selector(handleLogin))
        bt.setTitleColor(.gray, for: .disabled)
        bt.isEnabled = false
        bt.layer.cornerRadius = 22
        bt.constrainHeight(44)
        return bt
    }()
    lazy var registerButton:UIButton = {
        let bt = UIButton(title: "Back To Register", titleColor: .white, font: .systemFont(ofSize: 20, weight: .heavy), backgroundColor: #colorLiteral(red: 0.8902122974, green: 0.1073872522, blue: 0.4597495198, alpha: 1)
            , target: self, action: #selector(handleRegister))
        bt.constrainHeight(44)
        return bt
    }()
    
    lazy var verticalStackView:UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            loginButton
            ])
        sv.axis = .vertical
        sv.spacing = 8
        sv.distribution = .fillEqually
        return sv
    }()
    
   override func viewDidLoad() {
        super.viewDidLoad()
        setupGradiantLayer()
        setupViews()
        setupNotificationObservers()
    setupLoginViewModelObserver()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradiantLayer.frame = view.bounds
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        navigationController?.navigationBar.isHidden = false
    //    }
    
     //MARK:-user methods
    
    fileprivate func setupLoginViewModelObserver(){
        loginViewModel.bindableIsFormValidate.bind { (isValidForm) in
            guard let isValid = isValidForm else {return}
            self.loginButton.isEnabled = isValid
            
            if isValid {
                self.loginButton.backgroundColor = #colorLiteral(red: 0.8273344636, green: 0.09256268293, blue: 0.324395299, alpha: 1)
                self.loginButton.setTitleColor(.white, for: .normal)
                
            
            }else {
                self.loginButton.backgroundColor = UIColor.lightGray
                self.loginButton.setTitleColor(.gray, for: .normal)
                
            }

         }
        
        loginViewModel.bindableIsLogining.bind(observer: {  [unowned self] (isReg) in
                if isReg == true {
                    self.registerHUD.textLabel.text = "Login"
                    self.registerHUD.show(in: self.view)
                    
                }else {
                    self.registerHUD.dismiss()
                }
            

        })
    }
    
    fileprivate  func setupViews()  {
        
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(verticalStackView)
        view.addSubview(registerButton)
        
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.centerYToSuperview()
        registerButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 50, bottom: 50, right: 50))
        registerButton.centerYAnchor
    }
    
    fileprivate  func setupGradiantLayer()  {
        
        let topColor = #colorLiteral(red: 0.989370048, green: 0.3686362505, blue: 0.3827736974, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8902122974, green: 0.1073872522, blue: 0.4597495198, alpha: 1)
        
        gradiantLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        gradiantLayer.locations = [0,1]
        view.layer.addSublayer(gradiantLayer)
        gradiantLayer.frame = view.bounds
    }
    
    fileprivate func setupNotificationObservers() {
        //when make notification you should remove them to avoid retain cycle
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowing), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDismissKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    fileprivate func animateView(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.transform = .identity
        })
    }
    
    fileprivate func showHUDWithError(err:Error){
        registerHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Login Faield"
        hud.detailTextLabel.text = err.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    //TODO:-handle methods
    
    @objc  func handleKeyboardShowing(notify:Notification)  {
        guard let value = notify.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        
        let bottomSpace = view.frame.height - verticalStackView.frame.origin.y - verticalStackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        
    }
    
    
    @objc func handleDismissKeyboard()  {
        view.endEditing(true)
        
        animateView()
    }
    
    @objc  func handleLogin()  {
        self.handleDismissKeyboard()
        
        loginViewModel.performLogin { (err) in
            if let err = err {
                self.showHUDWithError(err: err)
                return
            }
            self.dismiss(animated: true, completion: {
                self.delgate?.performFetchData()
            })
        }
    }
    
    @objc func handleTextChange(text:UITextField)  {
        
        if text == emailTextField {
            loginViewModel.email = text.text
        }else if text == passwordTextField {
            loginViewModel.password = text.text
        }
    }
    
    @objc func handleRegister(){
        let reg = RegisterVC()
        present(reg, animated: true, completion: nil)
    }
}
