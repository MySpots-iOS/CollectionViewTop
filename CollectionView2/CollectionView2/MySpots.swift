//
//  MySpots.swift
//  CollectionView2
//
//  Created by ayako_sayama on 2017-06-18.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

class MySpots{
    
    var spotName:String
    var longitude: Float
    var latitude: Float
    
    init(spotName: String, latitude:Float, longitude:Float) {
        self.spotName = spotName
        self.latitude = latitude
        self.longitude = longitude
    }

}
