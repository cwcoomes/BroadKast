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
    var streetAddress: String
    var city: String
    var zip: String
    var stateCode: String
    init(){
        long = 50
        lat = 50
        streetAddress = ""
        city = ""
        zip = ""
        stateCode = ""
    }
}

struct Kast{
    var title: String
    var user: String
    var description: String
    var longitude: Double
    var latitude: Double
    var kastTag: String
    var expiration: Double
    var privacy: String
    var kastID: String
    let ref: DatabaseReference?
    
    init( t: String,d:String ,lo:Double,la:Double, us: String, kt: String, ex: Double, pr: String, kid: String){
        self.title = t
        self.description = d
        self.longitude = lo
        self.latitude = la
        self.user = us
        self.kastTag = kt
        self.expiration = ex
        self.privacy = pr
        self.kastID = kid
        self.ref = nil
    }
  
    init(snapshot: DataSnapshot) {
      //  title = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        description = snapshotValue["description"] as! String
        longitude = snapshotValue["longitude"] as! Double
        latitude = snapshotValue["latitude"] as! Double
        user = snapshotValue["user"] as! String
        kastTag = snapshotValue["kastTag"] as! String
        privacy = snapshotValue["privacy"] as! String
        expiration = snapshotValue["timeStamp"] as! Double
        kastID = snapshotValue["kastID"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "description": description,
            "longitude": longitude,
            "latitude": latitude,
            "user": user,
            "kastTag": kastTag,
            "expiration": expiration,
            "privacy": privacy,
            "kastID" : kastID
        ]
    }
}

class createViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var data = Data()
    let rootRef = Database.database().reference()
    let kastRef = Database.database().reference(withPath: "Kast")
    let user = Auth.auth().currentUser
    var locationSelected = false
    var tags = ["Study","Sport","Food","Party",
               "Hang Out"]
    var privacy = "Public"
    let imagePick = UIImagePickerController()
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var streetAdd2: UITextField!
    @IBOutlet weak var streetAdd1: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var kastTag: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var duration: UITextField!
    
    @IBAction func privacySetting(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0
        {
            privacy = "Public"
        }
        else if sender.selectedSegmentIndex == 1
        {
                privacy = "Private"
        }
        
    }
    @IBAction func pickLocationButton(_ sender: Any) {
        locationSelected = true
        performSegue(withIdentifier: "create2drop", sender: self)
        
    }
    
    @IBAction func addPictures(_ sender: Any) {
        
        imageActionSheet()
        
    }
    
    func imageActionSheet() {
        let alert = UIAlertController(title: "Select Image From", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Open Camera", comment: "Default action"), style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Open Gallery", comment: "Default action"), style: .default, handler: { _ in
            self.loadImageFromGallery()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePick.allowsEditing = false
            imagePick.sourceType = .camera
            imagePick.cameraCaptureMode = .photo
            present(imagePick,animated: true,completion: nil)
        }
        else {
            let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
            alertVC.addAction(okAction)
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    func loadImageFromGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePick.allowsEditing = false
            imagePick.sourceType = .photoLibrary
            present(imagePick, animated: true, completion: nil)
        }
        else {
            let alertVC = UIAlertController(title: "No Photo Library", message: "Sorry, this device does not have a supported photo library", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
            alertVC.addAction(okAction)
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func createButton(_ sender: Any) {
      
        //Need to do some error checking here
        
        var long: Double = 0.0
        var lat: Double = 0.0
        
        if(locationSelected == false)
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
                var expirationTime = NSDate().addingTimeInterval(Double(self.duration.text!)!*60*60)
                
                var interval = expirationTime.timeIntervalSince1970
                
                let ref = self.kastRef.childByAutoId()
                let createdId = ref.key
                let kastItem = Kast(t: self.titleField.text!, d: self.descriptionField.text!, lo: long, la: lat, us: (self.user?.displayName)!, kt: self.kastTag.text!, ex: interval, pr: self.privacy, kid: createdId)
                
                
                
                ref.setValue(kastItem.toAnyObject())
                
                
                
                self.navigationController?.popViewController(animated: true)
               
            }
            
        } else {
             var expirationTime = NSDate().addingTimeInterval(Double(self.duration.text!)!*60*60)
            
            var interval = expirationTime.timeIntervalSince1970
            
            let ref = kastRef.childByAutoId()
            let createdId = ref.key

            let kastItem = Kast(t: titleField.text!, d: descriptionField.text!, lo: data.long, la: data.lat, us: (user?.uid)!, kt: kastTag.text!,ex: interval, pr: self.privacy, kid: createdId)

            
            ref.setValue(kastItem.toAnyObject())
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    /*
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxtext: Int = 140
        
        return descriptionField.text.characters.count + (text.characters.count - range.length) <= maxtext

    }
 */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.delegate = self
        streetAdd2.delegate = self
        streetAdd1.delegate = self
        city.delegate = self
        zip.delegate = self
        state.delegate = self
      
        
        //descriptionField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        streetAdd1.text = data.streetAddress
        city.text = data.city
        state.text = data.stateCode
        zip.text = data.zip
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return tags.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return tags[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.kastTag.text = self.tags[row]
        self.dropDown.isHidden = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.kastTag {
            self.dropDown.isHidden = false
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
        
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

// Ensures that pressing "Return" closes keyboard
extension createViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
