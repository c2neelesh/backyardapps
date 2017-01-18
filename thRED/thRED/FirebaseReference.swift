//
//  FirebaseReference.swift
//  thRED
//
//  Created by Neelesh Shah on 1/10/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

// ALL PRAYER REFERENCES FOR FUTURE RELEASE

import Foundation
import Firebase

enum DatabaseReference {
    case root
    case user(uid: String)
    case song(uid: String)
    case songLibrary
    
    case prayer(uid: String)
    case prayerLibrary
    
    case event(uid: String)
    case gifters(eventid: String)
    case gifter(eventid: String, gifterid: String)
    case allEvents
    case userEvent(uid: String)
    case userInvited(uid: String)

    private var rootRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    private var path: String {
        switch self {
        case .root: return ""
        case .user(let uid): return "user/\(uid)"
            
        case .song(let uid): return "songLibrary/\(uid)"
        case .songLibrary: return "songLibrary"
            
        case .prayer(let uid): return "prayerLibrary/\(uid)"
        case .prayerLibrary: return "prayerLibrary"
            
        case .event(let uid): return "event/\(uid)"
        case .gifters(let eventid): return "/event/\(eventid)/gifters"
        case .gifter(let eventid, let uid): return "/event/\(eventid)/gifters/\(uid)"
        case .allEvents: return "event"
        case .userEvent(let uid): return "userEvent/\(uid)"
        case .userInvited(let uid): return "userInvited/\(uid)"
        }
        
    }
    
    func reference() -> FIRDatabaseReference {
        return rootRef.child(path)
    }
}

enum StorageReference {
    case root
    case songImage
    case prayerImage
    case profileImage
    case songLibrary
    case prayerLibrary
    case gifterSong

    
    private var storageRef: FIRStorageReference {
        return FIRStorage.storage().reference()
    }
    
    private var path: String {
        switch self {
        case .root: return ""
        case .songImage: return "songImage"
        case .prayerImage: return "prayerImage"
        case .profileImage: return "profileImage"
        case .songLibrary: return "songLibrary"
        case .prayerLibrary: return "prayerLibrary"
        case .gifterSong: return "gifterSong"
        }
    }
    
    func reference() -> FIRStorageReference {
        return storageRef.child(path)
    }
}

