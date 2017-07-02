
import Foundation
import Firebase

class DataSource {
    
    let ref = Database.database().reference()
    let firebasePath: String = "MySpotsFolder"
    
    var folders:[Folder] = []
    
    
    init() {
        firstInit()
    }
    
    func numberOfFolders() -> Int {
        return folders.count
    }
    
    func numberOfSpots(_ index: Int) -> Int{
        
        if folders[index].spots?.count != nil{
            return (folders[index].spots?.count)!
        }
        return 0
    }

    func getFolderLabelAtIndex(_ index: Int) -> String {
        return folders[index].folderName!
    }
    
    func getImageNameAtIndex(_ index: Int) -> String{
        return folders[index].imageName!
    }
    
    
    func firstInit(){

        self.ref.child(firebasePath).observe(.value, with: { (snapshot) in
//        self.ref.child(firebasePath).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            for folder in snapshot.children{
                let newFolder: Folder?
                
                print("Readme")

            
                if let snap = folder as? DataSnapshot {
                    newFolder = self.makeFolder(folder: snap)
                    self.folders.append(newFolder!)
                    
                    print(newFolder?.imageName ?? 0)
                    
//                    if let snapSpots = (folder as? DataSnapshot)?.childSnapshot(forPath: "Spot") {
//                        
//                        for spot in snapSpots.children{
//                            if let snap = spot as? DataSnapshot{
//                                let newSpot = self.makeSpot(snap)
//                                newFolder?.spots?.append(newSpot)
//                                
//                                print(newSpot.spotName ?? "noname")
//                            }
//                            
//                        }
//                        
//                    }
                }

            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue:"FirebaseNotification"), object: nil)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
   
    
    func makeFolder(folder:DataSnapshot) -> Folder {
        
        let newFolder = Folder()
        
        let value = folder.value as? NSDictionary
        
        if let category = value?["category"] {
            newFolder.category = category as? String
        }
        
        if let folderName = value?["folderName"] {
            newFolder.folderName = folderName as? String
        }
        
        if let imageName = value?["imageName"] {
            newFolder.imageName = imageName as? String
        }
        

        let spots = folder.childSnapshot(forPath: "Spots")
        print(spots.children)


//        for spot in spots.children{
//            if let snap = spot as? DataSnapshot{
//                let newSpot = makeSpot(snap)
//                newFolder.spots?.append(newSpot)
//                
//                print(newSpot.spotName ?? "noname")
//            }
//            
//            
//        }
//        
//        print(newFolder.spots?.count ?? 0)
        
        return newFolder
    }

    
    func makeSpot(_ spots:DataSnapshot) -> Spot{
        
        let newSpot = Spot()
        let value = spots.value as? NSDictionary
        
        
        if let folderID = value?["folderID"] {
            newSpot.folderID = folderID as? NSNumber
        }
        
        if let latitude = value?["latitude"] {
            newSpot.latitude = latitude as? Double
        }
        
        if let longitude = value?["longitude"] {
            newSpot.longitude = longitude as? Double
        }
        
        return newSpot
    }
    
}
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


