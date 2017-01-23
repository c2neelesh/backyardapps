//
//  FirebaseUserOperation.swift
//  thred
//
//  Created by Neelesh Shah on 1/21/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//


import Foundation
import Firebase

class FirebaseUserOperation {
    
    static func isUserAuthenticated(completion: @escaping (FIRUser?) -> Void) {
        FIRAuth.auth()?.addStateDidChangeListener({ (firAuth, firUser) in
            if firUser != nil {
                completion(firUser)
            } else {
                completion(nil)
            }
        })
    }
    
    static func signIn(email: String, password: String ,completion: @escaping (FIRUser?, Error?) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (firUser, error) in
            if error == nil {
                completion(firUser, nil)
            } else {
                completion(nil, error)
            }
        })
    }
    
    static func signOut () {
        do {
            try FIRAuth.auth()?.signOut()
        } catch {
            // handle if needed
        }
    }
    
    static func createUser(email: String, name: String, password: String , profileImage: UIImage ,completion: @escaping (FIRUser?, Error?) -> Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (firUser, error) in
            if error == nil {
                let newUser = User(uid: (firUser?.uid)!, name: name, status: "created", profileImage: profileImage)
                newUser.save(completion: { (error) in
                    if error == nil {
                        signIn(email: email, password: password, completion: { (firUser, error) in
                            if error == nil {
                                completion(firUser, nil)
                            } else {
                                completion(nil, error) // account + user created, not logged in
                            }
                        })
                    } else {
                        // account created, profile image errors, do we even need this check
                        firUser?.delete(completion: { (error) in
                            //handle if necessary
                        })
                        completion(nil, error)
                    }
                    
                })
            } else {
                completion(nil, error)
            }
            
        })
    }
    
    static func getCurrentUserDetails(completion: @escaping (String?, String?, User?) -> Void) {
        let firuser = FIRAuth.auth()?.currentUser
        if let firUser = firuser {
            let currentUserRef = DatabaseReference.user(uid: firUser.uid).reference()
            
            let _ = currentUserRef.observe(.value, with: { (snapshot) in
                let dict = snapshot.value as? [String : Any] ?? [:]
                //let userProfile = dict["profile"] as? [String : Any] ?? [:]

                let user = User(userDictionaryFromSnapshot: dict, key: firUser.uid)
                //let user = User(userDictionaryFromSnapshot: userProfile, key: snapshot.key)
                
                var userProfileImage: UIImage?
                FirebaseImageHandler.downloadImage(ImageType.profile, firUser.uid, completion: { (image, error) in
                    if let image = image {
                        //print ("********* Profile Image fetched")
                        userProfileImage = image
                    } else {
                        //print ("********* \(error?.localizedDescription)")
                        userProfileImage = #imageLiteral(resourceName: "icon-person")
                    }
                    user.profileImage = userProfileImage
                    completion(firUser.email, firUser.uid, user)
                })
            })
//            User.observeUser(firUser.uid, { (user) in
//                completion(firUser.email, firUser.uid, user)
//            })
        } else {
            completion(nil, nil, nil)
        }
    }
    
}
