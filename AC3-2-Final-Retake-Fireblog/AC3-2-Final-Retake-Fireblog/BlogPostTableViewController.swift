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
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = blogPosts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! blogPostTextTableViewCell
        if post.type == "text" {
            
        cell.blogTextLabel?.text = post.text
        
        }
        return cell
    }
    
        
//        if post.type == "image/jpeg" {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! blogPostTableViewCell
//            
//            cell.blogPostImageView.image = nil
//            cell.detailTextLabel?.text = post.type
//            
//            let storage = FIRStorage.storage()
//            let storageRef = storage.reference()
//            let spaceRef = storageRef.child("images/\(post.postId)")
//            spaceRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
//                if let error = error {
//                    print(error)
//                } else {
//                    //if cell == tableView.cellForRow(at: indexPath) {
//                    let image = UIImage(data: data!)
//                    cell.blogPostImageView.image = image
//                    //}
//                }
//            }
//            return cell
//        }
    
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
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
//
//    /*
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        // Configure the cell...
//
//        return cell
//    }
//    */
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
