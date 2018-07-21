//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 7/21/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        
        return button
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange),
                     for: .editingChanged)
        
        return tf
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.isEmpty != true
            && usernameTextField.text?.isEmpty != true
            && passwordTextField.text?.isEmpty != true
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange),
                     for: .editingChanged)
        
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange),
                     for: .editingChanged)
        
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp),
                         for: .touchUpInside)
        
        button.isEnabled = false
        
        return button
    }()
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error: Error?) in
            if let err = error {
                print("Failed to create user: ", err)
                return
            }
            
            self.clearFieldValues()
            
            print("Successfully created user:", user?.user.uid ?? "")
        }
    }
    
    func clearFieldValues() {
        emailTextField.text = ""
        usernameTextField.text = ""
        passwordTextField.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        plusPhotoButton.anchor(top: view.topAnchor, leading: view.leadingAnchor,
                               bottom: nil, trailing: view.trailingAnchor, paddingTop: 40,
                               paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                               width: 140, height: 140)
        
        setupInputFields()
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews:
            [emailTextField, usernameTextField, passwordTextField, signUpButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, leading: view.leadingAnchor,
                         bottom: nil, trailing: view.trailingAnchor, paddingTop: 20,
                         paddingLeft: 40, paddingBottom: 0, paddingRight: 40,
                         width: 0, height: 200)
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?,
                paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat,
                paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top,
                                 constant: paddingTop).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading,
                                     constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom,
                                    constant: paddingBottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing,
                                      constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

