//
//  Song.swift
//  thRED
//
//  Created by Neelesh Shah on 1/10/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit
import AVFoundation

class Song {
    let uid: String?
    var name: String
    var lyrics: String
    var duration: Int
    var artist: String?
    var about: String?
    var songImage: UIImage?
    var song: Data = Data()
    // this is definitely not a good idea. to have audio player at individual song level is ugh. Change this when you have some time
    var audioPlayer = AVAudioPlayer()
    

    
    // MARK: - Initializers
    
    //init(uid: String, name: String, lyrics: String, duration: Int, artist: String, about: String,
    init(name: String, lyrics: String, duration: Int, artist: String, about: String,songImage: UIImage?, song: Data) {
        self.uid = ""
        self.name = name
        self.lyrics = lyrics
        self.duration = duration
        self.artist = artist
        self.about = about
        self.songImage = songImage
        self.song = song
    }
    
    init(songDictionaryFromSnapshot: [String : Any] ,key: String) {
        self.uid = key //songDictionaryFromSnapshot["uid"] as! String
        self.name = songDictionaryFromSnapshot["name"] as! String
        self.lyrics = songDictionaryFromSnapshot["lyrics"] as! String
        self.duration = songDictionaryFromSnapshot["duration"] as! Int
        self.artist = songDictionaryFromSnapshot["artist"] as? String
        self.about = songDictionaryFromSnapshot["about"] as? String
        
        if let _ = songDictionaryFromSnapshot["songImageURL"] {
            //FirebaseImageHandler.downloadSongImage(self.uid, completion: { (image, error) in
            FirebaseImageHandler.downloadImage(ImageType.song, key, completion: { (image, error) in
                if image != nil {
                    self.songImage = image
                } 
            })
        }
        if let _ = songDictionaryFromSnapshot["songURL"] {
            //FirebaseSongHandler.downloadSong(uid: self.uid, completion: { (songData, error) in
            FirebaseSongHandler.downloadSong(type: SongType.songLibrary,  uid: key, completion: { (songData, error) in
                if let goodSong = songData {
                    self.song = goodSong
                    self.setupAudioPlayer()
                }
            })
        }
    }
    
    // MARK: - Support functions
    func toDictionary() -> [String : Any] {
        return [
            //"uid": uid,
            "name": name,
            "lyrics": lyrics,
            "duration": duration,
            "artist": artist ?? "",
            "about": about ?? ""
        ]
    }
    
    func save(completion: @escaping (String?, Error?) -> Void) {
        let ref = DatabaseReference.songLibrary.reference()
        let songRef = ref.childByAutoId()
        let uid = songRef.key

        songRef.setValue(toDictionary())
        
        // Set song image
        if let songImage = self.songImage {
            let firebaseImage = FirebaseImageHandler(image: songImage)
            firebaseImage.saveImage(ImageType.song, uid, { (error) in
                if error == nil {
                    songRef.child("songImageURL").setValue(firebaseImage.downloadURLString)
                    //completion (uid, nil)
                } else {
                    songRef.child("songImageURL").setValue("")
                    //completion(nil, error)
                }
            })
        } else {
            songRef.child("songImageURL").setValue("")
            //completion(nil, error)
        }

        
        // Set song
        let firebaseSong = FirebaseSongHandler(song: song)
        firebaseSong.saveSong(SongType.songLibrary,  uid, { (error) in
            if error == nil {
                songRef.child("songURL").setValue(firebaseSong.downloadURLString)
                completion(uid ,nil)
            } else {
                completion(uid, error)
            }
        })
    }

    // This was created as a helper to load the 3 'static' songs to the library
    // Eventually this will be deleted along with the code from the Accounts page button and code to load these songs
    func saveFile(fileName: String, completion: @escaping (String?, Error?) -> Void) {
        let ref = DatabaseReference.songLibrary.reference()
        let songRef = ref.childByAutoId()
        let uid = songRef.key
        
        songRef.setValue(toDictionary())
        
        // Set song image
        if let songImage = self.songImage {
            let firebaseImage = FirebaseImageHandler(image: songImage)
            firebaseImage.saveImage(ImageType.song, uid, { (error) in
                if error == nil {
                    songRef.child("songImageURL").setValue(firebaseImage.downloadURLString)
                    //completion (uid, nil)
                } else {
                    songRef.child("songImageURL").setValue("")
                    //completion(nil, error)
                }
            })
        } else {
            songRef.child("songImageURL").setValue("")
            //completion(nil, error)
        }
        
        
        // Set song
        let firebaseSong = FirebaseSongHandler(song: song)
        firebaseSong.saveSong(uid, fileName, { (error) in
            if error == nil {
                songRef.child("songURL").setValue(firebaseSong.downloadURLString)
                completion(uid ,nil)
            } else {
                completion(uid, error)
            }
        })
    }
    
    class func observeSongLibrary (_ completion: @escaping (Song) -> Void) {
        let songReference = DatabaseReference.songLibrary.reference()
        
        songReference.observe(.childAdded, with: { (snapshot) in
            let song = snapshot.value as? [String : Any] ?? [:]
            completion(Song(songDictionaryFromSnapshot: song, key: snapshot.key))
            
        })
    }
    
    class func observeSong (_ uid: String, _ completion: @escaping (Song) -> Void) {
        let songReference = DatabaseReference.song(uid: uid).reference()
        
        songReference.observe(.value, with: { (snapshot) in
            let song = snapshot.value as? [String : Any] ?? [:]
            completion(Song(songDictionaryFromSnapshot: song, key: snapshot.key))
            
        })
    }

    func play() {
        audioPlayer.play()
    }
    
    func stop() {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            audioPlayer.currentTime = 0.0
        }
    }
    
    func pause() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        }
    }
    
    func setupAudioPlayer() {
        do {
            audioPlayer = try AVAudioPlayer(data: song)
            audioPlayer.prepareToPlay()
        } catch {
            print("*********** Error setting up audioplayer \(error.localizedDescription)")
        }
    }
}
