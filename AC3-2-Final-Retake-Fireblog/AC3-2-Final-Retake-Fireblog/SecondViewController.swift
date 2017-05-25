//
//  SecondViewController.swift
//  AC3-2-Final-Retake-Fireblog
//
//  Created by Jason Gresh on 4/13/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class SecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    var selectedImage: UIImage?
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
    print("Post button tapped")
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
}


