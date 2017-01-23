//
//  NewEventTableViewController.swift
//  thRED
//
//  Created by Neelesh Shah on 1/16/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit

class NewEventTableViewController: UITableViewController{

    var eventID: String?
    var event: Event?
    
    //@IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title = "Event"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Event.observeEvent(eventID!) { (event) in
            self.event = event
            self.navigationItem.title = "\(event.name)"
            self.view.setNeedsLayout()
        }

    }
}
