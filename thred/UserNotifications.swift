//
//  UserNotifications.swift
//  thred
//
//  Created by Neelesh Shah on 1/25/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit
import Firebase

class UserNotification {
    
    var userID: String
    var notificationID: String
    var notificationText: String
    var giftID: String
    var date: Date =  Date()
    
    init(userID: String, notificationText: String ,giftID: String) {
        self.userID = userID
        self.notificationID = ""
        self.notificationText = notificationText
        self.giftID = giftID
    }
    
    
    // MARK: - Support functions
    func toDictionary() -> [String : Any] {
        return [
            "notificationText": self.notificationText,
            "giftID": self.giftID,
            "date": DateFormatter.localizedString(from: self.date, dateStyle: .medium, timeStyle: .medium)
        ]
    }
    
    
    func save(completion: @escaping (Error?) -> Void) {
        var ref: FIRDatabaseReference!
        
        ref = DatabaseReference.userNotifications(userid: self.userID).reference().childByAutoId()
        ref.setValue(toDictionary())
        completion(nil)
    }
    
    
    init(userNotificationsFromSnapshot: [String : Any] ,key: String, userID: String) {
        self.userID = userID
        self.notificationID = key // userDictionaryFromSnapshot["notificationID"] as! String
        self.notificationText = userNotificationsFromSnapshot["notificationText"] as! String
        self.giftID = userNotificationsFromSnapshot["giftID"] as! String
        
        let dateString = userNotificationsFromSnapshot["date"] as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        self.date = dateFormatter.date(from: dateString)!
    }

    
    
    class func observeUserNotifications (_ uid: String, _ completion: @escaping (UserNotification) -> Void) {
        let userNotificationsRef: FIRDatabaseReference!
    
        userNotificationsRef = DatabaseReference.userNotifications(userid: uid).reference()
        userNotificationsRef.removeAllObservers()
        
        userNotificationsRef.observe(.childAdded, with: { (snapshot) in
            let notification = snapshot.value as? [String : Any] ?? [:]
            //print("snap: \(userNotificationsRef.debugDescription) ****** \(notification.debugDescription)")
            completion(UserNotification(userNotificationsFromSnapshot: notification, key: uid, userID: uid))
        })
        
    }
    
}



