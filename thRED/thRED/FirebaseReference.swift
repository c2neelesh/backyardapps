//
//  FirebaseReference.swift
//  thred
//
//  Created by Neelesh Shah on 1/21/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import Foundation
import Firebase

enum DatabaseReference {
    case root
    case user(uid: String)
    case users
    case song(uid: String)
    case songs
    
    case gift(uid: String)
    case gifts
    
    case gifters(giftid: String)
    case gifter(giftid: String, gifterid: String)
    
    case userGifts(uid: String)
    case myGifts(uid: String)

    private var rootRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    private var path: String {
        switch self {
        case .root: return ""
        case .user(let uid):return "users/\(uid)/profile"
        case .users: return "users"
            
        case .song(let uid): return "songs/\(uid)"
        case .songs: return "songs"
            
        case .gift(let uid): return "gifts/\(uid)"
        case .gifts: return "gifts"
            
        case .gifters(let giftid): return "/gifts/\(giftid)/gifters"
        case .gifter(let giftid, let gifterid): return "/gifts/\(giftid)/gifters/\(gifterid)"
            
        case .userGifts(let uid): return "users/\(uid)/gifts/invited"
        case .myGifts(let uid): return "users/\(uid)/gifts/received"
        }
        
    }
    
    func reference() -> FIRDatabaseReference {
        return rootRef.child(path)
    }
}

enum StorageReference {
    case root
    case songImages
    case profileImages
    case songs
    case giftedSongs
    
    
    private var storageRef: FIRStorageReference {
        return FIRStorage.storage().reference()
    }
    
    private var path: String {
        switch self {
        case .root: return ""
        case .songImages: return "songImages"
        case .profileImages: return "profileImages"
        case .songs: return "songs"
        case .giftedSongs: return "giftedSongs"
        }
    }
    
    func reference() -> FIRStorageReference {
        return storageRef.child(path)
    }
}

