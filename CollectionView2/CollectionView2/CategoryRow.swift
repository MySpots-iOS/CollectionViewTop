//
//  CategoryRow.swift
//  CollectionView2
//
//  Created by ayako_sayama on 2017-06-17.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

class CategoryRow : UITableViewCell{
    @IBOutlet weak var collectionView: UICollectionView!

    
}

extension CategoryRow : UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as! FolderCell
        return cell
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mySpotsMap" {
            let mapVC = segue.destination as! MySpotsMapVC
            //            let indexPath = sender as! NSIndexPath
            
            let image = UIImage(named: "mySpot1")
            let mySpots = MySpots(spotName: "Cornerstone", folderImage: image!, latitude: 49.285131, longitude: -123.112998)
            mapVC.myspots = mySpots
        }
    }
    
    // Set the indexPath of the selected item as the sender for the segue
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        
//        performSegue(withIdentifier: "mySpotsMap", sender: indexPath)
//    }

    
    
    
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
