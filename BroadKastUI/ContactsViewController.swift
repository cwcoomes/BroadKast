//
//  ContactsViewController.swift
//  BroadKastUI
//
//  Created by Ubicomp4 on 11/7/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SwipeCellKit

class ContactsViewController: UITableViewController
{
    var users = [String]()
    var selectedUserName = String()
    var selectedUserNumberOfKasts = String()
    var selectedUserNumberOfFriends = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        users.removeAll()
        

        self.title = "Following"
        let rightButtonItem = UIBarButtonItem.init(
            title: "+",
            style: .done,
            target: self,
            action: #selector(rightButtonAction)
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        retrieveDataEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    func retrieveDataEvents()
    {
        var dataDict:[String: Any] = [:]
        let userID = Auth.auth().currentUser!.displayName
        users.removeAll()
        
        Database.database().reference().child("Users").observe(.value, with: { snapshot in
            self.users.removeAll()
            if (snapshot.hasChild(userID!))
            {
                Database.database().reference().child("Users").child(userID!).child("contacts").observe(.value, with: { snapshot in
                    if (snapshot.hasChildren())
                    {
                        dataDict = snapshot.value as! [String: Any]
                        dataDict.forEach({ (user) in
                            self.users.append(user.key)
                            self.users.sort()
                            print("user count: \(self.users.count)")
                        })
                        
                        DispatchQueue.main.async { self.tableView.reloadData() }
                    }
                    else
                    {
                        self.users.append("Not following anyone.")
                        self.users.sort()
                        DispatchQueue.main.async { self.tableView.reloadData() }
                    }
                    Database.database().reference().child("Users").child(userID!).child("contacts").removeAllObservers()
                })
            }
            else
            {
                self.users.append("Not following anyone.")
                self.users.sort()
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
            Database.database().reference().child("Users").removeAllObservers()
        })
        
    }
    
    @objc func rightButtonAction(sender: UIBarButtonItem)
    {
        performSegue(withIdentifier: "contacts2add", sender: self)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "somethingelse") as! FriendCellRow
        cell.FriendNameLabl.text = users[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedUserName = users[indexPath.row]
        performSegue(withIdentifier: "contactsList2contactDetails", sender: self)
    }
    
    func removeUserFromContactList(displayNameOfUserToRemove:String)
    {
        let userRef = Database.database().reference(withPath: "Users")
        let user = Auth.auth().currentUser!
        
        userRef.child(user.displayName!).child("contacts").child(displayNameOfUserToRemove).removeValue(completionBlock: { (error, refer) in
            if error != nil { print(error as Any) }
            else
            {
                print(refer)
                print("Child Removed Correctly")
            }
        })
        userRef.child(user.displayName!).child("contacts").child(displayNameOfUserToRemove).removeAllObservers()
        let updatedUsers = users.filter{$0 != displayNameOfUserToRemove}
        users = updatedUsers.sorted()
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if(segue.identifier == "contactsList2contactDetails")
        {
            let dvc = segue.destination as! ContactDetailsViewController
            dvc.user = selectedUserName
        }
     }
    
}

extension ContactsViewController : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let DeleteButton = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.removeUserFromContactList(displayNameOfUserToRemove: self.users[indexPath.row])
        }
        
        return [DeleteButton]
    }
}

class FriendCellRow: SwipeTableViewCell{
    
    @IBOutlet weak var FriendNameLabl: UILabel!
}
