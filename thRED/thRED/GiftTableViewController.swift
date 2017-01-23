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
    var gift: Song?
    
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var recipientImageView: UIImageView!
    var recipient: User?
    
    var gifters = [User]()

    @IBOutlet weak var gifterCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        giftImageView.layer.cornerRadius = 10 //giftImageView.layer.frame.width / 2.0
        giftImageView.layer.masksToBounds = true
        recipientImageView.layer.cornerRadius = 10 // giftImageView.layer.frame.width / 2.0
        recipientImageView.layer.masksToBounds = true
        
        //let dummyUser = User(uid: "0", name: "Add Gifter", status: "temporary", profileImage: #imageLiteral(resourceName: "add"))
        //self.gifters.append(dummyUser)

        FirebaseUserOperation.getCurrentUserDetails { (email, uid, user) in
            self.gifters.append(user!)
            DispatchQueue.main.async {
                self.gifterCollectionView.reloadData()
                self.view.setNeedsLayout()
            }

        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.gifterCollectionView.reloadData()
        self.view.setNeedsLayout()
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
    
        let newGift = Gift(name: (gift?.name)!, gifters: giftGifters, giftSongID: (gift?.uid)!, recipientID: (recipient?.uid)!, note: "Please join me to gift the song '\(gift!.name)' to \(recipient!.name)", dueBy: Date())
        
        newGift.save { (giftID) in
            if giftID == nil {
                // error
            } else {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
