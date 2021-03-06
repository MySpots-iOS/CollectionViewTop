//
//  MapViewDelegate.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-07-09.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewDelegate: NSObject, GMSMapViewDelegate{
    
    var vc:CommonViewController!
    var savedMarker:GMSMarker!
    
    var markers:[GMSMarker]!
    
    init(_ vc:CommonViewController, _ markers:[GMSMarker]) {
        super.init()
        self.vc = vc
        self.markers = markers
        let polyLine: GMSPolyline = GMSPolyline()
        polyLine.isTappable = true
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        var isSaved:Bool = false
        
        if markers.contains(marker){
            isSaved = true
        }
        vc.markerTapped(marker, isSaved)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if savedMarker != nil{
            savedMarker.map = nil
        }
        vc.coordinateTapped()
    }
    
    
    func mapView(_ mapView:GMSMapView, didTapPOIWithPlaceID placeID:String,
                 name:String, location:CLLocationCoordinate2D) {
        print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
        
        
        let infoMarker = GMSMarker(position: location)
//        infoMarker.snippet = placeID
        infoMarker.title = name
        infoMarker.appearAnimation = .pop
//        infoMarker.infoWindowAnchor.y = 1
        infoMarker.userData = placeID
        infoMarker.map = mapView
        mapView.selectedMarker = infoMarker
    
        
        if savedMarker != nil{
            savedMarker.map = nil
        }
        savedMarker = infoMarker
        
        let isSaved = false
        vc.markerTapped(infoMarker, isSaved)
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D, marker: GMSMarker) {
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                
                let title = address.lines as [String]?
                marker.title = title?.first
                
                UIView.animate(withDuration: 0.25) {
                }
            }
        }
    }


}
