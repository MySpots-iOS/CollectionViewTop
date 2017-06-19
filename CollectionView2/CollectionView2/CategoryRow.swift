//
//  CategoryRow.swift
//  CollectionView2
//
//  Created by ayako_sayama on 2017-06-17.
//  Copyright © 2017 ayako_sayama. All rights reserved.

//1. getCurrentLocation
//2. show currentLocation on map
//3. get Locations from MySpot.locations
//4. show them on pin

import UIKit

class CategoryRow : UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
//    var cellNum = ["Beach", "FriendsHouse", "Party", "Drinking", "Cities"]
    
 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as! FolderCell
        print("This is seg1!")
        return cell
    }
    
    
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print("This is seg2!")

        
        if segue.identifier == "mySpotsMap" {
            
            print("This is seg3!")
            
            let mapVC = segue.destination as! MySpotsMapVC
            let indexPath = sender as? Int
//            mapVC.folderName = "\(cellNum[indexPath!])"
            
            let locations = [
                Location(folderID: indexPath!, spotName: "New York, NY", latitude: 40.713054, longitude: -74.007228),
                
                Location(folderID: indexPath!, spotName: "Los Angeles, CA", latitude: 34.052238, longitude: -118.243344),
                
                Location(folderID: indexPath!, spotName: "Chicago, IL", latitude: 41.883229, longitude: -87.632398)
            ]
            
//            let mySpots = MySpots(folderName: "\(cellNum[indexPath!])", locations: locations)
            mapVC.loca = locations
        }
        

    
    }
}




extension CategoryRow : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 2.5
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
