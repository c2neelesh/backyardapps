//
//  User.swift
//  thred
//
//  Created by Neelesh Shah on 1/21/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit

class User {
    let uid: String
    var name: String
    var status: String
    var profileImage: UIImage?
    
    // MARK: - Initializers
    
    init(uid: String, name: String, status: String, profileImage: UIImage?) {
        self.uid = uid
        self.name = name
        self.status = status
        self.profileImage = profileImage
    }
    
    init(userDictionaryFromSnapshot: [String : Any] ,key: String) {
        self.uid = key //userDictionaryFromSnapshot["uid"] as! String
        self.name = userDictionaryFromSnapshot["name"] as! String
        self.status = userDictionaryFromSnapshot["status"] as! String
        if let _ = userDictionaryFromSnapshot["profileImageURL"] {
            FirebaseImageHandler.downloadImage(ImageType.profile, self.uid, completion: { (image, error) in
                if image != nil {
                    self.profileImage = image
                } else {
                    self.profileImage = #imageLiteral(resourceName: "icon-person")
                }
            })
        }
    }
    
    // MARK: - Support functions
    func toDictionary() -> [String : Any] {
        return [
            "name": name,
            "status": status
        ]
    }
    
    func save(completion: @escaping (Error?) -> Void) {
        let ref = DatabaseReference.user(uid: uid).reference()
        ref.setValue(toDictionary())
        // Set profile image
        if let profileImage = self.profileImage {
            let firebaseImage = FirebaseImageHandler(image: profileImage)
            firebaseImage.saveImage(ImageType.profile, uid, { (error) in
                if error == nil {
                    ref.child("profileImageURL").setValue(firebaseImage.downloadURLString)
                    completion(nil)
                } else {
                    completion(error)
                }
            })
        }
    }
    
    
    class func observeUser (_ uid: String, _ completion: @escaping (User) -> Void) {
        let usersRef = DatabaseReference.user(uid: uid).reference()
        
        usersRef.observe(.value, with: { (snapshot) in
            
            let user = snapshot.value as? [String : Any] ?? [:]
            //let userProfile = user["profile"] as? [String : Any] ?? [:]
            completion(User(userDictionaryFromSnapshot: user, key: snapshot.key))
            
        })
    }
    // Short cut
    class func observeUsers (_ completion: @escaping (User) -> Void) {
        let usersRef = DatabaseReference.users.reference()
        
        usersRef.observe(.childAdded, with: { (snapshot) in
            let user = snapshot.value as? [String : Any] ?? [:]
            let userProfile = user["profile"] as? [String : Any] ?? [:]
            completion(User(userDictionaryFromSnapshot: userProfile, key: snapshot.key))
            
        })
    }
    
    

}

