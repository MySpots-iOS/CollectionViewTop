//
//  MapViewController.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-06-28.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit
import GoogleMaps
//import GooglePlaces
import GooglePlacePicker

class MapViewController: UIViewController{
    
    @IBOutlet weak var mapView: GMSMapView!

    let mapController = MapController()
    fileprivate var locationManager = CLLocationManager()
    
    var folder:Folder = Folder()
    var markers: [GMSMarker] = []
    
    fileprivate var placesClient: GMSPlacesClient!
    fileprivate var zoomLevel: Float = 15.0
    

    fileprivate var generalInformation: UIView? = nil
    fileprivate var generalInfoBottomConstraints: [NSLayoutConstraint] = []
    fileprivate var showListView: UITableView!
    fileprivate var showLists: UILabel!
    fileprivate var showListViewHeightConstraints: [NSLayoutConstraint] = []
    fileprivate var flag:Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapInit()
        locationInit()


//        // TODO load locations function
//
        markers = mapController.makeMarker(mapView: mapView)
//        makeShowListView()
//        makeInformationView()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func mapInit() {
        
        //default position
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        
        mapView.camera = camera
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self as? GMSMapViewDelegate
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        // Add the map to the view, hide it until we've got a location update.
        mapView.isHidden = true
    }

    func locationInit() {
        
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        
        placesClient = GMSPlacesClient.shared()
    }
  

}

//extension MapViewController: GMSMapViewDelegate{
//    
//    func makeShowListView() {
//        showListView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
//        showListView.sectionHeaderHeight = 44
//        showListView.rowHeight = 100
//        
//        showListView.delegate = self
//        showListView.dataSource = self
//        
//        showListView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
//        
//        self.view.addSubview(showListView)
//        
//        // Set constrains
//        showListView.translatesAutoresizingMaskIntoConstraints = false
//        showListView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
//        showListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
//        showListView.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
//        
//        self.showListViewHeightConstraints.append(showListView.heightAnchor.constraint(equalToConstant: 44))
//        self.showListViewHeightConstraints.append(showListView.heightAnchor.constraint(equalToConstant: (self.view.bounds.height / 1.3)))
//        self.showListViewHeightConstraints[0].isActive = true
//    }
//}


//extension MapViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
//        headerView.backgroundColor = UIColor.white
//        
//        showLists = UILabel()
//        showLists.text = "Show Lists"
//        showLists.textAlignment = .center
//        showLists.sizeToFit()
//        showLists.center = headerView.center
//        showLists.textColor = UIColor.black
//        
////        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToggleAction(_:))))
//        headerView.addSubview(showLists)
//        
//        return headerView
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
//        
//        placesClient.lookUpPlaceID(markers[indexPath.row].snippet!, callback: { (place, error) -> Void in
//            if let error = error {
//                print("lookup place id query error: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let place = place else {
//                //print("No place details for \(placeID)")
//                return
//            }
//            
//            cell.placeName.text = place.name
//            cell.placeAddress.text = place.formattedAddress
//            
//        })
//        return cell
//    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("cell tapped: \(indexPath.row)")
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//        //set placeID
//        vc.placeID = (self.markers[indexPath.row].snippet)!
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}


// Delegates to handle events for the location manager.
extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        //print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}


