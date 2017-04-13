//
//  UploadViewController.swift
//  AC3-2-Final-Retake-Fireblog
//
//  Created by Erica Y Stevens on 4/13/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Stored Properties
    var imagePicker = UIImagePickerController()
    var databaseReference: FIRDatabaseReference!
    var storageReference: FIRStorageReference!
    fileprivate var _authHandle: FIRAuthStateDidChangeListenerHandle!
    var user: FIRUser?
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .lightGray
        
        setupViewHierarchy()
        configureConstraints()
        configureImagePicker()
        configureNavigationBarButtonItem()
        checkForLoggedInUser()
    }
    
    // MARK: View Hierarchy and Constraints
    
    func setupViewHierarchy() {
        self.view.addSubview(imageView)
        self.view.addSubview(orLabel)
        self.view.addSubview(textField)
    }
    
    func configureConstraints() {
        let _ = [
            imageView.widthAnchor.constraint(equalToConstant: 275),
            imageView.heightAnchor.constraint(equalToConstant: 275),
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 35),
            
            orLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5),
            orLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            orLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 5),
            
            textField.widthAnchor.constraint(equalToConstant: 275),
            textField.heightAnchor.constraint(equalToConstant: 275),
            textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            textField.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -20)
        
            ].map{ $0.isActive = true }
    }
    
    // MARK: Lazy Instantiation

    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .white
        iv.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (chooseImageToUpload(_:)))
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    lazy var textField: UITextField = {
       let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        return tf
    }()
    
    lazy var orLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "-or-"
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium)
        return label
    }()
    
    // MARK: Configuration
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = [kUTTypeImage as String]
    }
    
    func configureNavigationBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(uploadPostToDatabase(_:)))
    }
    
    // MARK: Target Action Methods
    
    func chooseImageToUpload(_ sender: UIImageView) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func uploadPostToDatabase(_ sender: UIBarButtonItem) {
        if imageView.image != nil && textField.text != "" {
            let alertController = UIAlertController(title: "Cannot Upload Both Post Types", message: "Please choose either an image or some text to upload. Not both", preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertController.addAction(okayAction)
            
            self.present(alertController, animated: true) {
                self.imageView.image = nil
                self.textField.text = nil
            }
            
        }
        if imageView.image != nil && textField.text == "" {
            //upload image to storage and database
            if let data = UIImageJPEGRepresentation(imageView.image!, 0.8) {
                self.sendPhotoPostToStorage(photoData: data)
            }
        }
        
        if imageView.image == nil && (textField.text?.characters.count)! > 0 {
            sendTextPostToDatabase(textField.text!)
        }
    }
    
    // MARK: Firebase
    
    func sendPhotoPostToStorage(photoData: Data) {
        guard let user = self.user else { return }
        
        databaseReference = FIRDatabase.database().reference(fromURL: "https://ac-32-final-retake.firebaseio.com/")
        
        let postsDatabaseRef = databaseReference.child("posts/")
        
        let imagePostKeyAndRef = postsDatabaseRef.childByAutoId()
        
        print("KEY?: \(imagePostKeyAndRef.key)")
        
        storageReference = FIRStorage.storage().reference(forURL: "gs://ac-32-final-retake.appspot.com/")
        
        let imagesStorageRef = storageReference.child("images/\(imagePostKeyAndRef.key)")
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        metadata.cacheControl = "public,max-age=300"
        
        imagesStorageRef.put(photoData, metadata: metadata) { (metadata, error) in
            if error != nil {
                print("Error uploading photo data to storage: \(error)")
            }
        }
        imagePostKeyAndRef.setValue(["email" : "\(user.email!)",
            "text" : "",
            "timestamp" : NSDate.timeIntervalSinceReferenceDate,
            "type": PostType.image.rawValue])
        showUploadSuccessAlert()
        
    }
    
    func sendTextPostToDatabase(_ text: String) {
        guard let user = self.user else { return }
        
        databaseReference = FIRDatabase.database().reference(fromURL: "https://ac-32-final-retake.firebaseio.com/")
        
        let postsDatabaseRef = databaseReference.child("posts/")
        
        let textPostRef = postsDatabaseRef.childByAutoId()
        
        textPostRef.updateChildValues(["email" : user.email!,
            "text" : text,
            "timestamp" : NSDate.timeIntervalSinceReferenceDate,
            "type" : PostType.text.rawValue]) { (error, ref) in
                if error != nil {
                    print("Error uploading text post to database: \(error)")
                }
        }
        showUploadSuccessAlert()
    }
    
    func checkForLoggedInUser() {
        _authHandle = FIRAuth.auth()?.addStateDidChangeListener({ (auth: FIRAuth?, user: FIRUser?) in
            if let activeUser = user {
                self.user = activeUser
            }
        })
    }
    
    func showUploadSuccessAlert() {
        let alertController = UIAlertController(title: "Upload Successful!", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        textField.text = nil
        imageView.image = nil
    }
    
    // MARK: ImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }

}
