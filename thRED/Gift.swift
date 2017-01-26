//
//  Gift.swift
//  thred
//
//  Created by Neelesh Shah on 1/22/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit
import Firebase
//Sent status to be implemented and used later
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
        print ("returning gift")
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
                let notificationText = (g.primary == "yes"  && FIRAuth.auth()?.currentUser?.uid == g.uid) ? "You have created a gift to a friend. Touch for details" : "You are invited to gift a song to a friend. Touch for details"
                let notification = UserNotification(userID: g.uid, notificationText: notificationText, giftID: giftsRef.key)
                
                notification.save(completion: { (error) in
                    // later
                })
            })
        }
        // do this on send not create + add notifs
        //let r = UserGift(userID: recipientID, giftID: giftsRef.key)
        //r.save(type: .received) { (error) in
        //}

        completion(giftsRef.key)
    }
    
    class func send (uid: String, completion: @escaping (Error?) -> Void) {
        let giftReference = DatabaseReference.gift(uid: uid).reference()
        
        let statusReference = DatabaseReference.gift(uid: uid).reference().child("status")
        statusReference.setValue("sent")
        
        giftReference.observeSingleEvent(of: .value, with: { (snapshot) in
            let gift = snapshot.value as? [String : Any] ?? [:]
            print ("**** \(gift.debugDescription)")
            let sentGift = Gift(giftDictionaryFromSnapshot: gift, key: snapshot.key)
            //do this on send not create + add notifs
            let r = UserGift(userID: sentGift.recipientID, giftID: uid)
            r.save(type: .received) { (error) in
            
            }
            let notification = UserNotification(userID: sentGift.recipientID, notificationText: "You have received a gift. Touch for Details", giftID: uid)
            
            notification.save(completion: { (error) in
                completion(nil)
            })
            
        })
        
        
    }
    
    
    class func observeGift (_ uid: String, _ completion: @escaping (Gift) -> Void) {
        let giftReference = DatabaseReference.gift(uid: uid).reference()
        
        giftReference.removeAllObservers()
        
        giftReference.observe(.value, with: { (snapshot) in
            let gift = snapshot.value as? [String : Any] ?? [:]
            print ("**** \(gift.debugDescription)")
            completion(Gift(giftDictionaryFromSnapshot: gift, key: snapshot.key))
            
        })
    }
    
    class func observeGiftOnce (_ uid: String, _ completion: @escaping (Gift) -> Void) {
        let giftReference = DatabaseReference.gift(uid: uid).reference()
        
        //giftReference.removeAllObservers()
        
        giftReference.observeSingleEvent(of: .value, with: { (snapshot) in
            let gift = snapshot.value as? [String : Any] ?? [:]
            print ("**** \(gift.debugDescription)")
            completion(Gift(giftDictionaryFromSnapshot: gift, key: snapshot.key))
            
        })
    }
}


