
import Foundation
import Firebase
import GoogleMaps
import GooglePlaces

class DataController {
    
    let ref = Database.database().reference()
    let firebasePath: String = "MySpotsFolder"
    
    static var folders:[Folder] = []
    
    
    init() {
        firstInit()
    }
    
    func numberOfFolders() -> Int {
        return DataController.folders.count
    }
    
    func numberOfSpots(_ index: Int) -> Int{
        
        return DataController.folders[index].spots.count
    }

    func getFolderLabelAtIndex(_ index: Int) -> String {
        return DataController.folders[index].folderName!
    }
    
    func getImageNameAtIndex(_ indexPath:IndexPath, _ placesClient:GMSPlacesClient, _ cell:MySpotsCell){
        
        let folder = DataController.getFolder(folderIndex: indexPath)
        let firstSpotPlaceID = folder.spots.first?.placeID
        
        print("FirstPhotoID: \(String(describing: firstSpotPlaceID))")
        
        placesClient.lookUpPhotos(forPlaceID: firstSpotPlaceID!, callback: { (photos, error) -> Void in
            
            
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(firstPhoto, cell)
                }
            }
        })
    }
    
    func loadImageForMetadata(_ photoMetadata:GMSPlacePhotoMetadata, _ cell:MySpotsCell){
        
        
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                cell.update(photo)
            }
        })
        
    }
    
    
    static func getFolder(folderIndex: IndexPath) -> Folder{
        return DataController.folders[folderIndex[1]]
    }
    
    static func getFolders() -> [Folder]{
        return DataController.folders
    }
    
    
    func firstInit(){

        self.ref.child(firebasePath).observe(.value, with: { (snapshot) in
//        self.ref.child(firebasePath).observeSingleEvent(of: .value, with: { (snapshot) in
        
            DataController.folders.removeAll()
            
            for folder in snapshot.children{
                let newFolder: Folder?
        
                if let snap = folder as? DataSnapshot {
                    newFolder = self.makeFolder(folder: snap)
                    DataController.folders.append(newFolder!)
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
    
    func makeNewFolder(_ folderName:String, _ placeInfo:PlaceInformation){
        
        let folderRef = ref.child(firebasePath).childByAutoId()
        
        let newFolder = ["category": "Not set", "folderName": folderName, "imageName":"garragePic", "spotsNum":1, "Spots":0] as [String : Any]
        folderRef.updateChildValues(newFolder)
        self.addMarker(folderRef, placeInfo)
    }
    
    func addNewSpot(_ placeInfo:PlaceInformation, _ folderName:String){
        
        let foldersRef = ref.child(firebasePath)
        foldersRef.queryOrdered(byChild: "folderName").queryEqual(toValue: folderName).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                let folderKey = (snapshot.value as AnyObject).allKeys.first!
                self.addMarker(foldersRef.child(folderKey as! String), placeInfo)

            } else {
                print("we don't have that, add it to the DB now")
            }
        })
    }
    
    func addMarker(_ folderRef:DatabaseReference, _ placeInfo:PlaceInformation){
        let folderKey = folderRef.key
        
        print("latitude:\(placeInfo.marker.position.latitude), longitude:\(placeInfo.marker.position.longitude), placeID:\(placeInfo.placeID), name: \(placeInfo.placeName)")
        
        let addSpot = ["folderID":folderKey,"latitude":placeInfo.marker.position.latitude, "longitude":placeInfo.marker.position.longitude,"placeID":placeInfo.placeID, "spotName":placeInfo.placeName.text!] as [String : Any]
        
        let spotRef = folderRef.child("Spots").childByAutoId()
        print(spotRef)
        
        spotRef.setValue(addSpot)
    }

}

