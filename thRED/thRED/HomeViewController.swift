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
    
    @IBOutlet weak var giftTypeSelector: UISegmentedControl!
    @IBOutlet weak var giftsCollectionView: UICollectionView!
    var gifts = [UserGift]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.giftTypeSelector.selectedSegmentIndex = 0
        print("vdl - Value of control: \(giftTypeSelector.selectedSegmentIndex)")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("vda - Value of control: \(giftTypeSelector.selectedSegmentIndex)")
        
        FirebaseUserOperation.isUserAuthenticated { (firUser) in
            if let _ = firUser {
                self.handleGiftTypeChange(selectedIndex: self.giftTypeSelector.selectedSegmentIndex)

            } else {
                self.performSegue(withIdentifier: StoryboardObjects.authenticatedSegue, sender: nil)
            }
        }
        

    }

    func handleGiftTypeChange(selectedIndex: Int) {
        print("func - Value of control: \(giftTypeSelector.selectedSegmentIndex)")

        if selectedIndex == 0 {
            self.fetchGiftsOf(type: .invited, uid: (FIRAuth.auth()?.currentUser?.uid)!)
        } else {
            self.fetchGiftsOf(type: .received, uid: (FIRAuth.auth()?.currentUser?.uid)!)
        }
    }
    

    @IBAction func giftTypeControlTouched(_ sender: UISegmentedControl) {
        print("touch - Value of control: \(sender.selectedSegmentIndex)")

        handleGiftTypeChange(selectedIndex: sender.selectedSegmentIndex)
    }
    
    func fetchGiftsOf(type: GiftType, uid: String) {
        print("email \(FIRAuth.auth()?.currentUser?.email)!")
        self.gifts.removeAll()
        self.giftsCollectionView?.reloadData()
        self.view.setNeedsLayout()
        print("count before: \(self.gifts.count)")
        UserGift.observeUserGifts(type, uid) { (userGift) in
            self.gifts.append(userGift)
            DispatchQueue.main.async {
                self.giftsCollectionView?.reloadData()
                print("count after: \(self.gifts.count)")
                self.view.setNeedsLayout()
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count at count: \(self.gifts.count)")
        return gifts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeGiftCell", for: indexPath) as! HomeCollectionViewCell
        
        Gift.observeGift(gifts[indexPath.item].giftID) { (gift) in
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
