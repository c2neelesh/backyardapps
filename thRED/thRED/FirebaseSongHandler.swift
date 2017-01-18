//
//  FirebaseSongHandler.swift
//  thRED
//
//  Created by Neelesh Shah on 1/10/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//


import Foundation
import Firebase

enum SongType {
    case songLibrary
    case prayerLibrary
    case gifter
}

class FirebaseSongHandler {
    var song: Data
    var downloadURL: URL?
    var downloadURLString: String!
    var ref: FIRStorageReference!
    
    init(song: Data) {
        self.song = song
    }
}

// MARK: - Extensions
extension FirebaseSongHandler {
    func saveSong(_ type: SongType, _ uid: String, _ completion: @escaping (Error?) -> Void) {
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "audio/mpeg"
        
        switch type {
        case .songLibrary: ref = StorageReference.songLibrary.reference().child(uid)
        case .prayerLibrary: ref = StorageReference.prayerLibrary.reference().child(uid)
        case .gifter: ref = StorageReference.gifterSong.reference().child(uid)
        }
        
        //ref = StorageReference.songLibrary.reference().child(uid)
        downloadURLString = ref.description
        
        ref.put(song, metadata: metadata) { (meta, error) in
            completion(error)
        }
    }
    
    func saveSong(_ uid: String, _ fileName: String, _ completion: @escaping (Error?) -> Void) {
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "audio/mpeg"
        
        ref = StorageReference.songLibrary.reference().child(uid)
        downloadURLString = ref.description
        
        let url = URL(fileReferenceLiteralResourceName: fileName)
        ref.putFile(url, metadata: metadata) { (meta, error) in
            completion(error)
        }
    }
    
    class func downloadSong(type: SongType, uid: String, completion: @escaping (Data? ,Error?) -> Void) {
        let classRef: FIRStorageReference!
        
        switch type {
        case .songLibrary: classRef = StorageReference.songLibrary.reference().child(uid)
        case .prayerLibrary: classRef = StorageReference.songLibrary.reference().child(uid)
        case .gifter: classRef = StorageReference.gifterSong.reference().child(uid)
        }
        
        //StorageReference.songLibrary.reference().child(uid).data(withMaxSize: 10 * 1024 * 1024) { (songData, error) in
        classRef.data(withMaxSize: 10 * 1024 * 1024) { (songData, error) in
            if error == nil && songData != nil {
                //let image = UIImage(data: imageData!)
                completion (songData ,nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
}


