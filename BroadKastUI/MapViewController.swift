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

class mapViewController: UIViewController, CLLocationManagerDelegate {

    
    // Map
    @IBOutlet weak var map: MKMapView!
    
    let manager = CLLocationManager()
    
    /* class CityLocation: NSObject, MKAnnotation {
        var title: String?
        var coordinate: CLLocationCoordinate2D
        
        
        init(title: String, coordinate: CLLocationCoordinate2D) {
            self.title = title
            self.coordinate = coordinate
        }
    } */
    struct EventData {
        var long: Double
        var lat: Double
        var title: String
    }
    
    class EventLocation: NSObject, MKAnnotation {
        var title: String?
        var coordinate: CLLocationCoordinate2D
        
        init(title: String, coordinate: CLLocationCoordinate2D) {
            self.title = title
            self.coordinate = coordinate
        }
    }
    
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
      
    }
 
    // viewDidLoad function
    override func viewDidLoad()
    {
        super.viewDidLoad()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        // TODO:
            // Create array of EventData structs holding Firebase event data
        var events: [EventData] = []
        var eventLocations: [EventLocation] = []
            // Populate array up to 10 using coordinates and titles
        var i: Int = 0
        
        eventLocations[i] = EventLocation(title: events[i].title, coordinate: CLLocationCoordinate2D(latitude: events[i].lat, longitude: events[i].long))
        map.addAnnotation(eventLocations[i])
        
        
        /* let delhi = CityLocation(title: "Delhi", coordinate: CLLocationCoordinate2D(latitude: 28.619570, longitude: 77.088104))
        let kashmir = CityLocation(title: "Kahmir", coordinate: CLLocationCoordinate2D(latitude: 34.1490875, longitude: 74.0789389))
        let gujrat = CityLocation(title: "Gujrat", coordinate: CLLocationCoordinate2D(latitude: 22.258652, longitude: 71.1923805))
        let kerala = CityLocation(title: "Kerala", coordinate: CLLocationCoordinate2D(latitude: 9.931233, longitude:76.267303))*/
        
        

        /* map.addAnnotation(delhi)
        map.addAnnotation(kashmir)
        map.addAnnotation(gujrat)
        map.addAnnotation(kerala)*/
        
       
        
       
        
        // BEGIN LOOP
        
        
        
        
        
       // let annotation = MKPointAnnotation()
       
    
        /* annotation.coordinate = eventLocation
        annotation.title = events[i].title
        
        map.addAnnotation(annotation) */
        
    }
    
    // didReceiveMemoryWarning function
    override func didReceiveMemoryWarning()
    {
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
