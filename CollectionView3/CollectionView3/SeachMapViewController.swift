//
//  SeachMapViewController.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-07-21.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class SeachMapViewController: UIViewController {
    
    var place:GMSPlace!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func makeMarkerSearched(){
//        let marker = GMSMarker(position: place.coordinate)
//        marker.appearAnimation = .pop
//        marker.map = loadView
//        
//        let camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//        mapView.animate(to: camera)
    }
}
