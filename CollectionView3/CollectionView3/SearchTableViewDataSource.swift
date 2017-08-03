


import UIKit
import GoogleMaps
import GooglePlaces

class SearchTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate{
    
    
    var dataSource:DataController
    
    init(_ dataSource:DataController) {
        self.dataSource = dataSource
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataController.folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchVCTableCell", for: indexPath) as! SearchTableCell
        
        cell.backgroundColor = UIColor.cyan
//        cell.placeName.text = "My name is ayako"
//        
//        let spot = folder.spots[indexPath.row]
//        cell.placeName.text = spot.spotName
//        cell.placeAddress.text = spot.placeID
        
        return cell
    }
    
}
