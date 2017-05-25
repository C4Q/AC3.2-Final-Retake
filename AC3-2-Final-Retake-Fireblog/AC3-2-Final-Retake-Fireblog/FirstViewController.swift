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

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var databaseReference: FIRDatabaseReference!
    var loggedIn: Bool = false
    var blogPosts: [BlogPost] = []
    
    @IBOutlet weak var logOutBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseReference = FIRDatabase.database().reference().child("posts")
        
        //tableView.estimatedRowHeight = 460
        //tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getPosts()
    }
    override func viewDidAppear(_ animated: Bool) {
        if !loggedIn {
            loggedIn = true
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyBoard.instantiateViewController(withIdentifier: "LogInViewController")
            self.present(loginVC, animated: false, completion: nil)
        }
    }
    func getPosts() {
        databaseReference.observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            var gottenPosts: [BlogPost] = []
            
            for child in snapshot.children {
                if let snap = child as? FIRDataSnapshot, let valueDict = snap.value as? [String: AnyObject] {
                    if let type = valueDict["type"] as? String,
                        let userId = valueDict["userId"] as? String,
                        let timestamp = valueDict["timestamp"] as? NSNumber,
                        let email = valueDict["email"] as? String,
                        let postId = valueDict["postId"] as? String,
                        let text = valueDict["text"] as? String {
                    let post = BlogPost(email: email, text: text, timestamp: timestamp, type: type, userId: userId, postId: postId)
                        gottenPosts.append(post)
                    }
                }
            }
            self.blogPosts = gottenPosts
            self.tableView.reloadData()
        })
    }


    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogPosts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! blogPostTableViewCell
        let post = blogPosts[indexPath.row]
        
        cell.blogPostImageView.image = nil
        cell.blogPostLabel.text = post.text
        cell.blogPostLabel.numberOfLines = 0
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        let spaceRef = storageRef.child("images/\(post.postId)")
        spaceRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                //if cell == tableView.cellForRow(at: indexPath) {
                let image = UIImage(data: data!)
                cell.blogPostImageView.image = image
                //}
            }
        }
        return cell
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

