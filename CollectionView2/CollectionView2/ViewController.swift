//
//  ViewController.swift
//  CollectionView2
//
//  Created by ayako_sayama on 2017-06-17.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var segIdentifier = "mySpotsMap"
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    var categories = ["MySpots", "Explore", "Near You"]

    var cellNum = ["Beach", "FriendsHouse", "Party", "Drinking", "Cities"]

    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("This is seg2!")
//        
//        
//        if segue.identifier == "mySpotsMap" {
//            
//            print("This is seg3!")
//            
//            let mapVC = segue.destination as! MySpotsMapVC
//            
//            let tag = segue as! Int
//            mapVC.folderName = "\(cellNum[tag])"
//            
//
//            
//            let locations = [
//                Location(folderID: indexPath!, spotName: "New York, NY", latitude: 40.713054, longitude: -74.007228),
//                
//                Location(folderID: indexPath!, spotName: "Los Angeles, CA", latitude: 34.052238, longitude: -118.243344),
//                
//                Location(folderID: indexPath!, spotName: "Chicago, IL", latitude: 41.883229, longitude: -87.632398)
//            ]
//            
//            //            let mySpots = MySpots(folderName: "\(cellNum[indexPath!])", locations: locations)
//            mapVC.loca = locations
//        }
//        
//
//    }
    

    
    
}

extension ViewController : UITableViewDelegate { }

extension ViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryRow
        return cell
    }
    
}
