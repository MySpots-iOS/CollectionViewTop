//
//  Model.swift
//  CollectionViewTop
//
//  Created by ayako_sayama on 2017-06-19.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

class ToppageCategory: NSObject{
    
    var name:String?
    var folders:[Folder]?
    
    
    //本番のデータここから呼ぶ
    

    
    //仮でデータを作っている(viewControllerから　SampleAppCategoriesが呼ばれている)
    static func topPageCategories() -> [ToppageCategory]{
        
        //1. Cateogry1
        
        let mySpotsCat = ToppageCategory()
        mySpotsCat.name = "My Spots"
        
        
        //ここから先のデータをDatabaseでひっぱってくる！
        var folders = [Folder]()
        
        let folder1 = Folder()
        folder1.folderName = "Cafes"
        folder1.category = "Food"
        folder1.imageName = "cafe1"
        folder1.spotsNum = 10
        
        
        let folder2 = Folder()
        folder2.folderName = "SuperMaret"
        folder2.category = "Food"
        folder2.imageName = "cafe2"
        folder2.spotsNum = 4
        
        folders.append(folder1)
        folders.append(folder2)
        
        mySpotsCat.folders = folders
    
        //2. Cateogory2
        
        let exploreCat = ToppageCategory()
        exploreCat.name = "Expore"
        
        var exploreFolders = [Folder]()
        
        let exploreFolder1 = Folder()
        exploreFolder1.folderName = "Hiking Area"
        exploreFolder1.category = "Outdoor"
        exploreFolder1.imageName = "hiking1"
        exploreFolder1.spotsNum = 8
        
        exploreFolders.append(exploreFolder1)

        exploreCat.folders = exploreFolders
        
        
        return [mySpotsCat, exploreCat]

    }
    
}


class Folder: NSObject {
    
    var id: NSNumber?
    var folderName: String?
    var category: String?
    var imageName: String?
    var spotsNum: Int?
}



class Spot:NSObject{
    
    var folderID:NSNumber?
    var spotName:String?
    var latitude:Double?
    var longitude:Double?
    
}


//extension Spot{
//    
//    class MySpot:NSObject{
//        var folderID:NSNumber?
//        var spotName:String?
//        var latitude:Double?
//        var longitude:Double?
//    }
//    
//    class ExploreSpot:NSObject{
//        var folderID:NSNumber?
//        var spotName:String?
//        var latitude:Double?
//        var longitude:Double?
//    }
//}


