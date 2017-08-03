import UIKit
import GoogleMaps
import GooglePlacePicker


class MapViewController: CommonViewController{
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var placeInfoView: UIView!
    
    @IBOutlet weak var tableViewWrapper: UIView!
    @IBOutlet weak var tableViewHeader: UIView!
    @IBOutlet weak var tableViewHeaderLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var markers: [GMSMarker] = []
    
    var mapViewDelegate:MapViewDelegate!
    

    //Flags
    var tableViewAppear = false
    var placeInfoAppear = false

    var nc = NotificationCenter.default
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapMaker = MapMaker()
        let folder = DataController.getFolder(folderIndex: folderIndexPath)
        markers = mapMaker.makeMarkers(mapView: mapView, folder: folder)

        locationManager = MapCLLocationManager(mapView, markers, ViewControllerFlag.mapVC)
        mapViewDelegate = MapViewDelegate(self)
        
        
        mapView.delegate = mapViewDelegate
        mapView.isUserInteractionEnabled = true
        mapView.settings.setAllGesturesEnabled(true)
        mapView.settings.consumesGesturesInView = true
        
        self.loadTemplate()
        
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        mapView.isHidden = true
        
        
        nc.addObserver(self, selector: #selector(self.initCompleted(notification:)), name: Notification.Name("TableViewNotification"), object: nil)

        let tableViewDelegate = TableViewDataSource(folder)
        tableView.dataSource = tableViewDelegate
        tableView.delegate = tableViewDelegate
        tableView.rowHeight = 100
    }
    
    func initCompleted(notification: Notification?) {
        self.nc.removeObserver(self)
        refreshTableView()
    }
    
    func refreshTableView() {
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshTableView()
        
        if !tableViewAppear && !placeInfoAppear {
            tableViewWrapper.center.y += tableViewWrapper.bounds.height - tableViewHeader.bounds.height
        }

        if !placeInfoAppear{
            placeInfoView.center.y  += view.bounds.height
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadTemplate(){
        myplaceInfoView = PlaceInformation(self, frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        myplaceInfoView.vc = self
        placeInfoView.addSubview(myplaceInfoView)
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
            Animation.animateShowList(tableViewWrapper, tableViewHeaderLabel, tableViewWrapper.bounds.height)
            tableViewAppear = true
        } else{
            Animation.animateHideList(tableViewWrapper, tableViewHeaderLabel, tableViewWrapper.bounds.height)
            tableViewAppear = false
        }
    }
    
    override func markerTapped(_ marker:GMSMarker, _ isSaved:Bool){
        
        myplaceInfoView.saved = isSaved
        
        if !placeInfoAppear {
            Animation.animateShow(tableViewWrapper, placeInfoView, self.view.bounds.height, ViewControllerFlag.mapVC)
            placeInfoAppear = true
            setGeneralInformation(marker)
        } else{
            setGeneralInformation(marker)
        }
        
    }
    
    override func coordinateTapped(){
        
        if !placeInfoAppear{
            Animation.animateShow(tableViewWrapper, placeInfoView, self.view.bounds.height, ViewControllerFlag.mapVC)
            placeInfoAppear = true
        } else {
            Animation.animateHide(tableViewWrapper, placeInfoView, self.view.bounds.height, ViewControllerFlag.mapVC)
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

