//
//  MyInviteCell.swift
//  thRED
//
//  Created by Neelesh Shah on 1/17/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit

class MyInviteCell: UICollectionViewCell {
    
    @IBOutlet weak var eventSongImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    var event: Event? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        let songid = event?.songID
        eventNameLabel.text = event?.name
        FirebaseImageHandler.downloadImage(ImageType.song, songid!, completion: { (image, error) in
            if let image = image {
                self.eventSongImageView.image = image
            }
        })
    }
}
