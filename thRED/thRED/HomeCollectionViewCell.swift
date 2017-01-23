//
//  HomeCollectionViewCell.swift
//  thred
//
//  Created by Neelesh Shah on 1/22/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var giftNameLabel: UILabel!
    var gift: Gift? {
        didSet {
            updateUI()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //giftImageView.image = #imageLiteral(resourceName: "happybirthday")
    }
    
    
    func updateUI() {
        let songid = gift?.giftSongID
        //self.giftImageView.image =  #imageLiteral(resourceName: "happybirthday")
        giftNameLabel.text = gift!.name
        FirebaseImageHandler.downloadImage(ImageType.song, songid!, completion: { (image, error) in
            if let image = image {
                self.giftImageView.image = image
            }
        })
    }
}
