//
//  GiftCollectionViewCell.swift
//  thred
//
//  Created by Neelesh Shah on 1/21/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit

class GiftCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var lyricsTextView: UITextView!
    @IBOutlet weak var durationLabel: UILabel!
    var giftTableViewController: GiftTableViewController?
    var giftCollectionViewController: GiftCollectionViewController?
    
    var song: Song? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        nameLabel.text = song!.name
        songImageView.image = song?.songImage
        lyricsTextView.text = song?.lyrics
        durationLabel.text = ("duration: \(song!.duration) seconds")
        
    }
    
    @IBAction func selectButtonTouched() {
        giftTableViewController?.giftNameLabel.text = song!.name
        giftTableViewController?.giftImageView.image = song?.songImage
        giftTableViewController?.gift = song
        giftCollectionViewController?.dismiss(animated: true, completion: nil)
    }
}
