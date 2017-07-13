import UIKit
import GoogleMaps
import GooglePlacePicker


class MapViewController: UIViewController{
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var placeInfoView: UIView!
    
    //These are passed from ViewController by segue
    var folderIndexPath:IndexPath = IndexPath()
    var dataSource:DataSource = DataSource()
    
    var markers: [GMSMarker] = []
    
    var locationManager:MapCLLocationManager!
    var mapViewDelegate:MapViewDelegate!

    var placeInfoAppear = false

    fileprivate var placesClient: GMSPlacesClient!
    var myplaceInfoView: PlaceInformation!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = MapCLLocationManager(mapView)
        mapViewDelegate = MapViewDelegate(self)
        self.loadTemplate()

        mapView.isHidden = true
        
        let mapMaker = MapMaker()
        let folders = dataSource.getFolder(folderIndex: folderIndexPath)
        mapMaker.makeMarkers(mapView: mapView, folder: folders[folderIndexPath.row])
        placesClient = GMSPlacesClient.shared()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        placeInfoView.center.y  += view.bounds.height
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
    

    func loadTemplate(){
        myplaceInfoView = PlaceInformation(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        myplaceInfoView.vc = self

        placeInfoView.addSubview(myplaceInfoView)
    }
    
    func markerTapped(_ marker:GMSMarker, _ isSaved:Bool){
        
        myplaceInfoView.saved = isSaved
        
        if !placeInfoAppear {
            self.animateShow(placeInfoView)
            placeInfoAppear = true
            setGeneralInformation(marker)
        } else{
            setGeneralInformation(marker)
        }
        
    }
    
    func coordinateTapped(){
        
        if !placeInfoAppear{
            self.animateShow(placeInfoView)
            placeInfoAppear = true
        } else {
            self.animateHide(placeInfoView)
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
    
    func animateShow(_ placeInfoView:UIView){
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [],animations: {
            placeInfoView.center.y -= self.view.bounds.height
        },completion: nil
        )
    }
    
    func animateHide(_ placeInfoView:UIView){
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [],animations: {
            placeInfoView.center.y += self.view.bounds.height
        },completion: nil
        )
    }

}




