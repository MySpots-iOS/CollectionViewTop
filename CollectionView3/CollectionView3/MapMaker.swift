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
    
    func makeMarkers(mapView: GMSMapView, folder: Folder) -> [GMSMarker]{
        
        let data:Folder? = folder
        var markers:[GMSMarker] = []
        
        if (data != nil){
            for spot in (data?.spots)!{
                let marker = makeMarker(spot: spot)
                marker.map = mapView
                markers.append(marker)
            }
        }
        
        return markers
    }
    
    func makeMarker(spot: Spot) -> GMSMarker {
        
        let map = CLLocationCoordinate2D.init(latitude: spot.latitude!, longitude: spot.longitude!)
        let marker = GMSMarker(position: map)
        marker.snippet = spot.spotName!
        marker.icon = GMSMarker.markerImage(with: UIColor.green)
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
