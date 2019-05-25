//
//  LoginViewModel.swift
//  Tinder Firestore
//
//  Created by hosam on 5/25/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import Firebase

class LoginViewModel {
    
    //using bindable
    var bindableIsLogining = Bindable<Bool>()
    var bindableIsFormValidate = Bindable<Bool>()
    
    var email:String? {didSet {checkFormValid()}}
    var password:String? {didSet {checkFormValid()}}
    
    func performLogin(completion:@escaping (Error?)->())  {
        guard let email = email,let password = password
            else { return  }
        bindableIsLogining.value = true
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if let err = err{
                print(err)
                completion(err)
                return
            }
               }
    }
    
    func checkFormValid()  {
        let isValid =  email?.isEmpty == false && password?.isEmpty == false
        
        bindableIsFormValidate.value = isValid
    }
}
