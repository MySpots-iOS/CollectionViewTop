//
//  MySpots.swift
//  CollectionView2
//
//  Created by ayako_sayama on 2017-06-18.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

class MySpots{
    
    var spotName:String?
    var folderImage:UIImage?
    
    var longitude: Double?
    var latitude: Double?
    
    init(spotName: String, folderImage:UIImage, latitude:Double, longitude:Double) {
        self.spotName = spotName
        self.folderImage = folderImage
        self.latitude = latitude
        self.longitude = longitude
    }

}
