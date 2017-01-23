//
//  UserByEmailViewController.swift
//  thred
//
//  Created by Neelesh Shah on 1/22/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit
import Firebase

class UserByEmailViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func inviteButtonTouched() {
        if emailTextField.text != "" && nameTextField.text != "" {
            let email = self.emailTextField.text!
            let name = self.nameTextField.text!
            
            let plistPath = Bundle.main.path(forResource: "SecondaryGoogleService-Info", ofType: "plist")
            let options = FIROptions(contentsOfFile: plistPath!)
            FIRApp.configure(withName: "Secondary", options: options!)
            if let secondaryApp = FIRApp(named: "Secondary") {
                let secondaryAppAuth = FIRAuth(app: secondaryApp)
                secondaryAppAuth?.createUser(withEmail: email, password: "password", completion: { (firUser, error) in
                    if error == nil {
                        let newUser = User(uid: (firUser?.uid)!, name: name, status: "pending", profileImage: #imageLiteral(resourceName: "icon-person"))
                        newUser.save(completion: { (error) in
                            if error == nil {
                                self.dismiss(animated: true, completion: nil)
                            } else {
                                self.showAlert(title: "Error", message: "Cannot create user. \(error!.localizedDescription)")
                            }
                        })
                    } else {
                        self.showAlert(title: "Error", message: "Cannot create user. \(error!.localizedDescription)")
                    }
                })
                
            } else {
                self.showAlert(title: "Error", message: "Firebase issue in creating secondary app for user creation")
            }
       
        } else {
            self.showAlert(title: "Error", message: "Please enter name, email")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
