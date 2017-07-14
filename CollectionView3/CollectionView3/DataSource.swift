
import Foundation
import Firebase
import GoogleMaps

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
        
        return folders[index].spots.count
    }

    func getFolderLabelAtIndex(_ index: Int) -> String {
        return folders[index].folderName!
    }
    
    func getImageNameAtIndex(_ index: Int) -> String{
        return folders[index].imageName!
    }
    
    func getFolder(folderIndex: IndexPath) -> Folder{
        return folders[folderIndex[1]]
    }
    
    func getFolders() -> [Folder]{
        return self.folders
    }
    
    
    func firstInit(){

        self.ref.child(firebasePath).observe(.value, with: { (snapshot) in
//        self.ref.child(firebasePath).observeSingleEvent(of: .value, with: { (snapshot) in
        
            self.folders.removeAll()
            
            for folder in snapshot.children{
                let newFolder: Folder?
        
                if let snap = folder as? DataSnapshot {
                    newFolder = self.makeFolder(folder: snap)
                    self.folders.append(newFolder!)
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

        
        for spot in spots.children{
            
            print(spot)

            if let snap = spot as? DataSnapshot{
                if let newSpot:Spot = makeSpot(snap){
                    newFolder.spots.append(newSpot)
                }
            }
        }
        return newFolder
    }
    

    func makeSpot(_ spots:DataSnapshot) -> Spot? {
        
        let newSpot = Spot()
        let value = spots.value as? NSDictionary
        
        
        if let folderID = value?["folderID"] {
            newSpot.folderID = folderID as? NSNumber
        }
        
        if let placeID = value?["placeID"]{
            newSpot.placeID = placeID as? String
        }
        

        guard let spotName = value!["spotName"] as? String else {
            return nil
        }
        
        newSpot.spotName  = spotName
        

        guard let latitude =  value?["latitude"] as? Double else {
            return nil
        }
        
        newSpot.latitude = latitude

        
        if let longitude = value?["longitude"] {
            newSpot.longitude = (longitude as? Double)!
        }
        
        return newSpot
    }
    
    func makeNewFolder(_ folderName:String){
        
        let folderRef = ref.child(firebasePath).childByAutoId()
        
        let newFolder = ["category": "Not set", "folderName": folderName, "imageName":"garragePic", "spotsNum":1, "Spots":0] as [String : Any]
        folderRef.updateChildValues(newFolder)
        
        print(folderRef.key)
        
        let folderKey = folderRef.key
        let addSpot = ["folderID":folderKey,"latitude":123456, "longitude":123456,"placeID":"aasdfasfas32432fvfa", "spotName":"Test Spot"] as [String : Any]
        
        let spotRef = folderRef.child("Spots").childByAutoId()
        print(spotRef)
        
        spotRef.setValue(addSpot)

    }

}

