//
//  DropPinViewController.swift
//  BroadKastUI
//
//  Created by Ubicomp4 on 10/23/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase

extension DropPinViewController{
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? createViewController)?.data = data // Here you pass the to your original view controller
    }
}

class DropPinViewController: UIViewController, UINavigationControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    var data = Data()
    
    var myLocation: CLLocationCoordinate2D?
    
    @IBOutlet weak var map: MKMapView!
    let manager = CLLocationManager()
    
    /*func setInitialLocation(_ manager: CLLocationManager, locations: [CLLocation])
    {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        // Sets the map region
        map.setRegion(region, animated: true)
        
        // Shows blue dot on map
        self.map.showsUserLocation = true
        
    }*/
    
    func addLongPressGesture()
    {
        let longPressRecogniser:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DropPinViewController.addPin))
        longPressRecogniser.minimumPressDuration = 1.0
        
        self.map.addGestureRecognizer(longPressRecogniser)
    
    }
    
    @objc func addPin(_ gestureRecogniser:UIGestureRecognizer){
        if gestureRecogniser.state != .began{
            return
        }
        self.map.removeAnnotations(map.annotations)
        let touchPoint:CGPoint = gestureRecogniser.location(in: self.map)
        let touchMapCoordinate:CLLocationCoordinate2D = self.map.convert(touchPoint, toCoordinateFrom: self.map)
        
        let annot:MKPointAnnotation = MKPointAnnotation()
        annot.coordinate = touchMapCoordinate
        
        
        self.map.addAnnotation(annot)
       
        data.lat = annot.coordinate.latitude
        data.long = annot.coordinate.longitude
        print("\(annot.coordinate.latitude)    \(annot.coordinate.longitude)")
        
    }
    
    
    
    func saveCurrentLocation(_ center: CLLocationCoordinate2D)
    {
        myLocation = center
    }
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        self.manager.requestWhenInUseAuthorization()
        map.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        addLongPressGesture()
       
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        // Zooms in on the user's location
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        // Sets the map region
        map.setRegion(region, animated: true)
        
        // Shows blue dot on map
        self.map.showsUserLocation = true
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
