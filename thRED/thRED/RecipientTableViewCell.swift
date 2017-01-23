//
//  RecipientTableViewCell.swift
//  thred
//
//  Created by Neelesh Shah on 1/21/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit

class RecipientTableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var user: User? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        userNameLabel.text = user!.name
        FirebaseImageHandler.downloadImage(.profile, user!.uid) { (image, error) in
            if let _ = image {
                self.profileImageView.image = image

            } else {
                self.profileImageView.image = #imageLiteral(resourceName: "icon-person")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 10 // profileImageView.layer.frame.width / 2.0
        profileImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
