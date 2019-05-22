//
//  RegistrationViewModel.swift
//  Tinder Firestore
//
//  Created by hosam on 5/22/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import Firebase
class RegistrationViewModel {
    
    //using bindable
    var bindableIsRegistraing = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValidate = Bindable<Bool>()
    
    
//    var image:UIImage? {
//        didSet{
//            imageObserver?(image)
//        }
//    }
    
    var fullName:String? {didSet {checkFormValid()}}
    var email:String? {didSet {checkFormValid()}}
    var password:String? {didSet {checkFormValid()}}
    
    func performRegistration(completion:@escaping (Error?)->())  {
        guard let email = email,let password = password
        else { return  }
        bindableIsRegistraing.value = true
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if let err = err{
                print(err)
                completion(err)
                return
            }
            let fileName = UUID().uuidString
            let ref =   Storage.storage().reference(withPath: "User-Images").child(fileName)
            guard  let data = self.bindableImage.value?.jpegData(compressionQuality: 0.75) else {return}
            ref.putData(data, metadata: nil, completion: { (_, err) in
                if let err = err {
                   completion(err)
                    return
                }
                
                ref.downloadURL(completion: { (url, err) in
                    if let err = err {
                      completion(err)
                        return
                    }
                    
                    self.bindableIsRegistraing.value = false
                    print(url?.absoluteString)
                })
            })
        }
    }
    
    func checkFormValid()  {
        let isValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        
        bindableIsFormValidate.value = isValid
    }
    
    //reactive programming
//    var isFormValidate: ((Bool)->())?
//     var imageObserver: ((UIImage?)->())?
}
