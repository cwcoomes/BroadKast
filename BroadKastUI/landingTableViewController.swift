//
//  landingTableViewController.swift
//  BroadKastUI
//
//  Created by Ubicomp4 on 10/19/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwipeCellKit

class landingTableViewController: UITableViewController {
    var options = ["CreateKast", "MyKasts","Map", "People",  "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Main Menu"
        
        if let user = Auth.auth().currentUser
        {
            print(user.displayName as Any)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return options.count    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        // cell.textLabel.text = contacts(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MainKast
        cell.cellLabel.text = options[indexPath.row]
        
        switch indexPath.row {
        case 0:
            cell.cellImage.image = UIImage(named: "icons8-plus-40")
        case 1:
            cell.cellImage.image = UIImage(named: "icons8-heart")
        case 2:
            cell.cellImage.image = UIImage(named: "worldwide_location")
        case 3:
            cell.cellImage.image = UIImage(named: "сontacts")
        case 4:
            cell.cellImage.image = UIImage(named: "exit")
        default:
            break
        }
        
        cell.delegate = self
        
        switch indexPath.row {
        case 3:
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        default:
            break
        }
        
        return cell
       
    }
    
    //Index click options
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0)
        {
            performSegue(withIdentifier: "landing2create", sender: self)
        }
        else if(indexPath.row == 1)
        {
            performSegue(withIdentifier: "landing2myKast", sender: self)
        }
        else if(indexPath.row == 2)
        {
            performSegue(withIdentifier: "landing2map", sender: self)
        }
        else if(indexPath.row == 3)
        {
            performSegue(withIdentifier: "landing2contacts", sender: self)
        }
        else if(indexPath.row == 4)
        {
             let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            performSegue(withIdentifier: "landing2login", sender: self)
        }
        
        
        
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

extension landingTableViewController : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let QuickMapButton = SwipeAction(style: .default, title: "Quick Map") { action, indexPath in
            // handle action by updating model with deletion
        }
        let FilterButton = SwipeAction(style: .default, title: "Filter") { action, indexPath in
            // handle action by updating model with deletion
        }
        let RecentButton = SwipeAction(style: .default, title: "Recent") { action, indexPath in
            // handle action by updating model with deletion
        }
        let AddFriendsButton = SwipeAction(style: .default, title: "Add Friends") { action, indexPath in
            // handle action by updating model with deletion
            self.performSegue(withIdentifier: "main2addFriends", sender: self)
            
        }
        let FavoriteButton = SwipeAction(style: .default, title: "Favorite") { action, indexPath in
            // handle action by updating model with deletion
        }
        
        // customize the action appearance
        QuickMapButton.image = UIImage(named: "icons8-map")
        FilterButton.image = UIImage(named: "icons8-tasklist-2")
        RecentButton.image = UIImage(named: "icons8-past-2")
        AddFriendsButton.image = UIImage(named: "icons8-add-user-male")
        FavoriteButton.image = UIImage(named: "icons8-heart-2")
        
        QuickMapButton.backgroundColor = #colorLiteral(red: 0, green: 0.2240427732, blue: 0.2944218516, alpha: 1)
        FilterButton.backgroundColor = #colorLiteral(red: 0, green: 0.2240427732, blue: 0.2944218516, alpha: 1)
        RecentButton.backgroundColor = #colorLiteral(red: 0, green: 0.2240427732, blue: 0.2944218516, alpha: 1)
        AddFriendsButton.backgroundColor = #colorLiteral(red: 0, green: 0.2240427732, blue: 0.2944218516, alpha: 1)
        FavoriteButton.backgroundColor = #colorLiteral(red: 0, green: 0.2240427732, blue: 0.2944218516, alpha: 1)
        
        switch indexPath.row {
        case 3:
            return [AddFriendsButton]
        case 4:
            break
        default:
            return []
        }
        return []
    }
}



class MainKast: SwipeTableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
}
