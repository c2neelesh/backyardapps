//
//  Event.swift
//  thRED
//
//  Created by Neelesh Shah on 1/14/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit

class Event {
    //let uid: String
    var name: String
    var gifters: [Gifter]?
    var songID: String
    var note: String
    var dueBy: Date
    //var cogifters: [String]
    
    
    //init(uid: String, name: String, gifter: String, about: String, dueBy: Date) {
    init(name: String, gifters: [Gifter]?, songID: String, note: String, dueBy: Date) {
        //self.uid = uid
        self.name = name
        self.gifters = gifters
        self.songID = songID
        self.note = note
        self.dueBy = dueBy
        //self.cogifters = cogifters
    }
    
    init(eventDictionaryFromSnapshot: [String : Any]) {
        //self.uid = eventDictionaryFromSnapshot["uid"] as! String
        self.name = eventDictionaryFromSnapshot["name"] as! String
        self.songID = eventDictionaryFromSnapshot["songID"] as! String
        self.note = eventDictionaryFromSnapshot["note"] as! String
        
        let dueByString = eventDictionaryFromSnapshot["dueBy"] as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        self.dueBy = dateFormatter.date(from: dueByString)!
        
        self.gifters = []
        //if let giftersDict = eventDictionaryFromSnapshot["gifters"] as? [String : Any] {
            
        //}
    }
    
    // MARK: - Support functions
    func toDictionary() -> [String : Any] {

        return [
            //"uid": uid,
            "name": name,
            "songID": songID,
            "note": note,
            "dueBy": DateFormatter.localizedString(from: dueBy, dateStyle: .medium, timeStyle: .none),
            "recipientID": "WIP - This will be filled up with a User ID"
            
        ]
    }

    func save(completion: @escaping (String?) -> Void) {
        //let ref = DatabaseReference.event(uid: uid).reference()
        let ref = DatabaseReference.allEvents.reference()
        let eventRef = ref.childByAutoId()
        eventRef.setValue(toDictionary())
        completion(eventRef.key)
    }
    
    class func observeEvent (_ uid: String, _ completion: @escaping (Event) -> Void) {
        let eventReference = DatabaseReference.event(uid: uid).reference()
        
        eventReference.observe(.value, with: { (snapshot) in
            let event = snapshot.value as? [String : Any] ?? [:]
            completion(Event(eventDictionaryFromSnapshot: event))
            
        })
    }
}

