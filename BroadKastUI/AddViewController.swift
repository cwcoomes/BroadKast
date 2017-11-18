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

struct contact
{
    var contactName: String
    let ref: DatabaseReference?
    
    init(cn:String)
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
    var userExists: Bool?
    let userRef = Database.database().reference(withPath: "Users")
    @IBOutlet weak var friendsUsernameField: UITextField!
    @IBAction func saveButton(_ sender: Any)
    {
        let user = Auth.auth().currentUser!
        let currentUser = self.userRef.child(user.displayName!)
        let contactList = currentUser.child("contacts")
        let contactItem = contact(cn: self.friendsUsernameField.text!)
        
        contactList.observe(.value, with: { snapshot in
            if snapshot.hasChild(contactItem.contactName)
            {
                let alert = UIAlertController(title: "You're Already Friends! " , message: "Username is currently in your list of friends.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else if (contactItem.contactName == user.displayName)
            {
                let alert = UIAlertController(title: "Oh no! " , message: "You cannot add yourself.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                self.userRef.observe(.value, with: { snapshot in
                    if snapshot.hasChild(contactItem.contactName)
                    {
                        let newFriend = contactList.child(contactItem.contactName)
                        newFriend.setValue(contactItem.toAnyObject())
                        let alert = UIAlertController(title: "Added Friend" , message: "\(contactItem.contactName) has been added successfully!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Adding Friend Failed " , message: "Username does not exist in the database.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }

        })
        
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
