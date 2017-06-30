//
//  DataSource.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-06-29.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import Foundation
import Firebase

class DataSource {
    
//    let ref = Database.database().reference()
    let firebasePath: String = "MySpotsFolder"
    
    var folders:[Folder] = []

    
    init() {
//        populateData()
        firstInit()
    }
    
//    var spots:[Spot] = []
    
    
//    func numbeOfRowsInEachGroup(_ index: Int) -> Int {
//        return spotsInFolder(index).count
//    }
//    
    func numberOfFolders() -> Int {
        return folders.count
    }
//
//    func getFolderLabelAtIndex(_ index: Int) -> String {
//        return folders[index].folderName!
//    }
    
    // MARK:- Populate Data from plist
    
//    func populateData() {
//        if let path = Bundle.main.path(forResource: "fruits", ofType: "plist") {
//                for item in dictArray {
//   
//            }
//        }
//    }
    
    func firstInit(){

//        self.ref.child(firebasePath).observeSingleEvent(of: .value, with: { (snapshot) in
//            for folder in snapshot.children {
//                if let snap = folder as? DataSnapshot {
//                    let folder = self.makeFolder(folder: snap)
//                    self.folders.append(folder)
//                }
//            }
//            
//            NotificationCenter.default.post(name: Notification.Name(rawValue:"FirebaseNotification"), object: nil)
//            
//        }) { (error) in
//            print(error.localizedDescription)
//        }
    }
   
    
//    func makeFolder(folder:DataSnapshot) -> Folder {
//        
//        let newFolder = Folder()
//        
//        //print("make folder: \(folder.value ?? "no value")")
//        
//        let value = folder.value as? NSDictionary
//        
//        if let category = value?["category"] {
//            newFolder.category = category as? String
//        }
//        
//        if let folderName = value?["folderName"] {
//            newFolder.folderName = folderName as? String
//        }
//        
//        if let imageName = value?["imageName"] {
//            newFolder.imageName = imageName as? String
//        }
//        
//        if let spotsNum = value?["spotsNum"] {
//            newFolder.spotsNum = spotsNum as? Int
//        }
//        
//        return newFolder
//    }

    
    // MARK:- FruitsForEachGroup
    
//    func spotsInFolder(_ index: Int) -> [Spot] {
//        let item = folders[index]
//        let filteredSpots = spots.filter { (spot: Spot) -> Bool in
//            return spot.folderID == item
//        }
//        return filteredSpots
//    }
    
    // MARK:- Add Dummy Data
    
//    func addAndGetIndexForNewItem() -> Int {
//        
//        let spot = Spot()
//        
//        let count = spotsInFolder(0).count
//        
//        let index = count > 0 ? count - 1 : count
//        spots.insert(spot, at: index)
//        
//        return index
//    }
    
    // MARK:- Delete Items
    
//    func deleteItems(_ items: [Fruit]) {
//        
//        for item in items {
//            // remove item
//            let index = fruits.indexOfObject(item)
//            if index != -1 {
//                fruits.remove(at: index)
//            }
//        }
//    }
    
    
}

//extension Array {
//    func indexOfObject<T:AnyObject>(_ item:T) -> Int {
//        var index = -1
//        for element in self {
//            index += 1
//            if item === element as? T {
//                return index
//            }
//        }
//        return index
//    }
//}


