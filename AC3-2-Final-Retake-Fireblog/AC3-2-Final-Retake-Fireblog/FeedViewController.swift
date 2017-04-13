//
//  FeedViewController.swift
//  
//
//  Created by Erica Y Stevens on 4/13/17.
//
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Stored Properties
    
    fileprivate var _authHandle: FIRAuthStateDidChangeListenerHandle!
    fileprivate var _refHandle: FIRDatabaseHandle!
    var databaseReference: FIRDatabaseReference!
    var user: FIRUser?
    var postInfoFromDatabase = [String:[String:Any]]()
    var posts = [Post]()
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        checkForLoggedInUser()
        setupViewHiearchy()
        configureConstraints()
        configureTableView()
        getPostsFromDatabase { (postInfoDict) in
            DispatchQueue.main.async {
                self.posts = self.buildPostObjectsFromDatabaseInfo(postInfoDict)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: View Hierarchy and Constraints
    
    func setupViewHiearchy() {
       self.view.addSubview(tableView)
    }
    
    func configureConstraints() {
        let _ = [
            tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ].map{ $0.isActive = true }
    }
    
    // MARK: TableView Configuration
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "FeedCell")
    }

    // MARK: Firebase
    
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
    
    func getPostsFromDatabase(completion: @escaping ([String:[String:Any]]) -> ()) {
        databaseReference = FIRDatabase.database().reference(fromURL: "https://ac-32-final-retake.firebaseio.com/")

        _refHandle = databaseReference.observe(.childAdded, with: { (snapshot) in
            
            if let postsDict = snapshot.value as? [String:Any] {
                for (key, value) in postsDict {
                    if let postDict = value as? [String:Any] {
                        self.postInfoFromDatabase.updateValue(postDict, forKey: key)
                    }
                }
                completion(self.postInfoFromDatabase)
            }
        })
    }
    
    func buildPostObjectsFromDatabaseInfo(_ infoDict: [String:[String:Any]]) -> [Post] {
        var posts = [Post]()
        
        for (key, value) in infoDict {
            print("POST INFO: \(value)")
            if let email = value["email"] as? String,
                let timestamp = value["timestamp"] as? Int,
                let type = value["type"] as? String,
                let text = value["text"] as? String? {
                
                let post = Post(email: email, type: type, timestamp: timestamp, postID: key, text: text)
                posts.append(post)
            }
        }
        return posts
    }
    
    // MARK: Lazy Instantiation
    
    lazy var tableView: UITableView = {
       let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: TableView Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableViewCell
        
        return cell
    }
}
