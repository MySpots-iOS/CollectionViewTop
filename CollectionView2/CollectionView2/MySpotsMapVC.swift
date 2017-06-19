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
    
    var myspots: MySpots?
    
    @IBOutlet weak var bigMap: MKMapView!
    
    
    var locationManager = CLLocationManager.init()
    //    var mapView:MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.bigMap.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.bigMap.showsUserLocation = true
    

//        if let myspots = myspots {
//            myspots.spotName = "Cornerstone"
//            navigationItem.title = myspots.spotName?.capitalized
//            myspots.latitude = 49.285131
//            myspots.longitude = -123.112998
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        view.backgroundColor = UIColor.yellow
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        
        let newPin = MKPointAnnotation()
        
        newPin.title = myspots?.spotName
        newPin.coordinate = CLLocationCoordinate2D(latitude: (myspots?.latitude!)!, longitude: (myspots?.longitude!)!)
        bigMap.addAnnotation(newPin)
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if let annotation = annotation as? MySpots {
//            let identifier = "pin"
//            var view: MKPinAnnotationView
//            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//                as? MKPinAnnotationView { // 2
//                dequeuedView.annotation = annotation as? MKAnnotation
//                view = dequeuedView
//            } else {
//                // 3
//                view = MKPinAnnotationView(annotation: annotation as? MKAnnotation, reuseIdentifier: identifier)
//                view.canShowCallout = true
//                view.calloutOffset = CGPoint(x: -5, y: 5)
//                view.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIView
//
//            }
//            return view
//        }
//        return nil
//    }
    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        // Create and Add MapView to our main view
//        createMapView()
//    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        determineCurrentLocation()
    }

//    func createMapView()
//    {
//        mapView = MKMapView()
//        
//        let leftMargin:CGFloat = 10
//        let topMargin:CGFloat = 60
//        let mapWidth:CGFloat = view.frame.size.width-20
//        let mapHeight:CGFloat = 300
//        
//        
//        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
//        
//        mapView.mapType = MKMapType.standard
//        mapView.isZoomEnabled = true
//        mapView.isScrollEnabled = true
//        
//        // Or, if needed, we can position map in the center of the view
//        mapView.center = view.center
//        
//        view.addSubview(mapView)
//    }
//    
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //set region on the map
        bigMap.setRegion(region, animated: true)
        
//        let newPin =
        let newPin = MKPointAnnotation()
        
        newPin.title = myspots?.spotName
        newPin.coordinate = CLLocationCoordinate2D(latitude: (myspots?.latitude!)!, longitude: (myspots?.longitude!)!)
        bigMap.addAnnotation(newPin)
        
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last
//        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
//        
//        self.bigMap.setRegion(region, animated: true)
//        self.locationManager.stopUpdatingLocation()
//        
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors " + error.localizedDescription)
    }
    
}
