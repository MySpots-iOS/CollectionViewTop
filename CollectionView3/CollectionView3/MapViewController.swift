import UIKit
import GoogleMaps
//import GooglePlaces
import GooglePlacePicker


class MapViewController: UIViewController{
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var placeInfoView: UIView!
    
    fileprivate var locationManager = CLLocationManager()
    var didFindMyLocation = false
    
    //These are passed from ViewController by segue
    var folderIndexPath:IndexPath = IndexPath()
    var dataSource:DataSource = DataSource()
    
    var markers: [GMSMarker] = []
    var placeInfoAppear = false
    
    fileprivate var placesClient: GMSPlacesClient!
    fileprivate var zoomLevel: Float = 15.0

    
    var myplaceInfoView: PlaceInformation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTemplate()

        mapInit()
        locationInit()

        dataSource.makeMarkers(mapView: mapView, folderIndex: folderIndexPath.row)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        placeInfoView.center.y  += view.bounds.height
    }
    
    
//    func animateShow(){
//        UIView.animate(withDuration: 0.5, delay: 0.3, options: [],animations: {
//                self.placeInfoView.center.y -= self.view.bounds.height
//            },completion: nil
//        )
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mapInit() {
        
        mapView.delegate = self
        
        //default position
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        
        mapView.camera = camera
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        mapView.settings.myLocationButton = true
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -123.111191, longitude: -123.111191)
        marker.title = "Vancouver"
        marker.snippet = "Canada"
        marker.map = mapView
        
        // Add the map to the view, hide it until we've got a location update.
        mapView.isHidden = true
    }

    func locationInit() {
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        
        placesClient = GMSPlacesClient.shared()

    }
    
    func loadTemplate(){
        myplaceInfoView = PlaceInformation(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        placeInfoView.addSubview(myplaceInfoView)
    }
}

extension MapViewController: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("Executed: didtapmarker")
        
        if !placeInfoAppear {
            Animation().animateShow(myplaceInfoView)
            placeInfoAppear = true
        } else {
            Animation().animateHide(myplaceInfoView)
            placeInfoAppear = false
        }

//        setGeneralInformation(marker.snippet!, userData: marker.userData!)
        return true
    }
    
//    func setGeneralInformation(_ placeID: String, userData: Any?) {
//        if let savedFlag = userData as? [String: Bool] {
//            if savedFlag["saved"]! == true {
//                self.placeInfoView?.setSavedIcon()
//                self.placeInfoView?.saved = savedFlag["saved"]!
//            } else {
//                self.placeInfoView?.setUnSavedIcon()
//                self.placeInfoView?.saved = savedFlag["saved"]!
//            }
//        }
//        
//        placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
//            if let error = error {
//                print("lookup place id query error: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let place = place else {
//                print("No place details for \(placeID)")
//                return
//            }
//            
//            self.placeInfoView?.setSelectedPlaceName(place.name)
//            self.placeInfoView?.setSelectedAddress(place.formattedAddress!)
//            self.placeInfoView?.setGooglePlaceID(placeID)
//            self.placeInfoView?.setPlaceRate(place.rating)
//        })
//        animateShow()
//    }
    

}


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
            
            mapView.isMyLocationEnabled = true
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}


