//
//  ProfileTableViewController.swift
//  thRED
//
//  Created by Neelesh Shah on 1/10/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var loadSongsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        profileImageView.layer.cornerRadius = profileImageView.layer.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        FirebaseUserOperation.getCurrentUserDetails { (emailAddress, uid, user) in
            if let email = emailAddress {
                self.emailAddressLabel.text = email
                if email == "neelesh@c2.com" {
                    self.loadSongsButton.isEnabled = true
                } else {
                    self.loadSongsButton.isEnabled = false
                }
            } else {
                self.emailAddressLabel.text  = ""
            }
            
            if let user = user {
                self.fullNameLabel.text = user.fullName
                self.profileImageView.image = user.profileImage
            } else {
                self.fullNameLabel.text = ""
                self.profileImageView.image = nil
            }
            self.view.setNeedsLayout()
         }

 
    }


    @IBAction func signOutButtonTouched(_ sender: UIBarButtonItem) {
        FirebaseUserOperation.signOut()
        self.tabBarController?.selectedIndex = 0
    }

    @IBAction func loadSongsButtonTouched() {

        let songImage = #imageLiteral(resourceName: "happybirthday")
        let songData = Data()
        let song = Song(name: "Happy Birthday",lyrics: "Happy Birthday to You,\nHappy Birthday to You,\nHappy Birthday Dear (name),\nHappy Birthday to You.\n\nFrom good friends and true,\nFrom old friends and new,\nMay good luck go with you,\nAnd happiness too.", duration: 49, artist: "Unknown", about: "Traditional Happy Birthday Song", songImage: songImage, song: songData)
        
        song.saveFile(fileName: "hbd.m4a") { (uid ,error) in
            
            if error != nil {
                print("Error loading song: \(error?.localizedDescription)")
            } else {
                print ("Song loaded")
            }
        }
        
        let songImage2 = #imageLiteral(resourceName: "jesus")
        let songData2 = Data()
        let song2 = Song(name: "The Lord's Prayer Song",lyrics: "Our Father who art in heaven, hallowed be thy name.\nThy kingdom come.\nThy will be done on earth as it is in heaven.\nGive us this day our daily bread,\n  and forgive us our trespasses,\n  as we forgive those who trespass against us,\n  and lead us not into temptation,\n  but deliver us from evil.\nFor thine is the kingdom,\n  and the power, and the glory,\n  for ever and ever.\nAmen.", duration: 133, artist: "Unknown", about: "The Lord's Prayer Song", songImage: songImage2, song: songData2)
        
        song2.saveFile(fileName: "prayer.m4a") { (uid, error) in
            
            if error != nil {
                print("Error loading song: \(error?.localizedDescription)")
            } else {
                print ("Song loaded")
            }
        }
        
        let songImage3 = #imageLiteral(resourceName: "kolaveri")
        let songData3 = Data()
        let song3 = Song(name: "Why this kolaveri di",lyrics: "Yo boys!\nI am singing song\nSoup song\nFlop song\nWhy this kolaveri kolaveri kolaveri di\nWhy this kolaveri kolaveri kolaveri di\n\nRhythm correct?\n\nWhy this kolaveri kolaveri kolaveri di\n\nMaintain please\n\nWhy this kolaveri... di\n\nDistance la moon-u moon-u\nMoon-u color-u white-u\nWhite background night-u night-u\nNight-u color-u black-u\n\nWhy this kolaveri kolaveri kolaveri di\nWhy this kolaveri kolaveri kolaveri di\n\nWhite skin-u girl-u girl-u\nGirl-u heart-u black-u\nEyes-u eyes-u meet-u meet-u\nMy future dark\n\nWhy this kolaveri kolaveri kolaveri di\nWhy this kolaveri kolaveri kolaveri di\n\nMaama notes eduthuko\nApdiye kaila snacks eduthuko\n\nPa pa paan pa pa paan pa pa paa pa pa paan\nSariya vaasi\n\nHaha Haha Haha\n\nSuper maama ready?\nReady 1 2 3 4\n\nWah! What a change over maama\n\nOk maama now tune change-u\n\nKaila glass\nOnly english...\n\nHand la glass\nGlass la scotch\nEyes-u full-aa tear-u\nEmpty life-u\nGirl-u come-u\nLife reverse gear-u\nLove-u love-u\nOh my love-u\nYou showed me bouv-u\nCow-u cow-u holy cow-u\nI want u hear now-u\nGod I m dying now-u\nShe is happy how-u\n\nThis song for soup boys-u\nWe don't have choice-u\n\nWhy this kolaveri kolaveri kolaveri di\nWhy this kolaveri kolaveri kolaveri di\nWhy this kolaveri kolaveri kolaveri di\nWhy this kolaveri kolaveri kolaveri di\n", duration: 248, artist: "Dhanush", about: "Viral song from India", songImage: songImage3, song: songData3)
        
        song3.saveFile(fileName: "kolaveri.m4a") { (uid, error) in
    
            if error != nil {
                print("Error loading song: \(error?.localizedDescription)")
            } else {
                print ("Song loaded")
            }
        }
        
        
    }
    
    
}
