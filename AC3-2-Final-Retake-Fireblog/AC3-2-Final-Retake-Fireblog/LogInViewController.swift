//
//  LogInViewController.swift
//  AC3-2-Final-Retake-Fireblog
//
//  Created by C4Q on 5/25/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseAuth


class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        if let username = emailTextField.text,
            let password = passwordTextField.text {
            logInButton.isEnabled = false
            FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: { (user: FIRUser?, error: Error?) in
                if error != nil  {
                    print("Error \(error)")
                }
                if user != nil {
                    print("Success")
                    self.showOKAlert(title: "Log In Successful", message: nil) {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    self.showOKAlert(title: "Log In Failed", message: error?.localizedDescription)
                }
                self.logInButton.isEnabled = true
            })
        }
        
    }

    @IBAction func registerButton(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                if error != nil {
                    print("error with completion while creating new Authentication: \(error!)")
                }
                if user != nil {
                    self.showOKAlert(title: "Registration Succesful", message: nil) {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    self.showOKAlert(title: "Registration Failed", message: error?.localizedDescription)
                }
                self.registerButton.isEnabled = true
            })
        }
    }
    func showOKAlert(title: String, message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
            if let completionAction = completion {
                completionAction()
            }
        }
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
