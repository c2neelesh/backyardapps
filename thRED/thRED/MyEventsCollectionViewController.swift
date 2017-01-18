//
//  MyEventsCollectionViewController.swift
//  thRED
//
//  Created by Neelesh Shah on 1/17/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "myInviteCell"

class MyEventsCollectionViewController: UICollectionViewController {
    
    var myEvents = [UserEvent]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(MyInviteCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        fetchEventsOf(uid: (FIRAuth.auth()?.currentUser?.uid)!)

        // Do any additional setup after loading the view.
    }

    func fetchEventsOf(uid: String) {
        UserEvent.observeUserEvent(uid) { (userEvent) in
            self.myEvents.append(userEvent)
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                self.view.setNeedsLayout()
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return myEvents.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyInviteCell
    
        // Configure the cell
        //cell.eventSongImageView.image =  #imageLiteral(resourceName: "kolaveri")
        Event.observeEvent(myEvents[indexPath.item].eventID) { (event) in
            cell.event = event
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
