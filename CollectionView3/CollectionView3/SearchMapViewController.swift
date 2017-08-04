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

class SearchMapViewController: CommonViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var placeInfoView: UIView!
    
    @IBOutlet weak var tableViewWrapper: UIView!
    
    @IBOutlet weak var tableViewHeader: UIView!
    @IBOutlet weak var tableViewHeaderLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var place:GMSPlace!
    
    //Search bar on navigation bar
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

    
    var tableViewAppear = false
    var placeInfoAppear = true

    let polyLine: GMSPolyline = GMSPolyline()
    var savedMarker:GMSMarker!
    
    @IBAction func backPushed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
//        if !tableViewAppear && !placeInfoAppear{
//            tableViewWrapper.center.y += tableViewWrapper.bounds.height
//        }
//        
//        if !placeInfoAppear{
//            tableViewWrapper.center.y -= tableViewHeader.bounds.height
//            placeInfoView.center.y += placeInfoView.bounds.height
//        }
        
        
//        if !placeInfoAppear{
//            placeInfoView.center.y  += view.bounds.height
//        }
//        
//        if !tableViewAppear{
//            tableViewWrapper.center.y += tableViewWrapper.bounds.height - tableViewHeader.bounds.height
//            
//            if placeInfoAppear{
//                if placeInfoAppear{
//                    tableViewWrapper.center.y += tableViewWrapper.bounds.height
//                }
//            }
//        }

    }
    
    func refreshTableView(){
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Your map initiation code
        self.mapView?.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        let markers = makeMarkerSearched()
        locationManager = MapCLLocationManager(mapView, markers, ViewControllerFlag.searchVC)
        
        mapView.delegate = self
        mapView.isUserInteractionEnabled = true
        mapView.settings.setAllGesturesEnabled(true)
        mapView.settings.consumesGesturesInView = true
        
        
        polyLine.isTappable = true
        savedMarker = markers.first!
        searchBarInit()
        loadTemplate()
        
        
        let tableViewDelegate = SearchTableViewDataSource(dataController)
        tableView.dataSource = tableViewDelegate
        tableView.delegate = tableViewDelegate
        tableView.rowHeight = 100

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func gotoDetailView(_ sender: UITapGestureRecognizer) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "toDetailView") as! SpotDetailViewController
        //set placeID
        vc.placeID = myplaceInfoView.getGooglePlaceID()
        vc.saved = myplaceInfoView.getSavedBool()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func showListTapped(_ sender: UITapGestureRecognizer) {
        
        if !tableViewAppear {
            Animation().animateShowList(tableViewWrapper, tableViewHeaderLabel, tableViewWrapper.bounds.height)
            tableViewAppear = true
        } else{
            Animation().animateHideList(tableViewWrapper, tableViewHeaderLabel, tableViewWrapper.bounds.height)
            tableViewAppear = false
        }
    }

    
    func searchBarInit(){
        //Searchbar Init
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        navigationItem.titleView = searchController?.searchBar
        
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
    }
    
    
    func loadTemplate(){
        myplaceInfoView = PlaceInformation(self, frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        myplaceInfoView.vc = self
        placeInfoView.addSubview(myplaceInfoView)
    }


    func makeMarkerSearched() -> [GMSMarker]{
        
        var markers:[GMSMarker] = []
        
        print(place.name)
        let marker = GMSMarker(position: place.coordinate)
        marker.appearAnimation = .pop
        marker.map = mapView
        markers.append(marker)
        
        return markers

    }
    
    override func markerTapped(_ marker:GMSMarker, _ isSaved:Bool){
        
        myplaceInfoView.saved = isSaved
        
        if !placeInfoAppear {
            Animation().animateShow(tableViewWrapper, placeInfoView, tableViewHeader.bounds.height, ViewControllerFlag.searchVC)
            placeInfoAppear = true
            setGeneralInformation(marker)
        } else{
            setGeneralInformation(marker)
        }
        
    }
    
    override func coordinateTapped(){
        
        print("tapped!!")
        
        if !placeInfoAppear{
            Animation().animateShow(self.tableViewWrapper, self.placeInfoView, tableViewHeader.bounds.height, ViewControllerFlag.searchVC)
            placeInfoAppear = true
        } else{
            
            Animation().animateHide(self.tableViewWrapper, self.placeInfoView, tableViewHeader.bounds.height, ViewControllerFlag.searchVC)
            placeInfoAppear = false
            
        }
    }
    
    
    func setGeneralInformation(_ marker: GMSMarker) {
        
        myplaceInfoView.marker = marker
        
        let userData = marker.userData
        
        if myplaceInfoView.saved == true{
            self.myplaceInfoView.setSavedIcon()
        } else {
            self.myplaceInfoView?.setUnSavedIcon()
        }
        
        placesClient.lookUpPlaceID(userData as! String, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(userData ?? "no placeID")")
                return
            }
            
            self.myplaceInfoView?.setSelectedPlaceName(place.name)
            self.myplaceInfoView?.setSelectedAddress(place.formattedAddress!)
            self.myplaceInfoView?.setGooglePlaceID(place.placeID)
            self.myplaceInfoView?.setPlaceRate(place.rating)
        })
        
        self.myplaceInfoView.reloadInputViews()
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


extension SearchMapViewController:GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let isSaved = true
        self.markerTapped(marker, isSaved)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if savedMarker != nil{
            savedMarker.map = nil
        }

        self.coordinateTapped()
    }
    
    
    func mapView(_ mapView:GMSMapView, didTapPOIWithPlaceID placeID:String,
                 name:String, location:CLLocationCoordinate2D) {
        print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
        
        
        let infoMarker = GMSMarker(position: location)
        //        infoMarker.snippet = placeID
        infoMarker.title = name
        infoMarker.appearAnimation = .pop
        //        infoMarker.infoWindowAnchor.y = 1
        infoMarker.userData = placeID
        infoMarker.map = mapView
        mapView.selectedMarker = infoMarker
        
        
        if savedMarker != nil{
            savedMarker.map = nil
        }
        savedMarker = infoMarker
        
        let isSaved = false
        self.markerTapped(infoMarker, isSaved)
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D, marker: GMSMarker) {
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                
                let title = address.lines as [String]?
                marker.title = title?.first
                
                UIView.animate(withDuration: 0.25) {
                }
            }
        }
    }
    

}

