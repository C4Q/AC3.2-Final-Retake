//
//  FirstViewController.swift
//  AC3-2-Final-Retake-Fireblog
//
//  Created by Jason Gresh on 4/13/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class FirstViewController: UIViewController {
var loggedIn: Bool = false
    
    @IBOutlet weak var logOutBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if !loggedIn {
            loggedIn = true
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyBoard.instantiateViewController(withIdentifier: "LogInViewController")
            self.present(loginVC, animated: false, completion: nil)
        }
    }

    @IBAction func logOutBarButtonTapped(_ sender: UIBarButtonItem) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch {
            print(error)
        }
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "LogInViewController")
        self.present(vc, animated: true, completion: nil)
        return
    }
}

