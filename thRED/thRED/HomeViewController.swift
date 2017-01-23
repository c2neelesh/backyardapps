//
//  HomeViewController.swift
//  thred
//
//  Created by Neelesh Shah on 1/21/17.
//  Copyright © 2017 C2 Consulting, Inc. All rights reserved.
//

import UIKit
import Firebase

struct StoryboardObjects {
    static let authenticatedSegue = "authenticatedSegue"
}

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var giftsCollectionView: UICollectionView!
    var myGifts = [UserGift]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseUserOperation.isUserAuthenticated { (firUser) in
            if let _ = firUser {
                self.myGifts.removeAll()
                self.fetchGiftsOf(uid: (FIRAuth.auth()?.currentUser?.uid)!)
            } else {
                self.performSegue(withIdentifier: StoryboardObjects.authenticatedSegue, sender: nil)
            }
        }
        

    }

    func fetchGiftsOf(uid: String) {
        UserGift.observeUserGifts(.invited, uid) { (userGift) in
            self.myGifts.append(userGift)
            DispatchQueue.main.async {
                self.giftsCollectionView?.reloadData()
                self.view.setNeedsLayout()
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myGifts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeGiftCell", for: indexPath) as! HomeCollectionViewCell
        
        Gift.observeGift(myGifts[indexPath.item].giftID) { (gift) in
            cell.gift = gift
        }

        
        return cell
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
