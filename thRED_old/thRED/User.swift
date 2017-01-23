//
//  User.swift
//  thRED
//
//  Created by Neelesh Shah on 1/10/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit

class User {
    let uid: String
    var fullName: String
    var status: String
    var profileImage: UIImage?
    
    // MARK: - Initializers
    
    init(uid: String, fullName: String, status: String, profileImage: UIImage?) {
        self.uid = uid
        self.fullName = fullName
        self.status = status
        self.profileImage = profileImage
    }
    
    init(userDictionaryFromSnapshot: [String : Any]) {
        self.uid = userDictionaryFromSnapshot["uid"] as! String
        self.fullName = userDictionaryFromSnapshot["fullName"] as! String
        self.status = userDictionaryFromSnapshot["status"] as! String

        if let _ = userDictionaryFromSnapshot["profileImageURL"] {
            FirebaseImageHandler.downloadImage(ImageType.profile, self.uid, completion: { (image, error) in
                if image != nil {
                    self.profileImage = image
                }
            })
        }
    }
    
    // MARK: - Support functions
    func toDictionary() -> [String : Any] {
        return [
            "uid": uid,
            "fullName": fullName,
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
}
