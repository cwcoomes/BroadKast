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


struct Data{
    var long: Double
    var lat: Double
    init(){
        long = 0.0
        lat = 0.0
    }
}

struct Kast{
    var title: String
    var description: String
    var longitude: Double
    var latitude: Double
    let ref: DatabaseReference?
    init( t: String,d:String ,lo:Double,la:Double){
        self.title = t
        self.description = d
        self.longitude = lo
        self.latitude = la
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        title = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        description = snapshotValue["description"] as! String
        longitude = snapshotValue["longitude"] as! Double
        latitude = snapshotValue["latitude"] as! Double
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "description": description,
            "longitude": longitude,
            "latitude": latitude
        ]
    }
}
class createViewController: UIViewController {
    var data = Data()
    let rootRef = Database.database().reference()
    let kastRef = Database.database().reference(withPath: "Kast")
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBAction func pickLocationButton(_ sender: Any) {
        performSegue(withIdentifier: "create2drop", sender: self)
        
    }
    
    @IBAction func createButton(_ sender: Any) {
        
        let kastItem = Kast(t: titleField.text!, d: descriptionField.text!, lo: data.long, la: data.lat)
        
        let kastItemRef = self.kastRef.child(kastItem.title)
        
        
       
        
        kastItemRef.setValue(kastItem.toAnyObject())
        
        
        
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
