//
//  mapViewController.swift
//  BroadKastUI
//
//  Created by Ubicomp4 on 10/19/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

/* TODO 12/10/17:
     1. Privacy Button needs functionality
     2. Active Filter button should change color when filter is active
     3. Map UI needs to be adjusted for buttons
 */

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Foundation

struct EventData : Codable {
    var description : String
    var KastTag : String
    var latitude : Double
    var longitude : Double
    var title : String
    var user : String
    var expiration: Double
    var privacy: String
    var dlURL: String
    var kastID : String
    
    init() {
        description = ""
        KastTag = ""
        title = ""
        user = ""
        latitude = 0
        longitude = 0
        expiration = 0
        privacy = ""
        kastID = ""
        dlURL = ""
    }
}

var events = [EventData]()

class mapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    
    var studyFilter : Bool = true
    var sportFilter : Bool = true
    var foodFilter : Bool = true
    var partyFilter : Bool = true
    var hangoutFilter : Bool = true
    
    var privacyFilter : Bool?
    var users = [String]()
    
    @IBOutlet weak var map: MKMapView!
    
    let manager = CLLocationManager()
    var clickedEvent = EventData()
    var didSelectFilter = false
    var filterSelection: String?
    
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        // How far we want to zoom in
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        // Region we want to be zoomed in on
        let userLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        // Sets the map region to user's location
        let region:MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
        
        // Sets the map region
        map.setRegion(region, animated: true)
        
        // Shows blue dot on map
        // self.map.showsUserLocation = true
        
        //stop updating location
        manager.stopUpdatingLocation()
      
    }
    func retrieveContacts()
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
                        
                        
                    }
                   
                    Database.database().reference().child("Users").child(userID!).child("contacts").removeAllObservers()
                })
            }
//            NotificationCenter.default.post(name: Notification.Name("contactsReady"), object: nil)
//            print("sending notification")
            Database.database().reference().child("Users").removeAllObservers()
            
        })
        
    }
    
    // viewDidLoad function
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Main Menu", style: .done, target: self, action: #selector(mainMenuButtonTapped))
        
        map.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        self.map.showsUserLocation = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(mapViewController.addAnnotations), name: Notification.Name("weDone"), object: nil)
        
        retrieveDataEvents()
        retrieveContacts()
        
        //adding an oberserver to wait until the retrieveDataEvents finishes
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addAnnotations()
    }
    
    @objc func selectFilter() {
        didSelectFilter = true
        performSegue(withIdentifier: "map2filter", sender: self)
        self.viewDidLoad()
    }
    
    
    @objc func addAnnotations()
    {
        print("size of events when adding annotations: \(events.count)")
        events.forEach
        { (event) in
            
//            The expiration date is stored as a time interval since 1970. when reading from firebase, can convert it back to NSDate by:
//            var date = NSDate(timeIntervalSince1970: interval)
//            where interval is what you pull from firebase
            
            
            var currentTime = NSDate().timeIntervalSince1970
            

            // If a filter was selected.
            if (didSelectFilter == true)
            {
                if (currentTime <= event.expiration )
                {
                    if(hangoutFilter == true && event.KastTag == "Hang Out")
                    {
                        let annotation = MKPointAnnotation()
                        annotation.title = event.title
                        annotation.coordinate = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
                        
                        DispatchQueue.main.async
                            {
                                self.map.addAnnotation(annotation)
                        }
                    }
                    if(partyFilter == true && event.KastTag == "Party")
                    {
                        let annotation = MKPointAnnotation()
                        annotation.title = event.title
                        annotation.coordinate = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
                        
                        DispatchQueue.main.async
                            {
                                self.map.addAnnotation(annotation)
                        }
                    }
                    if(studyFilter == true && event.KastTag == "Study")
                    {
                        let annotation = MKPointAnnotation()
                        annotation.title = event.title
                        annotation.coordinate = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)

                        DispatchQueue.main.async
                        {
                            self.map.addAnnotation(annotation)
                        }
                    }
                    if(sportFilter == true && event.KastTag == "Sport")
                    {
                        let annotation = MKPointAnnotation()
                        annotation.title = event.title
                        annotation.coordinate = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
                        
                        DispatchQueue.main.async
                            {
                                self.map.addAnnotation(annotation)
                        }
                    }
                    if(foodFilter == true && event.KastTag == "Food")
                    {
                        let annotation = MKPointAnnotation()
                        annotation.title = event.title
                        annotation.coordinate = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
                        
                        DispatchQueue.main.async
                            {
                                self.map.addAnnotation(annotation)
                        }
                    }
                }
            }
                
            // If no filter was selected.
            else
            {
                if (currentTime <= event.expiration)
                {
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = event.title
                    annotation.coordinate = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
                    
                    DispatchQueue.main.async
                    {
                        self.map.addAnnotation(annotation)
                    }
                }
            }
        }
        
    }
    // didReceiveMemoryWarning function
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveDataEvents()
    {
        events = [EventData]()
        
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
                
                
                
                
                
                
                events.append(temporaryLocation)
                print("events count: \(events.count)")
            })
           //print("sending notification")
            NotificationCenter.default.post(name: Notification.Name("weDone"), object: nil)
       })
        
       
       
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        }
        else {
            annotationView!.annotation = annotation
        }
        
        annotationView?.canShowCallout = true
        annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        
        
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        guard let annotation = view.annotation else
        {
            return
        }
        
        events.forEach { (event) in
            if annotation.title as? String == event.title
            {
                clickedEvent = event
            }
        }
        performSegue(withIdentifier: "map2details", sender: self)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "map2details")
        {
            let dvc = segue.destination as! EventDetailsViewController
            dvc.eventToView = clickedEvent
        }
        if(segue.identifier == "map2filter")
        {
            let filtervc = segue.destination as! FilterSelectionViewController
            if didSelectFilter == true {
                filtervc.studyTag = studyFilter
                filtervc.sportTag = sportFilter
                filtervc.foodTag = foodFilter
                filtervc.partyTag = partyFilter
                filtervc.hangoutTag = hangoutFilter
            }
            else {
                filtervc.studyTag = false
                filtervc.sportTag = false
                filtervc.foodTag = false
                filtervc.partyTag = false
                filtervc.hangoutTag = false
            }
        }
    }
    
    @objc func mainMenuButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func PrivateButton(_ sender: PrivacyButton) {
        //so contact list of the current user is stored in the array of strings named users
        
    }
    

    
    @IBAction func ActivateFilters(_ sender: FilterButton) {
        map.removeAnnotations(self.map.annotations)
        performSegue(withIdentifier: "map2filter", sender: self)
    }

}

