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

class SearchMapViewController: CommonViewController, CLLocationManagerDelegate, FolderListTableDelegate{
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var placeInfoView: UIView!
    @IBOutlet weak var listButton: UIButton!

    var place:GMSPlace!
    
    //Search bar on navigation bar
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var mapMaker:MapMaker?
    
    var tableViewAppear = false
    var placeInfoAppear = true

    let polyLine: GMSPolyline = GMSPolyline()
    var savedMarker:GMSMarker!
    var temporaryMarkers:[GMSMarker]!
    
    
    @IBAction func backPushed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapMaker = MapMaker()
        //Your map initiation code
        self.mapView?.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        temporaryMarkers = makeMarkerSearched()
        locationManager = MapCLLocationManager(mapView, temporaryMarkers, ViewControllerFlag.searchVC)
        
        mapView.delegate = self
        mapView.isUserInteractionEnabled = true
        mapView.settings.setAllGesturesEnabled(true)
        mapView.settings.consumesGesturesInView = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)

        addListButton()
        
        
        polyLine.isTappable = true
        savedMarker = temporaryMarkers.first!
        searchBarInit()
        loadTemplate()
        setGeneralInformation(savedMarker)

    }
    
    
    func generateMarkers(_ markers:[GMSMarker]){
        var bounds = GMSCoordinateBounds()
        for marker in markers {
            bounds = bounds.includingCoordinate(marker.position)
        }
        mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(50.0, 100.0 ,50.0 ,50.0)))
    }

    
    func receiveFolderOnOff(_ cellIsChecked:[Bool]){
        
        mapView.clear()
        
        let folders = dataController.getFolders()
        temporaryMarkers = makeMarkerSearched()
        savedMarker = temporaryMarkers.first!
        
        //showMarkers.append(savedMarker)
        
        for (index, cell) in cellIsChecked.enumerated(){
            
            if cell{
                print(folders[index].folderName ?? "foldername")
                
                let markers = mapMaker!.makeMarkers(mapView: mapView, folder: folders[index])
                temporaryMarkers! += markers
            }
        }
        generateMarkers(temporaryMarkers)
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
    
    
    @IBAction func listBtnPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [],animations: {
         
            self.listButton.layer.shadowOffset = CGSize(width: 5, height: 5)
            self.listButton.layer.shadowRadius = 4
        },completion: nil)
        
    }

  
    @IBAction func listBtnRelease(_ sender: Any) {
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [],animations: {
            self.listButton.layer.shadowOffset = CGSize(width: 2, height: 2)
            self.listButton.layer.shadowRadius = 2
        },completion: nil)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tableVC") as! FolderListTableVC
        //set placeID
        vc.dataSource = dataController
        vc.folderListdelegate = self
        self.navigationController?.pushViewController(vc, animated: true)

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
    
    func addListButton(){
            
            listButton.layer.shadowColor = UIColor.black.cgColor
            listButton.layer.shadowOffset = CGSize(width: 2, height: 2)
            listButton.layer.shadowRadius = 2
            listButton.layer.shadowOpacity = 0.3
    }


    func makeMarkerSearched() -> [GMSMarker]{
        
        var markers:[GMSMarker] = []
        
        print(place.name)
        let marker = GMSMarker(position: place.coordinate)
        marker.appearAnimation = .pop
        marker.map = mapView
        marker.userData = place.placeID
        markers.append(marker)
        
        return markers

    }
    
    override func markerTapped(_ marker:GMSMarker, _ isSaved:Bool){
        
        myplaceInfoView.saved = isSaved
        
        if !placeInfoAppear {
            setGeneralInformation(marker)
            UIView.animate(withDuration: 0.2, delay: 0, options: [],animations: {
                self.placeInfoView.center.y -= self.placeInfoView.bounds.height
            },completion: nil)
            placeInfoAppear = true
        } else{
            setGeneralInformation(marker)
        }
        
    }
    
    override func coordinateTapped(){
        
        if placeInfoAppear {
            UIView.animate(withDuration: 0.2, delay: 0, options: [],animations: {
                self.placeInfoView.center.y += self.placeInfoView.bounds.height
            },completion: nil)
        }
        
        placeInfoAppear = false
    }
    
    
    func setGeneralInformation(_ marker: GMSMarker) {
        
        myplaceInfoView.marker = marker
        
        let userData = marker.userData
        
        if myplaceInfoView.saved == true{
            self.myplaceInfoView.setSavedIcon()
        } else {
            self.myplaceInfoView?.setUnSavedIcon()
        }
        
        
        if userData == nil{
            self.myplaceInfoView?.setSelectedPlaceName(place.name)
            self.myplaceInfoView?.setSelectedAddress(place.formattedAddress!)
        } else{
            
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
        }

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

