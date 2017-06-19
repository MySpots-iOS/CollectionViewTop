//
//  Location.swift
//  MapPins
//
//  Created by ayako_sayama on 2017-06-18.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

class Location{
    
    private var folderID:Int?
    private var title:String?
    private var latitude:Double?
    private var longitude:Double?
    
    init(folderID:Int, title:String, latitude:Double, longitude:Double) {
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
        self.folderID = folderID
    }

    
}
