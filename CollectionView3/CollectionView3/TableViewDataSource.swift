//
//  TableViewDelegate.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-07-20.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class TableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate{
    
    var markers:[GMSMarker]!
    var placesClient:GMSPlacesClient!
    
    init(_ markers:[GMSMarker], _ placesClient:GMSPlacesClient) {
        self.markers = markers
        self.placesClient = placesClient
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        
        cell.placeName.text = "My name is ayako"


        placesClient.lookUpPlaceID(markers[indexPath.row].snippet!, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                //print("No place details for \(placeID)")
                return
            }
            cell.placeName.text = place.name
            cell.placeAddress.text = place.formattedAddress
            //            cell.placeRating.text = String(place.rating)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue:"TableViewNotification"), object: nil)

        })
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("cell tapped: \(indexPath.row)")
////        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! SpotDetailViewController
////        //set placeID
////        vc.placeID = (self.markers[indexPath.row].snippet)!
////        self.navigationController?.pushViewController(vc, animated: true)
//    }
}
