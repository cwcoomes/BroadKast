//
//  MyKastsViewController.swift
//  BroadKastUI
//
//  Created by Ubicomp4 on 11/30/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

import UIKit
import Firebase


class MyKastsViewController: UITableViewController {

    let userRef = Database.database().reference(withPath: "Users")
    var kastArray = [String]()
     var events = [EventData]()
    var followedKasts = [EventData]()
    var myKasts = [EventData]()
    var clickedEvent = EventData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        events.removeAll()
//        followedKasts.removeAll()
//        myKasts.removeAll()
//        kastArray.removeAll()
//        retrieveDataEvents()
//
//        NotificationCenter.default.addObserver(self, selector: #selector(createArray), name: Notification.Name("eventsReady"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(followedKastArray), name: Notification.Name("followsReady"), object: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidAppear(_ animated: Bool) {
        events.removeAll()
        followedKasts.removeAll()
        myKasts.removeAll()
        //print("mykasts upon loading \(myKasts)")
        kastArray.removeAll()
        retrieveDataEvents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(createArray), name: Notification.Name("eventsReady"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(followedKastArray), name: Notification.Name("followsReady"), object: nil)
         self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0)
        {
            return myKasts.count
        }
        if(section == 1)
        {
            return followedKasts.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0)
        {
            return "My Kasts"
        }
        if(section == 1)
        {
            return "Followed Kasts"
        }
        return "error"
    }
    
    func retrieveDataEvents()
    {
       
        events.removeAll()
        myKasts.removeAll()
        followedKasts.removeAll()
        kastArray.removeAll()
        //Declare/initialize the dictionary of data, essentially the bulk of the json
        var dataDict:[String: Any] = [:]
        
        
        //reference the database and start pulling individual kasts
        Database.database().reference().child("Kast").observe(.value, with: { snapshot in
            dataDict = snapshot.value as! [String: Any]
            var temporaryLocation = EventData.init()
            
            //For every Kast, start extraction the information
            dataDict.forEach({ (kast) in
                
                let kastOfInformation = kast.value as! [String:Any]
                
                
                //Put every field of the kast into the struct
                kastOfInformation.forEach({ (item) in
                    
                    
                    //Place every member into the struct
                    switch(item.key as String)
                    {
                    case "description" :
                        temporaryLocation.description = item.value as! String
                    case "kastTag" :
                        temporaryLocation.KastTag = item.value as! String
                    case "latitude":
                        temporaryLocation.latitude = item.value as! Double
                    case "longitude":
                        temporaryLocation.longitude = item.value as! Double
                    case "title" :
                        temporaryLocation.title = item.value as! String
                    case "user":
                        temporaryLocation.user = item.value as! String
                    case "kastID":
                        temporaryLocation.kastID = item.value as! String
                    case "expiration":
                        temporaryLocation.expiration = item.value as! Double
                    case "privacy":
                        temporaryLocation.privacy = item.value as! String
                    case "dlURL":
                        temporaryLocation.dlURL = item.value as! String
                    default:
                        print(item.key + " does not contain anything ERROR")
                    }
                })
                
                self.events.append(temporaryLocation)
               
            })
            
            NotificationCenter.default.post(name: Notification.Name("eventsReady"), object: nil)
        })
        
        
        
        
        
        
    }
    @objc func followedKastArray()
    {
        let user = Auth.auth().currentUser!
        myKasts.removeAll()
        followedKasts.removeAll()
        events.forEach { (kast) in
            if(kast.user == user.displayName!)
            {
                //print("user matched")
                myKasts.append(kast)
            }
            //print(kastArray)
            kastArray.forEach({ (kid) in
                if(kid == kast.kastID)
                {
                    //print("followMatch")
                    
                        followedKasts.append(kast)
                        
                    
                }
            })
            
            
            
            
            
            
        }
        
        self.tableView.reloadData()
    }
    
   @objc func createArray()
    {
        let user = Auth.auth().currentUser!
        let currentUser = self.userRef.child(user.displayName!)
        let followedList = currentUser.child("followedKasts")
        kastArray.removeAll()
        followedList.observe(.value, with: {snapshot in
            
            snapshot.children.forEach({ (kastID) in
                
                var temp = String()
                
                temp = (kastID as! DataSnapshot).key
                
                if(!self.kastArray.contains(temp))
                {
                    self.kastArray.append(temp)
                    
                }
                //print("new kast array \(self.kastArray)")
                
            })
            //print("KastArrayAfterCreatingArray \(self.kastArray)")
            NotificationCenter.default.post(name: Notification.Name("followsReady"), object: nil)
        })
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if(indexPath.section == 0)
        {
            cell.textLabel?.text = myKasts[indexPath.row].title
        }
        if(indexPath.section == 1)
        {
            cell.textLabel?.text = followedKasts[indexPath.row].title
        }

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0)
        {
            clickedEvent = myKasts[indexPath.row]
            performSegue(withIdentifier: "myKast2Details", sender: self)
        }
        if(indexPath.section == 1)
        {
            clickedEvent = followedKasts[indexPath.row]
            performSegue(withIdentifier: "myKast2Details", sender: self)
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "myKast2Details")
        {
            let dvc = segue.destination as! EventDetailsViewController
            dvc.eventToView = clickedEvent
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
