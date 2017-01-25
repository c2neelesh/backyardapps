//
//  Gift.swift
//  thred
//
//  Created by Neelesh Shah on 1/22/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit

class Gift {
    let uid: String
    var name: String
    var giftSongID: String
    var recipientID: String
    var gifters: [Gifter]?
    var note: String
    var dueBy: Date


    init(name: String, gifters: [Gifter]?, giftSongID: String, recipientID: String, note: String, dueBy: Date) {
        self.uid = ""
        self.name = name
        self.giftSongID = giftSongID
        self.recipientID = recipientID
        self.gifters = gifters
        self.note = note
        self.dueBy = dueBy
    }
    
    init(giftDictionaryFromSnapshot: [String : Any], key: String) {
        self.uid = key // giftDictionaryFromSnapshot["uid"] as! String
        self.name = giftDictionaryFromSnapshot["name"] as! String
        self.giftSongID = giftDictionaryFromSnapshot["giftSongID"] as! String
        self.recipientID = giftDictionaryFromSnapshot["recipientID"] as! String
        
        self.gifters = []
        
        self.note = giftDictionaryFromSnapshot["note"] as! String
        
        let dueByString = giftDictionaryFromSnapshot["dueBy"] as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        self.dueBy = dateFormatter.date(from: dueByString)!
    }
    
    // MARK: - Support functions
    func toDictionary() -> [String : Any] {
        
        return [
            "name": name,
            "giftSongID": giftSongID,
            "recipientID": recipientID,
            "note": note,
            "dueBy": DateFormatter.localizedString(from: dueBy, dateStyle: .medium, timeStyle: .none)
        ]
    }
    
    func save(completion: @escaping (String?) -> Void) {
        //let ref = DatabaseReference.event(uid: uid).reference()
        let ref = DatabaseReference.gifts.reference()
        let giftsRef = ref.childByAutoId()
        giftsRef.setValue(toDictionary())
        
        for g in gifters! {
            g.save(giftID: giftsRef.key, completion: { (gifterKey) in
            })
        }
        let r = UserGift(userID: recipientID, giftID: giftsRef.key)
        r.save(type: .received) { (error) in
            
        }

        completion(giftsRef.key)
    }
    
    class func observeGift (_ uid: String, _ completion: @escaping (Gift) -> Void) {
        let giftReference = DatabaseReference.gift(uid: uid).reference()
        
        giftReference.removeAllObservers()
        
        giftReference.observe(.value, with: { (snapshot) in
            let gift = snapshot.value as? [String : Any] ?? [:]
            completion(Gift(giftDictionaryFromSnapshot: gift, key: snapshot.key))
            
        })
    }
}


