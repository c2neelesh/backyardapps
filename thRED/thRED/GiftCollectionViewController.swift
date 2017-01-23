//
//  GiftCollectionViewController.swift
//  thred
//
//  Created by Neelesh Shah on 1/21/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit

private let reuseIdentifier = "giftCell"

class GiftCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var songs = [Song]()
    var giftTableViewController: GiftTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        fetchSongs()
    }

    func fetchSongs() {
        Song.observeSongLibrary { (song) in
            self.songs.append(song)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return songs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GiftCollectionViewCell
    
        // Configure the cell
        cell.giftTableViewController = self.giftTableViewController
        cell.giftCollectionViewController = self
        cell.song = songs[indexPath.row]
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height - 66)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playSegue" {
            let destinationVC = segue.destination as! PlayViewController
            let playButton = sender as! UIButton
            
            //print("Yo ! \(playButton.superview?.superview?.superview)")
            
            let cell = playButton.superview?.superview?.superview as! GiftCollectionViewCell
            
            let indexPath = collectionView?.indexPath(for: cell)
            destinationVC.songID = songs[(indexPath?.item)!].uid
        }

    }
}
