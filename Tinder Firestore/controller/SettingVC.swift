//
//  SettingVC.swift
//  Tinder Firestore
//
//  Created by hosam on 5/23/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import Firebase

class SettingVC: UITableViewController {
    
    lazy var image1Button = createButtons(selector: #selector(handleChooseImage))
    lazy var image2Button = createButtons(selector: #selector(handleChooseImage))
    lazy var image3Button = createButtons(selector: #selector(handleChooseImage))
    
    fileprivate let padding:CGFloat = 16
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .red
        headerView.addSubview(image1Button)
        image1Button.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, trailing: nil,padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.45).isActive = true
        let mainStack = UIStackView(arrangedSubviews: [image2Button,image3Button])
        
        headerView.addSubview(mainStack)
        mainStack.axis = .vertical
        mainStack.spacing = padding
        mainStack.distribution = .fillEqually
        
        mainStack.anchor(top: headerView.topAnchor, leading: image1Button.trailingAnchor, bottom: headerView.bottomAnchor, trailing: headerView.trailingAnchor,padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    func setupNavigationItems()  {
        navigationItem.title = "Setting"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
        UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
        UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        ]
    }
    
    func createButtons(selector:Selector) -> UIButton {
        let bt = UIButton()
        bt.setTitle("Choose Photo", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.backgroundColor = .white
        bt.clipsToBounds = true
        bt.layer.cornerRadius = 8
        bt.contentMode = .scaleAspectFill
        bt.addTarget(self, action: selector, for: .touchUpInside)
        return bt
    }
    
    @objc  func handleChooseImage(sender:UIButton)  {
        let imagePicker = CustomImagePickerController()
        imagePicker.imageButton = sender
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
   @objc func handleSave()  {
        print(123)
    }
    
    @objc func handleLogout()  {
        do {
            try Auth.auth().signOut()
        } catch let err {
            print(err)
        }
        
        let reg = RegisterVC()
        present(reg, animated: true, completion: nil)
        
    }
    
   @objc func handleCancel()  {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if  let selectedImage = info[.originalImage] as? UIImage {
            if let button = (picker as? CustomImagePickerController)?.imageButton{
                button.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            
        }
        dismiss(animated: true, completion: nil)
    }
}
