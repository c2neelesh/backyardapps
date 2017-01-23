//
//  GifterCollectionViewCell.swift
//  thred
//
//  Created by Neelesh Shah on 1/21/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit

class GifterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gifterImageView: UIImageView!
    @IBOutlet weak var gifterNameLabel: UILabel!
    
    var gifter: User? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        gifterImageView.layer.cornerRadius = 10 // gifterImageView.layer.frame.width / 2.0
        gifterImageView.layer.masksToBounds = true
        gifterImageView.image = gifter!.profileImage
        gifterNameLabel.text = gifter?.name
    }
    
}
