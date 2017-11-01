//
//  mapViewController.swift
//  BroadKastUI
//
//  Created by Ubicomp4 on 10/19/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

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
    init() {
        description = ""
        KastTag = ""
        title = ""
        user = ""
        latitude = 0
        longitude = 0
    }
}

class EventLocation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    let pointAnnotation = MKPointAnnotation()
    
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = " "
        self.coordinate = coordinate
        pointAnnotation.coordinate = self.coordinate
    }
}

var events = [EventData]()

class mapViewController: UIViewController, CLLocationManagerDelegate
{
    // Map
    
    @IBOutlet weak var map: MKMapView!
    
    let manager = CLLocationManager()
    
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        // How far we want to zoom in
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        
        // Region we want to be zoomed in on
        let userLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        // Sets the map region to user's location
        let region:MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
        
        // Sets the map region
        map.setRegion(region, animated: true)
        
        // Shows blue dot on map
        self.map.showsUserLocation = true
        //stop updating location
        manager.stopUpdatingLocation()
      
    }
    
   
    
    // viewDidLoad function
    override func viewDidLoad()
    {
        super.viewDidLoad()
       

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
       NotificationCenter.default.addObserver(self, selector: #selector(mapViewController.addAnnotations), name: Notification.Name("weDone"), object: nil)
        
        retrieveDataEvents()
        //adding an oberserver to wait until the retrieveDataEvents finishes
        
        
        
        
       
        
    }
    @objc func addAnnotations()
    {
        print("size of events when adding annotaionts: \(events.count)")
        events.forEach
            { (event) in
                
                let annotation = MKPointAnnotation()
                annotation.title = event.title
                annotation.subtitle = event.description
                annotation.coordinate = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
                
                DispatchQueue.main.async
                    {
                        self.map.addAnnotation(annotation)
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
                    default:
                        print(item.key + " does not contain anything ERROR")
                    }
                })
                events.append(temporaryLocation)
                print("events count: \(events.count)")
            })
            print("sending notification")
            NotificationCenter.default.post(name: Notification.Name("weDone"), object: nil)
        })
        
       
       
        
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
