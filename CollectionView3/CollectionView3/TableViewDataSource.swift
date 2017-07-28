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
    
    
    var folder:Folder
    
    init(_ folder:Folder) {
        self.folder = folder
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder.spots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        
        cell.placeName.text = "My name is ayako"
        
        let spot = folder.spots[indexPath.row]
        cell.placeName.text = spot.spotName
        cell.placeAddress.text = spot.placeID
        
        return cell
    }

}
