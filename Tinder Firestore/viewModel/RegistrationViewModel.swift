//
//  RegistrationViewModel.swift
//  Tinder Firestore
//
//  Created by hosam on 5/22/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    
    var fullName:String? {didSet {checkFormValid()}}
    var email:String? {didSet {checkFormValid()}}
    var password:String? {didSet {checkFormValid()}}
    
    func checkFormValid()  {
        let isValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        
        isFormValidate?(isValid)
    }
    
    //reactive programming
    var isFormValidate: ((Bool)->())?
}
