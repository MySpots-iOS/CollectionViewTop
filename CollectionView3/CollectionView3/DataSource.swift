
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
    
    func firstInit(){
        
        self.ref.child(firebasePath).observe(.value, with: { (snapshot) in
            
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
    
    func numberOfFolders() -> Int {
        return DataController.folders.count
    }
    
    func addFolder(_ folderName:String){
        
        let newfolder = Folder()
        newfolder.folderName = folderName
        DataController.folders.append(newfolder)
    }
    
    func numberOfSpots(_ index: Int) -> Int{
        return DataController.folders[index].spots.count
    }

    func getFolderLabelAtIndex(_ index: Int) -> String {
        return DataController.folders[index].folderName!
    }
    
    func getImageAtIndex(_ index: Int) -> UIImage{
        
        let index = index
        
        let spots = DataController.folders[index].spots
        var image = UIImage()
        
        if spots.count > 0{
            for spot in spots{
                if spot.imageName != nil{
                    image = spot.imageName!
                }
            }
        }
        return image
    }
    

    func getFolder(folderIndex: IndexPath) -> Folder{
        return DataController.folders[folderIndex[1]]
    }
    
    func getFolders() -> [Folder]{
        return DataController.folders
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
        
        let spots = folder.childSnapshot(forPath: "Spots")
        for spot in spots.children{
            
            if let snap = spot as? DataSnapshot{
                if let newSpot:Spot = makeSpot(snap){
                    newFolder.spots.append(newSpot)
                }
            }
        }
        return newFolder
    }
    
    
    func deleteMarkerDatabase(_ folderName:String, _ placeID:String){
        let foldersRef = self.ref.child(firebasePath)
        foldersRef.queryOrdered(byChild: "folderName").queryEqual(toValue: folderName).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                let folderKey = (snapshot.value as AnyObject).allKeys.first!
                self.deleteSpot(foldersRef.child(folderKey as! String), placeID)
            } else {
                print("Error: we can't delete the spot")
            }
        })
    }
    
    func deleteSpot(_ folderRef:DatabaseReference, _ placeID:String){
        
        let spotsRef = folderRef.child("Spots")
        
        spotsRef.queryOrdered(byChild: "placeID").queryEqual(toValue: placeID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                let folderKey = (snapshot.value as AnyObject).allKeys.first!

                spotsRef.child(folderKey as! String).removeValue { (error, ref) in
                    if error != nil {
                        print("error \(String(describing: error))")
                    }
                    print(ref)
                }
                
            } else {
                print("we don't have that, add it to the DB now")
            }
        })
    }
    
    
    func deleteFolderDatabase(_ index:Int, _ cView:UICollectionView){
        let foldersRef = ref.child(firebasePath)
        
        let folderName = DataController.folders[index].folderName
        
        foldersRef.queryOrdered(byChild: "folderName").queryEqual(toValue: folderName).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                let folderKey = (snapshot.value as AnyObject).allKeys.first!
                foldersRef.child(folderKey as! String).removeValue { (error, ref) in
                    if error != nil {
                        print("error \(String(describing: error))")
                    }
                    DispatchQueue.main.async {
                        print("deleeted!")
                        
                        cView.reloadData()
                    }
                }
                
            } else {
                print("we don't have that, add it to the DB now")
            }
        })
    
    }
    

    func makeSpot(_ spots:DataSnapshot) -> Spot? {
        
        let newSpot = Spot()
        let value = spots.value as? NSDictionary

        if let folderID = value?["folderID"] {
            newSpot.folderID = folderID as? String
        }
        
        guard let placeID = value?["placeID"] as? String else{
            return nil
        }
        newSpot.placeID = placeID

        
        lookUpPhotos(placeID, completion: { result in
            newSpot.imageName = result
        })
        
        
        guard let spotName = value!["spotName"] as? String else {
            return nil
        }
        newSpot.spotName  = spotName
        
        guard let address = value!["address"] as? String else {
            return nil
        }
        newSpot.address = address

        guard let latitude =  value?["latitude"] as? Double else {
            return nil
        }
        newSpot.latitude = latitude

        
        if let longitude = value?["longitude"] {
            newSpot.longitude = (longitude as? Double)!
        }
        
        return newSpot
    }
    
    
    
    func lookUpPhotos(_ placeID:String, completion:@escaping(UIImage) -> Void){
        
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID, callback: { (photos, error) -> Void in
            
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    
                    self.loadImageforMetaPhoto(firstPhoto, completion: {(result) in
                        completion(result)
                    })
                }
            }
        })
    }
    
    
    func loadImageforMetaPhoto(_ photoMetadata:GMSPlacePhotoMetadata, completion:@escaping(UIImage) -> Void){
        
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                
                if let photoData = photo{
                    completion(photoData)
                }
            }
        })
    }
    

    
    func makeNewFolder(_ folderName:String, _ place:GMSPlace){
        
        let folderRef = ref.child(firebasePath).childByAutoId()
        
        let newFolder = ["category": "Not set", "folderName": folderName, "imageName":"garragePic", "spotsNum":1, "Spots":0] as [String : Any]
        folderRef.updateChildValues(newFolder)
        self.addMarker(folderRef, place)
    }
    
    func makeEmptyNewFolder(_ folderName:String){
        let folderRef = ref.child(firebasePath).childByAutoId()
        
        let newFolder = ["category": "Not set", "folderName": folderName, "imageName":"garragePic", "spotsNum":0, "Spots":0] as [String : Any]
        folderRef.updateChildValues(newFolder)
        
    }
    
    
    func addNewSpot(_ place:GMSPlace, _ folderName:String){

        let foldersRef = self.ref.child(firebasePath)
        foldersRef.queryOrdered(byChild: "folderName").queryEqual(toValue: folderName).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                let folderKey = (snapshot.value as AnyObject).allKeys.first!
                self.addMarker(foldersRef.child(folderKey as! String), place)

            } else {
                print("we don't have that, add it to the DB now")
            }
        })
    }
    
    func addMarker(_ folderRef:DatabaseReference, _ place:GMSPlace){
        let folderKey = folderRef.key
        
        let addSpot = ["folderID":folderKey,"latitude":place.coordinate.latitude, "longitude":place.coordinate.longitude,"placeID":place.placeID, "spotName":place.name, "address":place.formattedAddress!] as [String : Any]
        
        let spotRef = folderRef.child("Spots").childByAutoId()
        
        spotRef.setValue(addSpot)
    }
    
    
    func findKeyForValue(_ placeID: String) ->String?
    {
        let folders = getFolders()
        
        for folder in folders{
            
            var spotIDs:[String] = []
            for spot in folder.spots{
                spotIDs.append(spot.placeID!)
            }
            
            if (spotIDs.contains(placeID))
                {
                return folder.folderName
            }
        }
        
        return nil
    }
}

