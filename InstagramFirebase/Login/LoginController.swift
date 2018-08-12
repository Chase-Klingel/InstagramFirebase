//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 8/12/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - Position Login Header With Logo
    
    let logoContainerView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, leading: nil,
                             bottom: nil, trailing: nil,
                             paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                             width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        
        return view
    }()
    
    // UI Input Field Definitions (email, password, login button)
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
   
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - Don't Have Account Helper Button
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ",
                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
                                                                     NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: .bold),
                                                                                         NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitle("Dont have an account? Sign Up.", for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUpController), for: .touchUpInside)
        
        return button
    }()
    
    @objc fileprivate func handleShowSignUpController() {
        let signUpController = SignUpController()

        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, leading: view.leadingAnchor,
                                 bottom: nil, trailing: view.trailingAnchor,
                                 paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                                 width: 0, height: 150)
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        
        
        setupInputFields()
        setupDontHaveAccountButton()
    }
    
    // MARK: - Position UI Input Fields (email, password, login button)
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, leading: view.leadingAnchor,
                         bottom: nil, trailing: view.trailingAnchor,
                         paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40,
                         width: 0, height: 140)
    }
    
    fileprivate func setupDontHaveAccountButton() {
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, leading: view.leadingAnchor,
                             bottom: view.bottomAnchor, trailing: view.trailingAnchor,
                             paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                             width: 0, height: 50)
    }
    
    
}
