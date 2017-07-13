//
//  MapMaker.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-07-09.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import Foundation
import GoogleMaps

class MapMaker {
    
    func makeMarkers(mapView: GMSMapView, folder: Folder){
        
        let data:Folder? = folder
        
        if (data != nil){
            for spot in (data?.spots)!{
                let marker = makeMarker(spot: spot)
                marker.map = mapView
            }
        }
        
    }
    
    func makeMarker(spot: Spot) -> GMSMarker {
        
        let map = CLLocationCoordinate2D.init(latitude: spot.latitude!, longitude: spot.longitude!)
        let marker = GMSMarker(position: map)
        marker.snippet = spot.spotName!
        marker.icon = GMSMarker.markerImage(with: UIColor.red)
        marker.userData = spot.placeID
        
        return marker
    }
    

}

//extension GMSMarker{
//    var isSaved:Bool = false
//    func getSaved() -> Bool {
//            return isSaved
//        }
//}
