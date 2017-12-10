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




class EventDetailsViewController: UIViewController {
   
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var tag: UILabel!
    let userRef = Database.database().reference(withPath: "Users")
    var kastArray = [String]()
    
    
    
    @IBOutlet weak var followButtonObject: RoundButton!
    @IBOutlet weak var eventDescription: UITextView!
   
    @IBAction func followButton(_ sender: Any) {
        
        let user = Auth.auth().currentUser!
        let currentUser = self.userRef.child(user.displayName!)
        var followedList = currentUser.child("followedKasts")
        
        
        var flag = false
        
        followedList.observe(.value, with: { snapshot in
            flag = false
            
            if snapshot.hasChild(self.eventToView.kastID)
            {
                //code if kast is already followed
                
               
                //followedList.child(self.eventToView.kastID).removeValue()
                
                followedList.child(self.eventToView.kastID).removeValue(completionBlock: { (error, refer) in
                    if error != nil { print(error as Any) }
                    else
                    {
                        print(refer)
                        print("Child Removed Correctly")
                    }
                })
                
                flag = true
                self.pullData()
                
                currentUser.removeAllObservers()
                followedList.removeAllObservers()
                
            }
            else if (self.eventToView.user == user.displayName)
            {
                //
                let alert = UIAlertController(title: "Oh no! " , message: "You cannot follow your own Kast.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                //if not yet followed
                let newFriend = followedList.child(self.eventToView.kastID)
                newFriend.setValue(self.eventToView.kastID)
                self.pullData()
                followedList.removeAllObservers()
                currentUser.removeAllObservers()
                
            }
            
        })
  
       // followedList.removeAllObservers()
        
    }
    
    func addToFirebase()
    {
        
    }
    
    
    var eventToView = EventData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventTitle.text = eventToView.title
        eventDescription.text = eventToView.description
        tag.text = eventToView.KastTag
        
        //pull followed kasts
        
        
       pullData()
        
//        kastArray.forEach { (kastid) in
//
//            if(kastid == eventToView.kastID)
//            {
//                //modify button
//                followButtonObject.titleLabel!.text = "Unfollow"
//            }
//
//        }
        
        // Do any additional setup after loading the view.
    }
    
    func pullData()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(EventDetailsViewController.modifyButton), name: Notification.Name("followArrayComplete"), object: nil)
        
        createArray()
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
            NotificationCenter.default.post(name: Notification.Name("followArrayComplete"), object: nil)
        })
        
    }
    
    @objc func modifyButton()
    {
        
        
        kastArray.forEach { (kastid) in
            
            if(kastid == eventToView.kastID)
            {
                //modify button
                print("should change to unfollow")
                followButtonObject.titleLabel!.text = "Unfollow"
                followButtonObject.backgroundColor = UIColor.gray
            }
            
        }
        
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
