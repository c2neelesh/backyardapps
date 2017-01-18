//
//  SignInTableViewController.swift
//  thRED
//
//  Created by Neelesh Shah on 1/10/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit

class SignInTableViewController: UITableViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        setupDelegates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Setup
    func setupDelegates() {
        emailAddressTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - UI Functionality
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signInButtonTouched() {
        let emailAddress = emailAddressTextField.text
        let password = passwordTextField.text
        
        if emailAddress != "" && password != "" {
            
            FirebaseUserOperation.signIn(emailAddress: emailAddress!, password: password!, completion: { (firUser, error) in
                if let error = error {
                    //AppDelegate.signedInFIRUser = nil
                    //AppDelegate.signedInUser = nil
                    self.showAlert(title: "Error", message: "Login failed \(error.localizedDescription)")
                } else {
                    //AppDelegate.signedInFIRUser = firUser!
                    //FirebaseUserOperation.getUserDetails(firUser: firUser!, completion: { (user) in
                        //AppDelegate.signedInUser = user
                        //self.dismiss(animated: true, completion: nil)
                    //})
                    self.dismiss(animated: true, completion: nil)
                }

            })
        } else {
            self.showAlert(title: "Error", message: "Please enter both username and password")
        }
    }
    
}

extension SignInTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailAddressTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: passwordTextField.resignFirstResponder()
        default: break
        }
        return true;
    }
}
