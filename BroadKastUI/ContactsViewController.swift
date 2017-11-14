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

struct User : Codable
{
    var uid : String
    var username : String
    var contactInfo = [String]()
    init()
    {
        uid = ""
        username = ""
    }
}

class ContactsViewController: UITableViewController
{
    var users = [User]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Friends"
        let rightButtonItem = UIBarButtonItem.init(
            title: "+",
            style: .done,
            target: self,
            action: #selector(rightButtonAction)
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        retrieveDataEvents()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print("from view did load")
        print(users)
    }
    
    func retrieveDataEvents()
    {
        var dataDict:[String: Any] = [:]
        Database.database().reference().child("Users").observe(.value, with: { snapshot in
            dataDict = snapshot.value as! [String: Any]
            var temporaryLocation = User.init()
            
            dataDict.forEach({ (user) in
                let userInformation = user.value as! [String:Any]
                userInformation.forEach({ (info) in
                    switch(info.key as String)
                    {
                        case "uid" :
                            temporaryLocation.uid = info.value as! String
                        case "username" :
                            temporaryLocation.username = info.value as! String
                        case "contacts" :
                            let contactInfo = info.value as! [String:Any]
                            contactInfo.forEach({ (user) in temporaryLocation.contactInfo.append(user.key)})
                        default:
                            print(info.key + " does not contain anything ERROR")
                    }
                })
                self.users.append(temporaryLocation)
                    //print("users: \(users)")
                print("user count: \(self.users.count)")
                })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        print("sent notification")
    }
    
    @objc func rightButtonAction(sender: UIBarButtonItem)
    {
        performSegue(withIdentifier: "contacts2add", sender: self)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "somethingelse", for: indexPath)

        cell.textLabel?.text = users[indexPath.row].username
        print("Printing users")
        //print(users[indexPath.row].username)

        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
