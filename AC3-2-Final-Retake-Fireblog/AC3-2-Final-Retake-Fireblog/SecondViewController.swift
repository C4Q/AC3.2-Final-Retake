//
//  SecondViewController.swift
//  AC3-2-Final-Retake-Fireblog
//
//  Created by Jason Gresh on 4/13/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class SecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    var selectedImage: UIImage?
    var selectedText: String?
    var email: String?
    var databaseReference: FIRDatabaseReference!

    @IBOutlet weak var postBarButton: UIBarButtonItem!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseReference = FIRDatabase.database().reference().child("posts")
        setTextView()
    }
    @IBAction func postBarButtonTapped(_ sender: UIBarButtonItem) {
        let postImage = selectedImage
        let postText = postTextView.text
        //https://stackoverflow.com/a/44166954/6526058 referenced stack overflow for why I was getting an error when I did $ else postImage == nil & postText != nil. I think I understand what the error is, partly, but not how to work around it. So get ready for some chained if statements :-(
        if postImage == nil && postText == "" {
            self.showOKAlert(title: "Nothing to Post", message: "Please enter a photo OR text to post")
        }
        if postImage == nil && postText != "" {
            //post as text post
            let postRef = self.databaseReference.childByAutoId()
            let timeStamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
            let post = BlogPost(email: email, text: postText, timestamp: timeStamp, type: "Text", userId: email, postId: postRef.key)
            let postDict = ["email": post.email,
                            "text": post.text,
                            "timestamp": post.timestamp,
                            "type": post.type,
                            "postId": post.postId,
                            "userId": post.userId] as [String : Any]
            
            postRef.setValue(postDict, withCompletionBlock: { (error, reference) in
                if let error = error {
                    print(error)
                }
                else {
                    print(reference)
                    self.showOKAlert(title: "Success!", message: "Blog Post Uploaded Successfuly", completion: nil)
                }
            })
        }
        if postImage != nil && postText == "" {
            //post as image post
            if let imageData = UIImageJPEGRepresentation(postImage!, 0.5) {
                
                let postRef = self.databaseReference.childByAutoId()
                let storageReference: FIRStorageReference = FIRStorage.storage().reference(forURL: "gs://ac-32-final-retake.appspot.com/")
                let spaceRef = storageReference.child("images/\(postRef.key)")
                let metadata = FIRStorageMetadata()
                let timeStamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
                
                metadata.cacheControl = "public,max-age=300"
                metadata.contentType = "image/jpeg"
                
                _ = spaceRef.put(imageData, metadata: metadata, completion: { (metadata, error) in
                    if error != nil {
                        print("Error putting image to storage")
                    }
                })
                let post = BlogPost(email: (FIRAuth.auth()?.currentUser?.uid)!, text: "", timestamp: timeStamp, type: "image/jpeg", userId: (FIRAuth.auth()?.currentUser?.uid)!, postId: postRef.key)
                
                let postDict = ["email": post.email!,
                                "text": post.text,
                                "timestamp": post.timestamp,
                                "type": post.type,
                                "userId": post.userId,
                                "postId": post.postId] as [String : Any]
                
                postRef.setValue(postDict, withCompletionBlock: { (error, reference) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print(reference)
                        self.showOKAlert(title: "Success!", message: "Photo Uploaded to Meatly Successfuly", completion: nil)
                    }
                })
                
            }
        }
        
        if postImage != nil && postText != "" {
            self.showOKAlert(title: "Too much to Post", message: "Please enter a photo OR text to post, not both")
        }
    }
    

    @IBAction func postImageTapped(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    //MARK: - ImagePickerController Delegate Method
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.postImageView.contentMode = .scaleAspectFit
            self.postImageView.image = image
            self.selectedImage = image
        }
        self.dismiss(animated: true, completion: nil)
    }

    func setTextView() {
        postTextView.delegate = self
    }
    //MARK: - Helper Functions
    
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
}


