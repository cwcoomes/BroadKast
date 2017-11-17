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
    @IBAction func saveButton(_ sender: Any)
    {
        let user = Auth.auth().currentUser!
        let userItemRef = self.userRef.child(user.displayName!)
        let friendsRef = userItemRef.child("contacts")
        let contactItem = contact(cn: self.friendsUsernameField.text!)
        if (true) //need to check if the friend exists
        {
            let ref = friendsRef.child(contactItem.contactName)
            ref.setValue(contactItem.toAnyObject())
            print("user has been added")
            //Alert the user that the friend has been added successfully
        }
        else
        {
            //Alert the user that the username does not exist
            print("user does not exist")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkIfUserExistByUserDisplayName(userDisplayName:String) -> Bool
    {
        let userRef = Database.database().reference(withPath: "Users")
        var userExists = false
        
        DispatchQueue.main.async
        {
            userRef.observe(.value, with: { snapshot in
                if snapshot.hasChild(userDisplayName) {
                    userExists = true
                    print(snapshot)
                }
                else { print("User not found") }
            })
        }
        
        return userExists
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
