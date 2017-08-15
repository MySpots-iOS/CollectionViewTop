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
    var markers:[GMSMarker] = []
    var vcFlag:ViewControllerFlag!
    
    init(_ mapView: GMSMapView, _ markers:[GMSMarker], _ vcFlag:ViewControllerFlag) {
        super.init()
        self.mapView = mapView
        self.markers = markers
        self.vcFlag = vcFlag
        
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
        
//        let marker = GMSMarker(position: location.coordinate)
//        markers.append(marker)
        
        let camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)

        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        

            if vcFlag == .mapVC{
                var bounds = GMSCoordinateBounds()
                for marker in self.markers {
                    bounds = bounds.includingCoordinate(marker.position)
                }
                mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(50.0, 100.0 ,50.0 ,50.0)))
            } else{
                let camera = GMSCameraPosition(target: (markers.first?.position)!, zoom: 15, bearing: 0, viewingAngle: 0)
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
        print("LocationManagerError: \(error)")
    }
}
