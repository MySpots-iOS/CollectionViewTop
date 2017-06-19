//
//  MySpotsMapVC.swift
//  CollectionView2
//
//  Created by ayako_sayama on 2017-06-18.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import MapKit
import UIKit
import CoreLocation

class MySpotsMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
   
    var loca:[Location] = []
    var folderName:String = ""
    var myspots:MySpots!
    

    @IBOutlet weak var bigMap: MKMapView!
    var locationManager = CLLocationManager.init()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myspots = MySpots(folderName: "\(folderName)", locations: self.loca)
        
        self.locationManager.delegate = self
        self.bigMap.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.bigMap.showsUserLocation = true
        
        
        print("name: \(myspots.locations[1].spotName ?? "No name")")

        
        
//        for (index,location) in loca.enumerated(){
//            
//            print("\(String(describing: location.spotName))")
//            
//            let annotation = MKPointAnnotation()
//            annotation.title = loca[index].spotName
//            annotation.coordinate = CLLocationCoordinate2D(latitude: loca[index].latitude!, longitude: loca[index].longitude!)
//            bigMap.addAnnotation(annotation)
//        }
//        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        determineCurrentLocation()
        
    
        
        
        let annotation = MKPointAnnotation()
        annotation.title = "New York, NY"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 40.713054, longitude: -74.007228)
        bigMap.addAnnotation(annotation)

        
    }

    
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
  
    

    
}
