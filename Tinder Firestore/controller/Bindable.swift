//
//  Bindable.swift
//  Tinder Firestore
//
//  Created by hosam on 5/22/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?)->())?
    
    func bind(observer: @escaping (T?) ->()) {
        self.observer = observer
    }
    
}
