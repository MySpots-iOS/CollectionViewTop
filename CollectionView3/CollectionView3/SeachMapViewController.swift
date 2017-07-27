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

class SearchMapViewController: UIViewController, CLLocationManagerDelegate {
    


    @IBAction func backPushed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
//    @IBOutlet weak var navBarTitle: UINavigationItem!
//    @IBOutlet weak var navBar: UINavigationBar!
    var place:GMSPlace!
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()

    
    
    //Search bar on navigation bar
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

    
    override func viewDidLoad() {
        super.viewDidLoad()


        //Your map initiation code
        self.mapView?.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        
//        self.navBar.backgroundColor = UIColor.clear
        
        searchBarInit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchBarInit(){
        //Searchbar Init
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
//        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
    }
    

    func makeMarkerSearched(){
        
        print(place.name)
        let marker = GMSMarker(position: place.coordinate)
        marker.appearAnimation = .pop
        marker.map = mapView
        
        let camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        mapView.animate(to: camera)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15.0)
        mapView.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
        makeMarkerSearched()
    }
    
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
        //            mapView.isHidden = false
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
        print("LocationManagerError: \(error)")
    }
}


extension SearchMapViewController:GMSAutocompleteResultsViewControllerDelegate{
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        self.searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        //        vc.place = place

    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

