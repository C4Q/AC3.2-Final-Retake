//
//  blogPostTableViewCell.swift
//  AC3-2-Final-Retake-Fireblog
//
//  Created by C4Q on 5/25/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class blogPostTableViewCell: UITableViewCell {

    @IBOutlet weak var blogPostLabel: UILabel!
    @IBOutlet weak var blogPostImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
