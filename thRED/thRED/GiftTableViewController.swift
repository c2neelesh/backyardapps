//
//  GiftTableViewController.swift
//  thred
//
//  Created by Neelesh Shah on 1/21/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit
import Firebase

class GiftTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var recipientImageView: UIImageView!
    @IBOutlet weak var addGifterImageView: UIImageView!
    @IBOutlet weak var gifterCollectionView: UICollectionView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var recordOrPlayButton: UIButton!
    
    var gift: Gift?
    var song: Song?
    var recipient: User?
    var gifters = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        giftImageView.layer.cornerRadius = 10
        giftImageView.layer.masksToBounds = true
        recipientImageView.layer.cornerRadius = 10
        recipientImageView.layer.masksToBounds = true
        if gift == nil {
            FirebaseUserOperation.getCurrentUserDetails { (email, uid, user) in
                self.gifters.append(user!)
                DispatchQueue.main.async {
                    self.gifterCollectionView.reloadData()
                    self.view.setNeedsLayout()
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if gift != nil {
            
            if (gift!.recipientID == FIRAuth.auth()?.currentUser?.uid) {
                self.navigationItem.title = "Play to enjoy your gift"
                self.recordOrPlayButton.setTitle("Play (wip)", for: .normal)
            }
            
            self.sendButton.isHidden = true
            self.addGifterImageView.isHidden = true
            
            Song.observeSong((gift?.giftSongID)!, { song in
                self.song = song
                FirebaseImageHandler.downloadImage(.song, self.gift!.giftSongID, completion: { (image, error) in
                    if let _ = image {
                        self.giftImageView.image = image
                        self.giftNameLabel.text = song.name
                        self.giftImageView.isUserInteractionEnabled = false
                        self.view.setNeedsLayout()

                    }
                })
            })
            User.observeUser(gift!.recipientID, { (user) in
                self.recipientNameLabel.text = user.name
                FirebaseImageHandler.downloadImage(.profile, (self.gift?.recipientID)!, completion: { (image, error) in
                    if let _ = image {
                        self.recipientImageView.image = image
                        self.recipientImageView.isUserInteractionEnabled = false
                        self.view.setNeedsLayout()
                    }
                })
            })
            if self.gifters.count == 0 {
                Gifter.observeGifters((gift?.uid)!, { (gifter) in
                    let userid = gifter.uid
                    User.observeUser(userid, { (user) in
                        self.gifters.append(user)
                        self.gifterCollectionView.reloadData()
                        self.view.setNeedsLayout()
                    })
                })
            }
            
            
        } else {
            self.gifterCollectionView.reloadData()
            self.view.setNeedsLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifterCell", for: indexPath) as! GifterCollectionViewCell
        cell.gifter = gifters[indexPath.item]
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "giftSegue" {
            let destinationVC = segue.destination as! UINavigationController
            let giftCollectionViewController = destinationVC.topViewController as! GiftCollectionViewController
            giftCollectionViewController.giftTableViewController = self
        } else if segue.identifier == "recipientSegue" {
            let destinationVC = segue.destination as! UINavigationController
            let recipientTableViewController = destinationVC.topViewController as! RecipientTableViewController
            recipientTableViewController.giftTableViewController = self
        } else if segue.identifier == "gifterSegue" {
            let destinationVC = segue.destination as! UINavigationController
            let recipientTableViewController = destinationVC.topViewController as! GifterTableViewController
            recipientTableViewController.giftTableViewController = self
        }
    }

    
    @IBAction func createGiftAndInvite() {
        
        var giftGifters = [Gifter]()
        
        for i in 0..<gifters.count {
            let giftGifter = self.gifters[i]
            let g = Gifter(uid: giftGifter.uid, status: "invited", primary: i == 0 ? "yes" : "no", date: Date(), song: Data())
            giftGifters.append(g)
        }
    
        let newGift = Gift(name: (song?.name)!, gifters: giftGifters, giftSongID: (song?.uid)!, recipientID: (recipient?.uid)!, note: "Please join me to gift the song '\(song!.name)' to \(recipient!.name)", dueBy: Date())
        
        newGift.save { (giftID) in
            if giftID == nil {
                // error
            } else {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
