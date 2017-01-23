//
//  LoadSongsHelperViewController.swift
//  thred
//
//  Created by Neelesh Shah on 1/21/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit

class LoadSongsHelperViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loadSongsButtonTouched() {
        let songImage = #imageLiteral(resourceName: "happybirthday")
        let songData = Data()
        let song = Song(name: "Happy Birthday",lyrics: "Happy Birthday to You,\nHappy Birthday to You,\nHappy Birthday Dear (name),\nHappy Birthday to You.\n\nFrom good friends and true,\nFrom old friends and new,\nMay good luck go with you,\nAnd happiness too.", duration: 49, artist: "Unknown", about: "Traditional Happy Birthday Song", songImage: songImage, song: songData)
        
        song.saveFile(fileName: "hbd.m4a") { (uid ,error) in
            
            if error != nil {
                print("Error loading song: \(error?.localizedDescription)")
            } else {
                print ("Song loaded")
            }
        }
        
        let songImage2 = #imageLiteral(resourceName: "jesus")
        let songData2 = Data()
        let song2 = Song(name: "The Lord's Prayer Song",lyrics: "Our Father who art in heaven, hallowed be thy name.\nThy kingdom come.\nThy will be done on earth as it is in heaven.\nGive us this day our daily bread,\n  and forgive us our trespasses,\n  as we forgive those who trespass against us,\n  and lead us not into temptation,\n  but deliver us from evil.\nFor thine is the kingdom,\n  and the power, and the glory,\n  for ever and ever.\nAmen.", duration: 133, artist: "Unknown", about: "The Lord's Prayer Song", songImage: songImage2, song: songData2)
        
        song2.saveFile(fileName: "prayer.m4a") { (uid, error) in
            
            if error != nil {
                print("Error loading song: \(error?.localizedDescription)")
            } else {
                print ("Song loaded")
            }
        }

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
