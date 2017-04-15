//
//  Post.swift
//  AC3-2-Final-Retake-Fireblog
//
//  Created by Erica Y Stevens on 4/13/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation
import UIKit

class Post {
    var madeByUserWithEmail: String
    var type: String
    var timestamp: Double
    var postID: String //used as storage key for images
    var text: String?
    var image: UIImage?
    
    init(email: String, type: String, timestamp: Double, postID: String, text: String?, image: UIImage?) {
        self.madeByUserWithEmail = email
        self.type = type
        self.timestamp = timestamp
        self.postID = postID
        self.text = text ?? nil
        self.image = image ?? nil
    }
}
