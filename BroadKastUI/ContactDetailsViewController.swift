//
//  ContactDetailsViewController.swift
//  BroadKastUI
//
//  Created by ubicomp4 on 11/28/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ContactDetailsViewController: UIViewController
{
    var user = String()
    
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var numberOfKastsLabel: UILabel!
    @IBOutlet weak var numberOfFriendsLabel: UILabel!
    
    @IBAction func viewkasts(_ sender: Any)
    {
        self.performSegue(withIdentifier: "contactdetails2kastslist", sender: self)
        print(user)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        contactNameLabel.text = user
        self.title = user

        let selectedUserReference = Database.database().reference().child("Users").child(user)
        selectedUserReference.child("contacts").observe(.value, with: {
            snapshot in
            self.numberOfFriendsLabel.text = String (snapshot.childrenCount)
        })
        
        let kastDirectoryReference = Database.database().reference().child("Kast")
        kastDirectoryReference.observe(.value, with: {
            snapshot in
            self.numberOfKastsLabel.text = "0"
            snapshot.children.forEach({ (child) in
                let individualKast = child as! DataSnapshot
    
                individualKast.children.forEach({ (elementInKast) in
                    if ((elementInKast as! DataSnapshot).key == "user")
                    {
                        if ((elementInKast as! DataSnapshot).value as! String == self.user)
                        {
                            print("increasing count for " + self.user)
                            self.numberOfKastsLabel.text = String (Int (self.numberOfKastsLabel.text!)! + 1)
                        }
                    }
                })
            })
        })
        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if(segue.identifier == "contactdetails2kastslist")
        {
            let dvc = segue.destination as! ContactKastsTableViewController
            dvc.user = user
        }

    }

}
