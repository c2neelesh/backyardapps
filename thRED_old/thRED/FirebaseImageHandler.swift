//
//  FirebaseImageHandler.swift
//  thRED
//
//  Created by Neelesh Shah on 1/10/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import Foundation
import Firebase

enum ImageType {
    case profile
    case song
    case prayer
}

class FirebaseImageHandler {
    var image: UIImage
    var downloadURL: URL?
    var downloadURLString: String!
    var ref: FIRStorageReference!
    
    init(image: UIImage) {
        self.image = image
    }
}

// MARK: - Extensions
extension FirebaseImageHandler {
    
    func saveImage(_ type: ImageType, _ uid: String, _ completion: @escaping (Error?) -> Void) {
        
        let resizedImage = image.resizedForFirebase(withHeight: 800)
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.9)
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        switch type {
        case .profile: ref = StorageReference.profileImage.reference().child(uid)
        case .song: ref = StorageReference.songImage.reference().child(uid)
        case .prayer: ref = StorageReference.prayerImage.reference().child(uid)
        }
    
        //ref = StorageReference.profileImage.reference().child(userUID)
        downloadURLString = ref.description
        
        ref.put(imageData!, metadata: metadata) { (meta, error) in
            //print ("Error from FirebaseImage.saveProfileImage. \(error.debugDescription)")
            completion(error)
        }
    }
    
    class func downloadImage(_ type: ImageType, _ uid: String, completion: @escaping (UIImage? ,Error?) -> Void) {
        
        let classRef: FIRStorageReference!
        
        switch type {
        case .profile: classRef = StorageReference.profileImage.reference().child(uid)
        case .song: classRef = StorageReference.songImage.reference().child(uid)
        case .prayer: classRef = StorageReference.prayerImage.reference().child(uid)
        }
        
        //StorageReference.profileImage.reference().child(userUID).data(withMaxSize: 1 * 1024 * 1024) { (imageData, error) in
        classRef.data(withMaxSize: 1 * 1024 * 1024) { (imageData, error) in
            if error == nil && imageData != nil {
                let image = UIImage(data: imageData!)
                completion (image ,nil)
            } else {
                completion(nil, error)
            }
        }
    }
}


// MARK: - Private UI Extensions
private extension UIImage {
    
    func resizedForFirebase(withHeight: CGFloat) -> UIImage {
        let height: CGFloat = withHeight
        let ratio = self.size.width / self.size.height
        let width = height * ratio
        
        let newSize = CGSize(width: width, height: height)
        let newRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: newRect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}
