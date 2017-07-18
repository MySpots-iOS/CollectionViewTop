import UIKit
import GoogleMaps
import GooglePlacePicker


class MapViewController: UIViewController{
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var placeInfoView: UIView!
    @IBOutlet weak var showListButton: UIButton!
    
    //These are passed from ViewController by segue
    var folderIndexPath:IndexPath = IndexPath()
    var dataSource:DataSource = DataSource()
    
    var markers: [GMSMarker] = []
    
    var locationManager:MapCLLocationManager!
    var mapViewDelegate:MapViewDelegate!

    var placeInfoAppear = false

    fileprivate var placesClient: GMSPlacesClient!
    var myplaceInfoView: PlaceInformation!
    
    @IBAction func listBtnPushed(_ sender: UIButton) {
        print("tapped btn!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = MapCLLocationManager(mapView)
        mapViewDelegate = MapViewDelegate(self)
        self.loadTemplate()

        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        mapView.isHidden = true
        
        let mapMaker = MapMaker()
        let folder = dataSource.getFolder(folderIndex: folderIndexPath)
        mapMaker.makeMarkers(mapView: mapView, folder: folder)
        placesClient = GMSPlacesClient.shared()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !placeInfoAppear{
            placeInfoView.center.y  += view.bounds.height
        }
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
            Animation().animateShow(self)
            placeInfoAppear = true
            setGeneralInformation(marker)
        } else{
            setGeneralInformation(marker)
        }
        
    }
    
    func coordinateTapped(){
        
        if !placeInfoAppear{
            Animation().animateShow(self)
            placeInfoAppear = true
        } else {
            Animation().animateHide(self)
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

