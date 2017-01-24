//
//  LoginRegisterController.swift
//  thred
//
//  Created by Neelesh Shah on 1/21/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit
import Firebase

class LoginRegisterController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var loginRegisterControl: UISegmentedControl!
    @IBOutlet weak var loginRegisterButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reenterPasswordTextField: UITextField!
    
    var imagePicker: ImagePickerHelper!
    var profileImage: UIImage?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileImage)))
        profileImageView.isUserInteractionEnabled = true
        
        emailTextField.delegate = self
        nameTextField.delegate = self
        passwordTextField.delegate = self
        reenterPasswordTextField.delegate = self
        
        handleLoginRegisterControlChange(for: 0)
        
    }

    func selectProfileImage() {
        imagePicker = ImagePickerHelper(viewController: self, completion: { (image) in
            self.profileImageView.image = image
            self.profileImage = image
        })
    }
    
    func handleLoginRegisterControlChange(for selected: Int) {
        //loginRegisterButton.titleLabel?.text = loginRegisterControl.titleForSegment(at: selected)
        
        if (selected == 0) {
            nameTextField.isHidden = true
            reenterPasswordTextField.isHidden = true
            profileImageView.isHidden = true
            emailTextField.becomeFirstResponder()
        } else {
            nameTextField.isHidden = false
            reenterPasswordTextField.isHidden = false
            profileImageView.isHidden = false
            nameTextField.becomeFirstResponder()
        }
    }

    @IBAction func loginRegisterControlTouched(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        handleLoginRegisterControlChange(for: sender.selectedSegmentIndex)
    }
    
    @IBAction func loginRegisterButtonTouched() {
        if (loginRegisterControl.selectedSegmentIndex == 0) {
            login()
        } else {
            register()
        }
    }
    
    func login() {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if email != "" && password != "" {
            FirebaseUserOperation.signIn(email: email!, password: password!, completion: { (firUser, error) in
                if let error = error {
                    self.showAlert(title: "Error", message: "Login failed \(error.localizedDescription)")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
        } else {
            self.showAlert(title: "Error", message: "Please enter both username and password")
        }
    }
    
    func register() {
        if emailTextField.text != "" && nameTextField.text != "" && (passwordTextField.text?.characters.count)! >= 6 && (reenterPasswordTextField.text?.characters.count)! >= 6 && profileImage != nil {
            
            let emailAddress = self.emailTextField.text!
            let name = self.nameTextField.text!
            let passwordTextField = self.passwordTextField.text!
            let reenterPasswordTextField = self.reenterPasswordTextField.text!
            let profileImage = profileImageView.image!
            
            if passwordTextField == reenterPasswordTextField {
                //Create and Login user on success
                FirebaseUserOperation.createUser(email: emailAddress, name: name, password: passwordTextField, profileImage: profileImage, completion: {(firUser, error) in
                    if let error = error {
                        self.showAlert(title: "Error", message: "Cannot create user. \(error.localizedDescription)")

                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            } else {
                self.showAlert(title: "Error", message: "Passwords do not match")
            }
        } else {
            self.showAlert(title: "Error", message: "Please enter name, email and matching passwords along with uploading a profile photo")
        }
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print ("!23")
        if textField == nameTextField  {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField  {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            if loginRegisterControl.selectedSegmentIndex == 0 {
                passwordTextField.resignFirstResponder()
                login()
            } else {
                reenterPasswordTextField.becomeFirstResponder()
            }
        } else if textField == reenterPasswordTextField {
            reenterPasswordTextField.resignFirstResponder()
            register()
        }
        return true
    }
    
}
