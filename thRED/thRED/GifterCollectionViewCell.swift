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
        gifterImageView.layer.cornerRadius = 10
        gifterImageView.layer.masksToBounds = true
        
        FirebaseImageHandler.downloadImage(.profile, (gifter?.uid)!, completion: { (image, error) in
            if let _ = image {
                self.gifterImageView.image = image
                //self.view.setNeedsLayout()
            }
        })
        
        //gifterImageView.image = gifter!.profileImage
        
        gifterNameLabel.text = gifter!.name
    }
    
}
