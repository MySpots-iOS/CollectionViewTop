
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
        
        if folders[index].spots.count != nil{
            return (folders[index].spots.count)
        }
        return 0
    }

    func getFolderLabelAtIndex(_ index: Int) -> String {
        return folders[index].folderName!
    }
    
    func getImageNameAtIndex(_ index: Int) -> String{
        return folders[index].imageName!
    }
    
    func getFolders(folderIndex: IndexPath) -> [Folder]{
        return [folders[folderIndex[1]]]
    }
    
    
    func firstInit(){

        self.ref.child(firebasePath).observe(.value, with: { (snapshot) in
//        self.ref.child(firebasePath).observeSingleEvent(of: .value, with: { (snapshot) in
            
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

            guard let snap = spot as? DataSnapshot else{
                return spot as! Folder
            }
            
            let newSpot:Spot = makeSpot(snap)!
            newFolder.spots.append(newSpot)

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
    
    
    func makeMarkers(mapView: GMSMapView, folderIndex: Int){
        
        let data:Folder? = folders[folderIndex]
        
        if (data != nil){
            for spot in (data?.spots)!{
                let marker = makeMarker(spot: spot)
                marker.map = mapView
            }
        }

    }
    
    func makeMarker(spot: Spot) -> GMSMarker {
        
        let map = CLLocationCoordinate2D.init(latitude: spot.latitude!, longitude: spot.longitude!)
        let marker = GMSMarker(position: map)
        marker.snippet = spot.spotName!
        marker.icon = GMSMarker.markerImage(with: UIColor.black)
        marker.userData = spot.placeID
        
        return marker
    }
    
    
}
 
