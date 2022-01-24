//
//  EditProfileViewController.swift
//  A-List
//
//  Created by Norman Yuan on 11/26/21.
//  Copyright © 2021 A-List. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    public var completion: (() -> Void)?
    
    // Fields
    let nameField: ALTextField = {
       let field = ALTextField()
        field.placeholder = "姓名"
        return field
    }()
    
    private let bioTextView: UITextView = {
       let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.backgroundColor = .secondarySystemBackground
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "编辑主页"
        view.backgroundColor = .systemBackground
        view.addSubview(nameField)
        let label = UILabel(frame: CGRect(x: 20, y: 125, width: 200, height: 21))
        label.textAlignment = .left
            label.text = "个性签名："
        view.addSubview(label)
        view.addSubview(bioTextView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "完成",
            style: .done,
            target: self,
            action: #selector(didTapSave))
        
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        DatabaseManager.shared.getUserInfo(username: username) { [weak self] info in
            DispatchQueue.main.async {
                if let info = info {
                    self?.nameField.text = info.name
                    self?.bioTextView.text = info.bio
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nameField.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top+10,
            width: view.width-40,
            height: 50)
        bioTextView.frame = CGRect(
            x: 20,
            y: nameField.bottom+40,
            width: view.width-40,
            height: 120)
    }
    
    //Actions
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

    @objc func didTapSave() {
        let name = nameField.text ?? ""
        let bio = bioTextView.text ?? ""
        let newInfo = UserInfo(name: name, bio: bio)
        DatabaseManager.shared.setUserInfo(userInfo: newInfo) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.completion?()
                    self?.didTapClose()
                }
            }
        }
    }
}
