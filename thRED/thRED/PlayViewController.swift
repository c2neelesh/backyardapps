//
//  PlayViewController.swift
//  thred
//
//  Created by Neelesh Shah on 1/22/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit
import AVFoundation

class PlayViewController: UIViewController {

    var songID: String?
    var audioPlayer = AVAudioPlayer()
    var song = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let url =  URL(fileReferenceLiteralResourceName: "Doh.mp3")
        self.song = try! Data(contentsOf: url)
        //songID = "~000"
        
        FirebaseSongHandler.downloadSong(type: .song, uid: songID!, completion: { (data, error) in
            if data != nil {
                self.song = data!
            }
            
            do {
                self.audioPlayer = try AVAudioPlayer(data: self.song)
                self.audioPlayer.prepareToPlay()
                self.play()
            } catch {
                print("*********** Error setting up audioplayer \(error.localizedDescription)")
            }
            
        })
    }
    
    @IBAction func play() {
        audioPlayer.play()
    }
    
    @IBAction func pause() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        }
    }
    
    @IBAction func stop() {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            audioPlayer.currentTime = 0.0
        }
    }
    
    @IBAction func dismissPlayPopUp() {
        stop()
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
