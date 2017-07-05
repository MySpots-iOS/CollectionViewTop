
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
                print("ohh nooo")
                return spot as! Folder
            }
            
            let newSpot:Spot = makeSpot(snap)!
            newFolder.spots.append(newSpot)

            print("newspot1:\(newSpot)")
            print("newspot2:\(newFolder.spots)")
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
        
        print("makeSpot: \(String(describing: newSpot.longitude!))")
        
        return newSpot
    }
    
    
    func makeMarker(mapView: GMSMapView, folderIndex: Int){
        
        
        //バンクーバーあたりのカフェを入れておいた。placeIDも正確なはず。
        
        let map1 = CLLocationCoordinate2D.init(latitude: 49.288102, longitude: -123.113128)
        let placeID1 = "ChIJ32puLoJxhlQRusnG9dNlmzU"
        
        let map2 = CLLocationCoordinate2D.init(latitude: 49.288826, longitude: -123.114628)
        let placeID2 = "ChIJ32puLoJxhlQRusnG9dNlmzU"
        
        let map3 =  CLLocationCoordinate2D.init(latitude: 49.280515, longitude: -123.116851)
        let placeID3 = "ChIJ32puLoJxhlQRusnG9dNlmzU"
        
        
        let data:Folder? = folders[folderIndex]
        
        if (data != nil){
            print("data: \(String(describing: data!.folderName))")
            print("spots: \(String(describing: data!.spots))")
            
//                for spot in (data?.spots!)!{
//                    print("spot: \(String(describing: spot.spotName))")
//                }
            
        }
        
        
//        let data = self.folders[1]
//        
//        if data != nil{
//            print("folders!:\(String(describing: data.folderName)) ")
//            
//            for spot in data.spots!{
//                print("spot: \(spot.spotName)")
//            }
//        } else{
//            print("not there")
//        }
        

        
        let marker = GMSMarker(position: map1)
        marker.snippet = placeID1
        marker.icon = GMSMarker.markerImage(with: UIColor.black)
        marker.map = mapView
        
        let marker2 = GMSMarker(position: map2)
        marker2.snippet = placeID2
        marker2.icon = GMSMarker.markerImage(with: UIColor.black)
        marker2.map = mapView
        
        let marker3 = GMSMarker(position: map3)
        marker3.snippet = placeID3
        marker3.icon = GMSMarker.markerImage(with: UIColor.black)
        marker3.map = mapView
        
        // TODO set flag which is stored or not
        marker.userData = "test"
        marker2.userData = "test"
        marker3.userData = "test"

        //        return [marker, marker2, marker3]
    }
    

    
}
 
