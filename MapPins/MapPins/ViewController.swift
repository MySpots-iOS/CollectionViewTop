//
//  ViewController.swift
//  MapPins
//
//  Created by ayako_sayama on 2017-06-18.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    let locations = [
        ["title": "New York, NY",    "latitude": 40.713054, "longitude": -74.007228],
        ["title": "Los Angeles, CA", "latitude": 34.052238, "longitude": -118.243344],
        ["title": "Chicago, IL",     "latitude": 41.883229, "longitude": -87.632398]
    ]
    
    let locations2 = [
        ["title": "Vancouver, BC",    "latitude": 40.713054, "longitude": -74.007228],
        ["title": "Los Angeles, CA", "latitude": 34.052238, "longitude": -118.243344],
        ["title": "Chicago, IL",     "latitude": 41.883229, "longitude": -87.632398]
    ]
    
    

    @IBOutlet weak var mapView: MKMapView!
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location["title"] as? String
            annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
            mapView.addAnnotation(annotation)
        }
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: Override CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }

}

