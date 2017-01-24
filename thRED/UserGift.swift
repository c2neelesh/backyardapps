//
//  UserGift.swift
//  thred
//
//  Created by Neelesh Shah on 1/22/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit
import Firebase

enum GiftType {
    case invited
    case received
}

class UserGift {
    var userID: String
    var giftID: String
    
    init(userID: String, giftID: String) {
        self.userID = userID
        self.giftID = giftID
    }
    
    
    // MARK: - Support functions
    func toDictionary() -> [String : Any] {
        return [
            giftID: "*"
        ]
    }
    
    
    func save(type: GiftType, completion: @escaping (Error?) -> Void) {
        var ref: FIRDatabaseReference!
        
        switch type {
        case .invited: ref = DatabaseReference.userGifts(uid: userID).reference()
        case .received: ref = DatabaseReference.myGifts(uid: userID).reference()
        }
        
        //ref = DatabaseReference.userGifts(uid: userID).reference()
        //ref.setValue(toDictionary())
        ref.updateChildValues([giftID: 1])
        completion(nil)
    }
    
    class func observeUserGifts (_ type: GiftType, _ uid: String, _ completion: @escaping (UserGift) -> Void) {
        let userGiftReference: FIRDatabaseReference!
        
        switch type {
        case .invited: userGiftReference = DatabaseReference.userGifts(uid: uid).reference()
        case .received: userGiftReference = DatabaseReference.myGifts(uid: uid).reference()
        }
        userGiftReference.removeAllObservers()

        userGiftReference.observe(.childAdded, with: { (snapshot) in
            //let _ = snapshot.value as? [String : Any] ?? [:]
            //print("snap: \(userGiftReference.description) \(snapshot.key)")
            completion(UserGift(userID: uid, giftID: snapshot.key))
            
        })
        
    }
    
}


