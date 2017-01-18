//
//  UserEvent.swift
//  thRED
//
//  Created by Neelesh Shah on 1/16/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit

class UserEvent {
    var userID: String
    var eventID: String

    init(userID: String, eventID: String) {
        self.userID = userID
        self.eventID = eventID
    }
    
    
    // MARK: - Support functions
    func toDictionary() -> [String : Any] {
        return [
            eventID: "*"
        ]
    }
    
    
    func save(completion: @escaping (Error?) -> Void) {
        let ref = DatabaseReference.userEvent(uid: userID).reference()
        //ref.setValue(toDictionary())
        ref.updateChildValues([eventID: 1])
        completion(nil)
    }
    
    class func observeUserEvent (_ uid: String, _ completion: @escaping (UserEvent) -> Void) {
        let userEventReference = DatabaseReference.userEvent(uid: uid).reference()
        
        userEventReference.observe(.childAdded, with: { (snapshot) in
            //let _ = snapshot.value as? [String : Any] ?? [:]
            completion(UserEvent(userID: uid, eventID: snapshot.key))
            
        })
        
    }
    
}

