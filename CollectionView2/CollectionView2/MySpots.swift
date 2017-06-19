//
//  MySpots.swift
//  CollectionView2
//
//  Created by ayako_sayama on 2017-06-18.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit



class MySpots{
    
    var folderName:String
//    var folderImage:UIImage
    var locations:[Location]

    
    init(folderName:String, locations:[Location]) {
        self.folderName = folderName
//        self.folderImage = UIImage(named: "mySpots1")!
        self.locations = locations
    }
//        self.locations = [
//            Location(spotName: "New York, NY", latitude: 40.713054, longitude: -74.007228),
//            Location(spotName: "Los Angeles, CA", latitude: 34.052238, longitude: -118.243344),
//            Location(spotName: "Chicago, IL", latitude: 41.883229, longitude: -87.632398)
//        ]
}


class Location{
    var folderID: Int?
    var spotName: String?
    var longitude: Double?
    var latitude: Double?
    
    init(folderID: Int, spotName: String, latitude:Double, longitude:Double) {
        self.folderID = folderID
        self.spotName = spotName
        self.latitude = latitude
        self.longitude = longitude
    }
}
