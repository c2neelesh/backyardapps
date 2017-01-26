//
//  NotificationTableViewCell.swift
//  thred
//
//  Created by Neelesh Shah on 1/25/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var notificationTextLabel: UILabel!
    @IBOutlet weak var notificationImageView: UIImageView!
    
    var gift: Gift?
    var notification: UserNotification! {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateUI() {
        notificationImageView.layer.cornerRadius = 10
        notificationImageView.layer.masksToBounds = true

        Gift.observeGift(notification.giftID) { (gift) in
            self.gift = gift
            print ("------- \(gift.name)")
            Gifter.observeGifters((gift.uid), { (gifter) in
                if gifter.primary == "yes" {
                    FirebaseImageHandler.downloadImage(.profile, gifter.uid, completion: { (image, error) in
                        if let _ = image {
                            self.notificationImageView.image = image
                        }
                    })
                }
            })
        }
        notificationTextLabel.text = "\(notification.notificationText). (NOTE:This text can be anything we want)"
        
    }
}
