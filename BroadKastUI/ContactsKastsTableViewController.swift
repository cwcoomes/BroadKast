//
//  ContactKastsTableViewController.swift
//
//
//  Created by ubicomp4 on 12/5/17.
//

import UIKit
import Firebase
import SwipeCellKit


class ContactKastsTableViewController: UITableViewController {
    
    var user = String()
    var kasts = [EventData]()
    
    var clickedEvent = EventData()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        retrieveDataEvents()
    }
    
    func retrieveDataEvents()
    {
        Database.database().reference().child("Kast").observe(.value, with: {
            snapshot in
            snapshot.children.forEach({ (kast) in
                (kast as! DataSnapshot).children.forEach({ (kastKey) in
                    if ( (kastKey as! DataSnapshot).key == "user")
                    {
                        if ((kastKey as! DataSnapshot).value as! String == self.user)
                        {
                            if (NSDate().timeIntervalSince1970 <= (kast as! DataSnapshot).childSnapshot(forPath: "expiration").value as! Double)
                            {
                                var temporaryKast = EventData()
                                temporaryKast.title = (kast as! DataSnapshot).childSnapshot(forPath: "title").value as! String
                                temporaryKast.description = (kast as! DataSnapshot).childSnapshot(forPath: "description").value as! String
                                temporaryKast.KastTag = (kast as! DataSnapshot).childSnapshot(forPath: "kastTag").value as! String
                                temporaryKast.latitude = (kast as! DataSnapshot).childSnapshot(forPath: "latitude").value as! Double
                                temporaryKast.longitude = (kast as! DataSnapshot).childSnapshot(forPath: "longitude").value as! Double
                                temporaryKast.user = (kast as! DataSnapshot).childSnapshot(forPath: "user").value as! String
                                temporaryKast.kastID = (kast as! DataSnapshot).childSnapshot(forPath: "kastID").value as! String
                                temporaryKast.expiration = (kast as! DataSnapshot).childSnapshot(forPath: "expiration").value as! Double
                                temporaryKast.privacy = (kast as! DataSnapshot).childSnapshot(forPath: "privacy").value as! String
                                temporaryKast.dlURL = (kast as! DataSnapshot).childSnapshot(forPath: "dlURL").value as! String

                                self.kasts.append(temporaryKast)
                                print(self.kasts)
                                DispatchQueue.main.async { self.tableView.reloadData() }
                            }
                        }
                    }
                })
                DispatchQueue.main.async { self.tableView.reloadData() }
            })
            DispatchQueue.main.async { self.tableView.reloadData() }
            Database.database().reference().child("Kast").removeAllObservers()
        })
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickedEvent = kasts[indexPath.row]
        performSegue(withIdentifier: "contacts2details", sender: self)
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
        print(kasts.count)
        return kasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kastCell", for: indexPath)
        cell.textLabel?.text = kasts[indexPath.row].title
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "contacts2details")
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

