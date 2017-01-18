//
//  SongCell.swift
//  thRED
//
//  Created by Neelesh Shah on 1/13/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit
import AVFoundation

class SongCell: UICollectionViewCell {
    

    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lyricsTextView: UITextView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var createEventButton: UIButton!
    var buttonAction: ((_ sender: UIButton) -> Void)?
    
    var song: Song! {
        didSet {
            updateCell()
        }
    }
    
    enum AudioButtonMode {
        case initialize
        case play
        case pause
        case stop
        case none
    }
    
    func updateCell() {
        self.nameLabel.text = "\(song.name)"
        self.lyricsTextView.text = song.lyrics
        let newPosition = lyricsTextView.beginningOfDocument
        self.lyricsTextView.isEditable = true
        self.lyricsTextView.selectedTextRange = lyricsTextView.textRange(from: newPosition, to: newPosition)
        self.lyricsTextView.isEditable = false
        self.songImageView.image = song.songImage
    }
    
    @IBAction func confirmCreateEventButtonPressed(sender: UIButton) {
        self.buttonAction?(sender)
    }

    
    @IBAction func playSong() {
        self.song.play()
        //setupAudioButtons(mode: .play)
    }
    
    @IBAction func stopSong() {
        self.song.stop()
        //setupAudioButtons(mode: .stop)
    }
    
    @IBAction func pause() {
        self.song.pause()
        //setupAudioButtons(mode: .pause)
    }
    
    func setupAudioButtons(mode: AudioButtonMode) {
        switch mode {
        case .initialize:
            //self.playButton.isEnabled = true
            //self.pauseButton.isEnabled = false
            //self.stopButton.isEnabled = false
            self.playButton.isHidden = false
            self.pauseButton.isHidden = true
            self.stopButton.isHidden = true
        case .play:
            //self.playButton.isEnabled = false
            //self.pauseButton.isEnabled = true
            //self.stopButton.isEnabled = true
            self.playButton.isHidden = true
            self.pauseButton.isHidden = false
            self.stopButton.isHidden = false
        case .pause:
            //self.playButton.isEnabled = true
            //self.pauseButton.isEnabled = false
            //self.stopButton.isEnabled = false
            self.playButton.isHidden = false
            self.pauseButton.isHidden = true
            self.stopButton.isHidden = true
        case .stop:
            //self.playButton.isEnabled = true
            //self.pauseButton.isEnabled = false
            //self.stopButton.isEnabled = false
            self.playButton.isHidden = false
            self.pauseButton.isHidden = true
            self.stopButton.isHidden = true
        case .none:
            //self.playButton.isEnabled = false
            //self.pauseButton.isEnabled = false
            //self.stopButton.isEnabled = false
            self.playButton.isHidden = true
            self.pauseButton.isHidden = true
            self.stopButton.isHidden = true
        }
    }
    
}
