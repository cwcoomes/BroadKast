//
//  EventDetailsViewController.swift
//  BroadKastUI
//
//  Created by ubicomp4 on 11/1/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase


struct followedKast
{
    var kastID: String
    let ref: DatabaseReference?
    
    init(kid:String)
    {
        self.kastID = kid
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot)
    {
        kastID = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        kastID = snapshotValue["kastID"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any
    {
        return [kastID  : kastID]
    }
}

class EventDetailsViewController: UIViewController {
   
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var tag: UILabel!
    let userRef = Database.database().reference(withPath: "Users")
    
    @IBOutlet weak var eventDescription: UITextView!
    @IBAction func followButton(_ sender: Any) {
        
  
        
    }
    
    
    var eventToView = EventData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventTitle.text = eventToView.title
        eventDescription.text = eventToView.description
        tag.text = eventToView.KastTag
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
