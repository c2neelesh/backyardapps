//
//  SongLibraryCollectionViewController.swift
//  thRED
//
//  Created by Neelesh Shah on 1/13/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit
import Firebase

let reuseCellIdentifier = "SongCell"

class SongLibraryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var songsLibrary = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchSongs()
    }

    func fetchSongs() {
        Song.observeSongLibrary { (song) in
            self.songsLibrary.append(song)            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                self.view.setNeedsLayout()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func myEventsButtonTouched(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songsLibrary.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! SongCell
        cell.song = songsLibrary[indexPath.item]
        cell.buttonAction = { (sender) in
            self.confirmCreateEvent(song: self.songsLibrary[indexPath.item])
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width,  height: view.frame.height - (navigationController?.navigationBar.frame.height)! - 25)
    }
    
    func confirmCreateEvent(song: Song) {
        
        let actionSheet = UIAlertController(title: "Confirm", message: "Create a new event with this Song?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Create Event", style: .default, handler: { (action) in
            print ("*************** \(song.name)")

            let event = Event(name: "\(song.name) Event", gifters: nil, songID: song.uid!, note: "Please join me in this event with the song '\(song.name)'", dueBy: Date())
            
            event.save { (key) in
                if key == nil {
                    print ("cannot save event.")
                } else {
                    let gifter = Gifter(uid: (FIRAuth.auth()?.currentUser?.uid)!, eventid: key!, status: "invited", primary: "yes", date: nil, song: Data())
                    gifter.save(completion: { (whatisthis) in
                        
                    })
                    let userEvent = UserEvent(userID: (FIRAuth.auth()?.currentUser?.uid)!, eventID: key!)
                    print("before save userevent \(key)")
                    userEvent.save(completion: { (error) in
                        
                        print("after save userevent \(key)")

                        if error != nil {
                            print ("cannot save user event fan out.")
                        } else {
                            let newEventVC = NewEventTableViewController()
                            newEventVC.eventID = key
                            print("Before push with BRRRRR")
                            self.navigationController!.pushViewController(newEventVC, animated: true)
                            print("after push with \(key)")
                        }
                        
                        
                    })
                }
                
            }
        }
        ))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        confirmCreateEvent(song: songsLibrary[indexPath.item])
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
