//
//  SIgnUpViewController.swift
//  A-List
//
//  Created by Norman Yuan on 11/13/21.
//  Copyright © 2021 A-List. All rights reserved.
//

/*
import SafariServices
import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func setUpNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                               for: .default)
    }
    
    // Subviews

    private let profilePictureImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.tintColor = .lightGray
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 45
        return imageView
    }()
    
    private let usernameField: ALTextField = {
       let field = ALTextField()
        field.placeholder = "用户名"
        field.returnKeyType = .next
        field.autocorrectionType = .no
        return field
    }()
    
    private let emailField: ALTextField = {
       let field = ALTextField()
        field.placeholder = "邮箱"
        field.returnKeyType = .next
        field.autocorrectionType = .no
        return field
    }()
    
    private let passwordField: ALTextField = {
       let field = ALTextField()
        field.placeholder = "密码"
        field.isSecureTextEntry = true
        field.returnKeyType = .continue
        field.autocorrectionType = .no
        return field
    }()
    
    private let signUpButton: UIButton = {
       let button = UIButton()
        button.setTitle("注册", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private let termsButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("使用条款", for: .normal)
        
        return button
    }()
    
    private let privacyButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("数据使用政策", for: .normal)
        
        return button
    }()

    public var completion: (() -> Void)?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self

        // Do any additional setup after loading the view.
        addButtonActions()
        addImageGesture()
        setUpNavBar()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageSize: CGFloat = 90
        
        profilePictureImageView.frame = CGRect(
            x: (view.width - imageSize)/2,
            y: view.safeAreaInsets.top + 15,
            width: imageSize,
            height: imageSize
        )
        
        usernameField.frame = CGRect(x: 25, y: profilePictureImageView.bottom+20, width: view.width-50, height: 50)
        emailField.frame = CGRect(x: 25, y: usernameField.bottom+10, width: view.width-50, height: 50)
        passwordField.frame = CGRect(x: 25, y: emailField.bottom+10, width: view.width-50, height: 50)
        signUpButton.frame = CGRect(x: 35, y: passwordField.bottom+20, width: view.width-70, height: 50)
        termsButton.frame = CGRect(x: 35, y: signUpButton.bottom+50, width: view.width-70, height: 40)
        privacyButton.frame = CGRect(x: 35, y: termsButton.bottom, width: view.width-70, height: 40)

    }
    
    private func addSubviews() {
        view.addSubview(profilePictureImageView)
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
    }
    
    private func addImageGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        profilePictureImageView.isUserInteractionEnabled = true
        profilePictureImageView.addGestureRecognizer(tap)
    }
    
    private func addButtonActions() {
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacy), for: .touchUpInside)
    }
    
    //MARK: - Actions
    
    @objc func didTapImage() {
        let sheet = UIAlertController(
            title: "添加头像",
            message: "帮助朋友找到你",
            preferredStyle: .actionSheet
        )
        
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "拍照", style: .default, handler: {[weak self] _ in
            
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.sourceType = .camera
                picker.delegate = self
                self?.present(picker, animated: true)
            }
        }))
        sheet.addAction(UIAlertAction(title: "从手机图库中选择", style: .default, handler: {[weak self] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self?.present(picker, animated: true)
            }
        }))
        
        present(sheet, animated: true)
    }
    
    @objc func didTapSignUp() {
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let username = usernameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 8,
              username.count >= 2 else {
                  
            presentError()
            return
              }
        
        let data = profilePictureImageView.image?.pngData()
        
        // Sign up with authManager
        AuthManager.shared.signUp(
            email: email,
            username: username,
            password: password,
            profilePicture: data
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    HapticManager.shared.vibrate(for: .success)
                    UserDefaults.standard.setValue(user.email, forKey: "email")
                    UserDefaults.standard.setValue(user.username, forKey: "username")
                    self?.navigationController?.popToRootViewController(animated: true)
                    self?.completion?()
                case .failure(let error):
                    HapticManager.shared.vibrate(for: .error)
                    print("\n\nSign Up Error: \(error)")
                }
            }
        }
    }
    
    private func presentError() {
        let alert = UIAlertController(title: "注册失败", message: "密码必须是8-16位 \n 请填写有效的电子邮箱", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc func didTapTerms() {
        guard let url = URL(string: "https://www.apple.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc func didTapPrivacy() {
        guard let url = URL(string: "https://www.apple.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }

    //MARK: Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            didTapSignUp()
        }
        return true
    }
    
    // Image Picker
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        profilePictureImageView.image = image
    }
}
 */
