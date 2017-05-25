//
//  BlogPostTableViewController.swift
//  AC3-2-Final-Retake-Fireblog
//
//  Created by C4Q on 5/25/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class BlogPostTableViewController: UITableViewController {
    var databaseReference: FIRDatabaseReference!
    var loggedIn: Bool = false
    var blogPosts: [BlogPost] = []
    
    @IBOutlet weak var logOutBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseReference = FIRDatabase.database().reference().child("posts")
        
        tableView.estimatedRowHeight = 460
        tableView.rowHeight = UITableViewAutomaticDimension
        
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
                    if let text = valueDict["text"] as? String,
                        let type = valueDict["type"] as? String{
//                        let userId = valueDict["userId"] as? String,
//                        let timestamp = valueDict["timestamp"] as? NSNumber,
//                        let email = valueDict["email"] as? String,
//                        let postId = valueDict["postId"] as? String,
//                        let type = valueDict["type"] as? String {
                        let post = BlogPost(email: "test", text: text, timestamp: 123, type: type, userId: "test", postId: "test")
                        gottenPosts.append(post)
                    }
                }
            }
            self.blogPosts = gottenPosts
            self.tableView.reloadData()
        })
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
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let post = blogPosts[indexPath.row]
            if post.type == "text" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! blogPostTextTableViewCell
                cell.blogTextLabel?.text = post.text
                cell.detailTextLabel?.text = post.email
                return cell
            } else {
                if post.type != "text" {
                    let cellImage = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! blogPostTableViewCell
                    cellImage.blogPostImageView.image = nil
                    cellImage.detailTextLabel?.text = post.email
                    
                    let storage = FIRStorage.storage()
                    let storageRef = storage.reference()
                    let spaceRef = storageRef.child("images/\(post.postId)")
                    spaceRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error {
                            print(error)
                        } else {
                            //if cell == tableView.cellForRow(at: indexPath) {
                            let image = UIImage(data: data!)
                            cellImage.blogPostImageView.image = image
                            //}
                        }
                    }
                    return cellImage
                }
                
            }
        }
        return blogPostTableViewCell()
        //not sure how to get the cells to return properly yet: 5:53pm
    //referenced stack overflow here: https://stackoverflow.com/questions/35353737/multiple-prototype-cells-into-uitableview for how to do multiple prototype cells
    }
}
