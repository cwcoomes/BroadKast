//
//  createViewController.swift
//  BroadKastUI
//
//  Created by Ubicomp4 on 10/19/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreLocation
import AddressBookUI


struct Data{
    var long: Double
    var lat: Double
    init(){
        long = 50
        lat = 50
    }
}

struct Kast{
    var title: String
    var user: String
    var description: String
    var longitude: Double
    var latitude: Double
    let ref: DatabaseReference?
    init( t: String,d:String ,lo:Double,la:Double, us: String){
        self.title = t
        self.description = d
        self.longitude = lo
        self.latitude = la
        self.user = us
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        title = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        description = snapshotValue["description"] as! String
        longitude = snapshotValue["longitude"] as! Double
        latitude = snapshotValue["latitude"] as! Double
        user = snapshotValue["user"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "description": description,
            "longitude": longitude,
            "latitude": latitude,
            "user": user
        ]
    }
}

class createViewController: UIViewController, UITextViewDelegate {
    var data = Data()
    let rootRef = Database.database().reference()
    let kastRef = Database.database().reference(withPath: "Kast")
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var streetAdd2: UITextField!
    @IBOutlet weak var streetAdd1: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var state: UITextField!
    
    @IBAction func pickLocationButton(_ sender: Any) {
        performSegue(withIdentifier: "create2drop", sender: self)
        
    }
    
    @IBAction func createButton(_ sender: Any) {
      
        var long: Double = 0.0
        var lat: Double = 0.0
        
        
        //this code bloke doesn't execute when location is picked from the map,
        //nor does it execute when the address is entered
        
        
        //output is initialized value when pick location is used for coordinates 
       
        
        //the else block works correctly
        if(streetAdd1.text != "")
        {
            let address = "\(streetAdd1.text!), \(city.text!), \(state.text!) \(zip.text!) "
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                    else {
                        // handle no location found
                        return
                }
                
                lat = location.coordinate.latitude
                long = location.coordinate.longitude
                
                let kastItem = Kast(t: self.titleField.text!, d: self.descriptionField.text!, lo: long, la: lat, us: (self.user?.uid)!)
                
                let kastItemRef = self.kastRef.child(kastItem.title)
                
                kastItemRef.setValue(kastItem.toAnyObject())
                
                self.navigationController?.popViewController(animated: true)
               
            }
            
            
            
            
           
            
        } else {
            let kastItem = Kast(t: titleField.text!, d: descriptionField.text!, lo: data.long, la: data.lat, us: (user?.uid)!)
            
            let kastItemRef = self.kastRef.child(kastItem.title)
            
            kastItemRef.setValue(kastItem.toAnyObject())
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxtext: Int = 140
        
        return descriptionField.text.characters.count + (text.characters.count - range.length) <= maxtext

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionField.delegate = self
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
