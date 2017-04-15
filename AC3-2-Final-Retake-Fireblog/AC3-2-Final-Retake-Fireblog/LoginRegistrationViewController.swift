//
//  LoginRegistrationViewController.swift
//  AC3-2-Final-Retake-Fireblog
//
//  Created by Erica Y Stevens on 4/13/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class LoginRegistrationViewController: UIViewController {
    
    // MARK: Stored Properties
    
    var user: FIRUser?
    var databaseReference: FIRDatabaseReference!
    
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
        button.addTarget(self, action: #selector(loginExistingUser(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(registerNewUser(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: Target Action Methods
    
    func loginExistingUser(_ sender: UIButton) {
        print("LOGIN PRESSED")
        if emailTextField.text == "" || self.passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Missing Email and Password", message: "Please fill in all fields", preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertController.addAction(okayAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Enter email", message: "Please enter email to continue", preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertController.addAction(okayAction)
            
            self.present(alertController, animated: true, completion: nil)
        }  else if (self.passwordTextField.text?.characters.count)! < 5{
            let alertController = UIAlertController(title: "Password too short", message: "Must be at least 5 characters", preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertController.addAction(okayAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user: FIRUser?, error: Error?) in
                if error != nil {
                    let alertController = UIAlertController(title: "Error Logging In", message: "Please try again", preferredStyle: .alert)
                    
                    let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    
                    alertController.addAction(okayAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    self.user = user!
                    self.presentMainApp()
                }
            })
        }
    }
    
    func registerNewUser(_ sender: UIButton) {
        print("REGISTER PRESSED")
        //Check for non nil values in both text fields
        if emailTextField.text == "" || self.passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Missing Email and Password", message: "Please fill in all fields", preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertController.addAction(okayAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Enter email", message: "Please enter email to continue", preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertController.addAction(okayAction)
            
            self.present(alertController, animated: true, completion: nil)
        }  else if (self.passwordTextField.text?.characters.count)! < 5{
            let alertController = UIAlertController(title: "Password too short", message: "Must be at least 5 characters", preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertController.addAction(okayAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user: FIRUser?, error: Error?) in
                if error != nil {
                    print("ERROR CREATING USER: \(error)")
                    
                    let alertController = UIAlertController(title: "Error Creating Account", message: "Please try again", preferredStyle: .alert)
                    
                    let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    
                    alertController.addAction(okayAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    print("SUCCESSFULLY REGISTERED USER: \(user!.email!)")
                }
                
            })
        }
    }
    
    func presentMainApp() {
        let feedController = UINavigationController(rootViewController: FeedViewController())
        let uploadController = UINavigationController(rootViewController: UploadViewController())
        
        let tabBarController = UITabBarController()
        let controllers = [feedController, uploadController]
        tabBarController.viewControllers = controllers
        
        feedController.tabBarItem = UITabBarItem(title: "First", image: #imageLiteral(resourceName: "first"), tag: 0)
        uploadController.tabBarItem = UITabBarItem(title: "Second", image: #imageLiteral(resourceName: "second"), tag: 1)
        
        self.present(tabBarController, animated: true, completion: nil)
    }
}
