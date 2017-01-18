//
//  NewAccountTableViewController.swift
//  thRED
//
//  Created by Neelesh Shah on 1/10/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit

class NewAccountTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reenterPasswordTextField: UITextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    var imagePickerHelper: ImagePickerHelper!
    var profileImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        setUpUI()
        setUpDelegates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Functionality
    
    func setUpUI() {
        profileImageView.layer.cornerRadius = profileImageView.layer.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
    }
    
    func setUpDelegates() {
        emailAddressTextField.delegate = self
        fullNameTextField.delegate = self
        passwordTextField.delegate = self
        reenterPasswordTextField.delegate = self
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeProfilePhotoButtonTouched() {
        imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
            self.profileImageView.image = image
            self.profileImage = image
        })
        
    }
    
    @IBAction func createNewAccountButtonTouched() {
        if emailAddressTextField.text != "" && fullNameTextField.text != "" && (passwordTextField.text?.characters.count)! >= 6 && (reenterPasswordTextField.text?.characters.count)! >= 6 && profileImage != nil {
            
            let emailAddress = self.emailAddressTextField.text!
            let fullName = self.fullNameTextField.text!
            let passwordTextField = self.passwordTextField.text!
            let reenterPasswordTextField = self.reenterPasswordTextField.text!
            
            if passwordTextField == reenterPasswordTextField {
                //Create and Login user on success
                FirebaseUserOperation.createUser(emailAddress: emailAddress, fullName: fullName, password: passwordTextField, profileImage: profileImage, completion: {(firUser, error) in
                    if let error = error {
                        //AppDelegate.signedInFIRUser = nil
                        //AppDelegate.signedInUser = nil
                        self.showAlert(title: "Error", message: "Cannot create user. \(error.localizedDescription)")
                    } else {
                        //AppDelegate.signedInFIRUser = firUser
                        //FirebaseUserOperation.getUserDetails(firUser: firUser!, completion: { (user) in
                        //    AppDelegate.signedInUser = user
                        //    self.dismiss(animated: true, completion: nil)
                        //})
                        //self.showAlert(title: "Success", message: "New User Account Created")
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            } else {
                self.showAlert(title: "Error", message: "Passwords do not match")
            }
        } else {
            self.showAlert(title: "Error", message: "Please enter email address, full name and matching passwords along with uploading a profile photo")
        }
        
    }
}

extension NewAccountTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailAddressTextField: fullNameTextField.becomeFirstResponder()
        case fullNameTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: reenterPasswordTextField.becomeFirstResponder()
        case reenterPasswordTextField: passwordTextField.resignFirstResponder()
        default: break
        }
        return true
    }
}
