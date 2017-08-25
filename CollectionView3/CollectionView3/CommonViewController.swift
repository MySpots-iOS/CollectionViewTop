//
//  CommonViewController.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-07-27.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

enum ViewControllerFlag {
    case mapVC
    case searchVC
}

class CommonViewController: UIViewController {
    
    //These are passed from ViewController by segue
    var dataController:DataController!
    var folderIndexPath:IndexPath!
    var folder:Folder!

    
    var myplaceInfoView: PlaceInformation!
    var locationManager:MapCLLocationManager!
    var placesClient = GMSPlacesClient.shared()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func markerTapped(_ marker:GMSMarker, _ isSaved:Bool){
        print("CommonCV: markerTapped!")
    }
    
    func coordinateTapped() {
        print("CommonCV: coorinator tapped!")
    }
    
}


