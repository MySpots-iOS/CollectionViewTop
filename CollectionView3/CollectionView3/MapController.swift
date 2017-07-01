//
//  MapController.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-06-30.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit
import GoogleMaps


class MapController{


    
    let map1 = CLLocationCoordinate2D.init(latitude: 37.7859022974905, longitude: -122.410837411881)
    let placeID1 = "ChIJAAAAAAAAAAARembxZUVcNEk"
    
    let map2 = CLLocationCoordinate2D.init(latitude: 37.7906928118546, longitude: -122.405601739883)
    let placeID2 = "ChIJAAAAAAAAAAARknLi-eNpMH8"
    
    let map3 =  CLLocationCoordinate2D.init(latitude: 37.7887342497061, longitude: -122.407184243202)
    let placeID3 = "ChIJAAAAAAAAAAARdxDXMalu6mY"
    
    
    func makeMarker(mapView: GMSMapView) -> [GMSMarker] {
        
        let marker = GMSMarker(position: map1)
        marker.snippet = placeID1
        marker.icon = GMSMarker.markerImage(with: UIColor.black)
        marker.map = mapView
        
        let marker2 = GMSMarker(position: map2)
        marker2.snippet = placeID2
        marker2.icon = GMSMarker.markerImage(with: UIColor.black)
        marker2.map = mapView
        
        let marker3 = GMSMarker(position: map3)
        marker3.snippet = placeID3
        marker3.icon = GMSMarker.markerImage(with: UIColor.black)
        marker3.map = mapView
        
        // TODO set flag which is stored or not
        marker.userData = "test"
        marker2.userData = "test"
        marker3.userData = "test"
        
        return [marker, marker2, marker3]
    }


    
}
