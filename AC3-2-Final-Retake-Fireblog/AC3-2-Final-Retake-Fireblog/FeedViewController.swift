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
    fileprivate var _storageHandle: FIRStorageHandle!
    var databaseReference: FIRDatabaseReference!
    var storageReference: FIRStorageReference!
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
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: Firebase
    
    func checkForLoggedInUser() {
        _authHandle = FIRAuth.auth()?.addStateDidChangeListener({ (auth: FIRAuth?, user: FIRUser?) in
            if let activeUser = user {
                self.user = activeUser
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
            if let email = value["email"] as? String,
                let timestamp = value["timestamp"] as? Double,
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
        
        let post = posts[indexPath.row]
        
        cell.userEmailLabel.text = post.madeByUserWithEmail
        
        let timeInterval = TimeInterval(post.timestamp)
        let dateFromTimeInterval = NSDate(timeIntervalSinceReferenceDate: timeInterval)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy, h:mm a"
        
        let postDateString = dateFormatter.string(from: dateFromTimeInterval as Date)
        cell.timestampLabel.text = postDateString
        
        switch post.type {
        case PostType.text.rawValue:
            cell.contentView.addSubview(cell.postTextLabel)
            
            let _ = [
                cell.postTextLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.6),
                cell.postTextLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8.0),
                cell.postTextLabel.leadingAnchor.constraint(equalTo: cell.userEmailLabel.trailingAnchor, constant: 8.0),
                cell.postTextLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8.0),
                cell.postTextLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8.0)
                ].map{ $0.isActive = true }
            
            if let postText = post.text {
                cell.postTextLabel.text = postText
            }
        case PostType.image.rawValue:
            cell.contentView.addSubview(cell.postImageView)
            
            let _ = [
                cell.postImageView.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.6),
                cell.postImageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8.0),
                cell.postImageView.leadingAnchor.constraint(equalTo: cell.userEmailLabel.trailingAnchor, constant: 8.0),
                cell.postImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8.0),
                cell.postImageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8.0)
                ].map{ $0.isActive = true }
           
           getPostImageFromStorage(post.postID, completion: { (image) in
            DispatchQueue.main.async {
                cell.postImageView.image = image
                self.tableView.reloadData()
            }
           })
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func getPostImageFromStorage(_ key: String, completion: @escaping (UIImage) -> ()) {

        storageReference = FIRStorage.storage().reference(forURL: "gs://ac-32-final-retake.appspot.com/")
        
        let imagesRef = storageReference.child("images/")
        
        let postImageRef = imagesRef.child("\(key)")
        
        postImageRef.downloadURL { (url: URL?, error: Error?) in
            if error != nil {
                print("ERROR DOWNLOADING POST IMAGE: \(error!)")
            }
            
            if let validData = NSData(contentsOf: url!) {
                if let image = UIImage(data: validData as Data) {
                    completion(image)
                }
            } else {
                print("UNABLE TO CONVER IMAGE INTO DATA")
            }
        }
    }
}
