//
//  FeedViewController.swift
//  
//
//  Created by Erica Y Stevens on 4/13/17.
//
//

import UIKit
import Firebase

class FeedViewController: UIViewController {
    
    fileprivate var _authHandle: FIRAuthStateDidChangeListenerHandle!
    var user: FIRUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        checkForLoggedInUser()
    }

    func checkForLoggedInUser() {
        _authHandle = FIRAuth.auth()?.addStateDidChangeListener({ (auth: FIRAuth?, user: FIRUser?) in
            if let activeUser = user {
               self.user = activeUser
                //Add logout button to nav bar
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logOutUser(_:)))
            }
        })
    }
    
    func logOutUser(_ sender: UIBarButtonItem) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let loginController = LoginRegistrationViewController()
                self.present(loginController, animated: true, completion: nil)
            }
            catch let error as NSError {
                print("ERROR \(error.localizedDescription)")
            }
        }
    }
}
