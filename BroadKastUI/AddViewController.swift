//
//  AddViewController.swift
//  BroadKastUI
//
//  Created by Ubicomp4 on 11/7/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct contact{
    var contactName: String
    let ref: DatabaseReference?
    
    init( cn: String)
    {
        self.contactName = cn
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot)
    {
        contactName = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        contactName = snapshotValue["contactName"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any
    {
        return [contactName: contactName]
    }
}


class AddViewController: UIViewController {
    let userRef = Database.database().reference(withPath: "Users")
    
    
    @IBOutlet weak var friendsUsernameField: UITextField!
    @IBAction func saveButton(_ sender: Any) {
        //
        //need to check if the username entered exists first
        
        //code here
        
        
      //insert code to save text field to friends
        let userID = Auth.auth().currentUser!.uid
        let userItemRef = self.userRef.child(userID)
        let friendsRef = userItemRef.child("contacts")
        let contactItem = contact(cn: self.friendsUsernameField.text!)
        let ref = friendsRef.child(contactItem.contactName )
        
        
        //let contactItem = contact(cn: self.friendsUsernameField.text!)
        
        ref.setValue(contactItem.toAnyObject())
        
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
