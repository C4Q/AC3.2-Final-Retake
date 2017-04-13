//
//  LoginRegistrationViewController.swift
//  AC3-2-Final-Retake-Fireblog
//
//  Created by Erica Y Stevens on 4/13/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class LoginRegistrationViewController: UIViewController {
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        setupViewHierarchy()
        configureConstraints()
    }
    
    // MARK: View Hierarchy and Constraints
    
    func setupViewHierarchy() {
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
    }
    
    func configureConstraints() {
        let _ = [
            emailTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            emailTextField.heightAnchor.constraint(equalToConstant: 35),
            emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 175),
            
            passwordTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            passwordTextField.heightAnchor.constraint(equalToConstant: 35),
            passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16.0),
            
            registerButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor, multiplier: 0.5),
            registerButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            
            loginButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor, multiplier: 0.5),
            loginButton.leadingAnchor.constraint(equalTo: registerButton.trailingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            loginButton.topAnchor.constraint(equalTo: registerButton.topAnchor)
            ].map{ $0.isActive = true }
    }
    
    // MARK: Lazy Instantiation
    
    lazy var emailTextField: UITextField = {
       let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
       let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(loginButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var registerButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(registerButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: Target Action Methods
    
    func loginButtonPressed(_ sender: UIButton) {
        print("LOGIN PRESSED")
    }
    
    func registerButtonPressed(_ sender: UIButton) {
        print("REGISTER PRESSED")
    }
}
