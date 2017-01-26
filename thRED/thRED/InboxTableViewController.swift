//
//  InboxTableViewController.swift
//  thred
//
//  Created by Neelesh Shah on 1/25/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit
import Firebase

class InboxTableViewController: UITableViewController {

    var myNotifications = [UserNotification]()
    //var gifts = [Gift]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.backBarButtonItem?.tintColor = .white

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //gifts.removeAll()
        fetchNotificationsOf(userID: (FIRAuth.auth()?.currentUser?.uid)!)
    }
    
    func fetchNotificationsOf(userID: String) {
        myNotifications.removeAll()
        
        print ("before notifs")
        UserNotification.observeUserNotifications(userID) { (notifs) in
            self.myNotifications.append(notifs)
            /*
            print ("before gifts")
            Gift.observeGiftOnce(notifs.giftID, { (gift) in
                print ("inside gifts")
                self.gifts.append(gift)
                print("Gifts count: \(self.gifts.count)")
                self.view.setNeedsLayout()
            })
            */

            self.tableView.reloadData()
            self.view.setNeedsLayout()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myNotifications.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell

        cell.notification = myNotifications[indexPath.row]
        //cell.textLabel?.text = myNotifications[indexPath.row].notificationText
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "notificationSegue" {
            //print ("2 ****** \(segue.destination.debugDescription)")
            let destinationVC = segue.destination as! GiftTableViewController
            let cell = sender as! NotificationTableViewCell
            //let indexPath = tableView?.indexPath(for: cell)
            //print ("@@@@ \(indexPath) \(gifts.count)")
            print ("++++++++ \(cell.gift?.name)")
            destinationVC.gift = cell.gift // gifts[(indexPath?.row)!]
            destinationVC.navigationItem.title = "Record your song"

            
        }
    }
    
    

}