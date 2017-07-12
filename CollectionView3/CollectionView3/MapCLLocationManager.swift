//
//  MapCLLocationManager.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-07-09.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapCLLocationManager: NSObject, CLLocationManagerDelegate{
    
    var mapView:GMSMapView!
    fileprivate var zoomLevel: Float = 15.0

    var locationManager = CLLocationManager()

    
    init(_ mapView: GMSMapView) {
        super.init()
        self.mapView = mapView
        
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
    }

    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        //print("Location: \(location)")
        
//        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        let camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)

        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }

    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
//            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true

            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
