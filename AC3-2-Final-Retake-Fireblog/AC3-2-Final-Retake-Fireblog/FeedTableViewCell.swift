//
//  FeedTableViewCell.swift
//  AC3-2-Final-Retake-Fireblog
//
//  Created by Erica Y Stevens on 4/13/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewHierarchy()
        configureConstraints()
        self.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupViewHierarchy() {
        self.contentView.addSubview(userEmailLabel)
        self.contentView.addSubview(timestampLabel)
    }
    
    func configureConstraints() {
        let _ = [
            userEmailLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
            userEmailLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8.0),
            userEmailLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.4),
            userEmailLabel.bottomAnchor.constraint(equalTo: timestampLabel.topAnchor, constant: -8.0),
            
            timestampLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.4),
            timestampLabel.topAnchor.constraint(equalTo: userEmailLabel.bottomAnchor, constant: 8.0),
            timestampLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8.0)
        ].map{ $0.isActive = true }
        
    }
    
    // MARK: Lazy Instantiation
    
    lazy var userEmailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timestampLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var postTextLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var postImageView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        return iv
    }()

}
