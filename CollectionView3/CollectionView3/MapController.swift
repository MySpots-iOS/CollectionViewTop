//
//  MapController.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-06-30.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit
import GoogleMaps

import Firebase




class MapController{

    let refMap = Database.database().reference().child("MySpotsFolder")

    
    var spots:[Spot] = []

    let map1 = CLLocationCoordinate2D.init(latitude: 49.288102, longitude: -123.113128)
    let placeID1 = "ChIJ32puLoJxhlQRusnG9dNlmzU"
    
    let map2 = CLLocationCoordinate2D.init(latitude: 49.288826, longitude: -123.114628)
    let placeID2 = "ChIJ32puLoJxhlQRusnG9dNlmzU"
    
    let map3 =  CLLocationCoordinate2D.init(latitude: 49.280515, longitude: -123.116851)
    let placeID3 = "ChIJ32puLoJxhlQRusnG9dNlmzU"
    
    
    init(folderIndex:Int) {
        
        firstInit(folderIndex: folderIndex)
    }

    
    func firstInit(folderIndex:Int){
        
        let query = self.refMap.queryOrdered(byChild: "folderName").queryEqual(toValue: "Cafes")
        
        query.observe(.value, with: { (snapshot) in
            
            for spot in snapshot.children{
                let newSpot: Spot?
                
                if let snap = spot as? DataSnapshot {
                    newSpot = self.makeSpot(snap)
                    self.spots.append(newSpot!)
                }
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue:"FirebaseNotification"), object: nil)
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    func makeSpot(_ spots:DataSnapshot) -> Spot{
        
        let newSpot = Spot()
        let value = spots.value as? NSDictionary
        
        
        if let folderID = value?["folderID"] {
            newSpot.folderID = folderID as? NSNumber
        }
        
        if let placeID = value?["placeID"]{
            newSpot.placeID = placeID as? String
        }
        
        if let spotName = value!["spotName"]{
            newSpot.spotName = (spotName as? String)!
        }
        
        if let latitude = value?["latitude"] {
            newSpot.latitude = (latitude as? Double)!
        }
        
        if let longitude = value?["longitude"] {
            newSpot.longitude = (longitude as? Double)!
        }
        
        print("newSpot3: \(String(describing: newSpot.spotName))")
        
        return newSpot
    }

    
    
    func makeMarker(mapView: GMSMapView, folderIndex: Int) -> [GMSMarker] {
        
        print("FolderIndex: \(folderIndex)")

//        let data = DataSource.getFolderLabelAtIndex(<#T##DataSource#>)
//        
//        if data != nil{
//            print("folders!:\(String(describing: data)) ")
//        } else{
//            print("not there")
//        }
        
 
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
        
        print("MarkersDone")

        
        return [marker, marker2, marker3]
    }
    
}
