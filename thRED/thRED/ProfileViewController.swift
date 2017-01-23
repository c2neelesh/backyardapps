//
//  ProfileViewController.swift
//  thred
//
//  Created by Neelesh Shah on 1/21/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseUserOperation.getCurrentUserDetails { (email, uid, user) in
            
            if let email = email {
                self.emailLabel.text = email
            } else {
                self.emailLabel.text  = ""
            }
            
            if let user = user {
                self.nameLabel.text = user.name
                self.profileImageView.image = user.profileImage
            } else {
                self.nameLabel.text = ""
                self.profileImageView.image = nil
            }
            self.view.setNeedsLayout()
        
        }
    }
    
    @IBAction func logoutButtonPressed() {
        FirebaseUserOperation.signOut()
        self.tabBarController?.selectedIndex = 0
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
