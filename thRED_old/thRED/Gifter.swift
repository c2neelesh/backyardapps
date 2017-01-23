//
//  Gifter.swift
//  thRED
//
//  Created by Neelesh Shah on 1/17/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

//
//  Gifter.swift
//  thRED
//
//  Created by Neelesh Shah on 1/10/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit
import AVFoundation

class Gifter {
    var uid: String
    var eventid: String
    var status: String
    var primary: String
    var date: Date?
    var song: Data = Data()
    var audioPlayer = AVAudioPlayer()
    
    // MARK: - Initializers
    
    init(uid: String, eventid: String, status: String?, primary: String?, date: Date?, song: Data ) {
        self.uid = uid
        self.eventid = eventid
        if let status = status {
            self.status = status
        } else {
            self.status = "invited"
        }
        if let primary = primary {
            self.primary = primary
        } else {
            self.primary = "no"
        }
        self.date = date
        self.song = song
    }
    
    
    // MARK: - Support functions
    func toDictionary() -> [String : Any] {
        
        return [
            "status": status,
            "primary": primary,
            "date": "",
            "songURL": ""
        ]
    }
    /*
    init(gifterDictionaryFromSnapshot: [String : Any], key:String) {
        self.uid = key //userDictionaryFromSnapshot["uid"] as! String
        self.status = gifterDictionaryFromSnapshot["status"] as! String
        self.primary = gifterDictionaryFromSnapshot["primary"] as! String
        let dateString = gifterDictionaryFromSnapshot["date"] as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        self.date = dateFormatter.date(from: dateString)!
        
        if let _ = gifterDictionaryFromSnapshot["songURL"] {
            FirebaseSongHandler.downloadGifterSong(uid: key, completion: { (songData, error) in
                if let goodSong = songData {
                    self.song = goodSong
                    self.setupAudioPlayer()
                }
            })
        }
    }
    */
    
    func save(completion: @escaping (String?) -> Void) {
        let gifterRef = DatabaseReference.gifter(eventid: eventid, gifterid: uid).reference()
        gifterRef.setValue(toDictionary())
        completion(nil)
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



