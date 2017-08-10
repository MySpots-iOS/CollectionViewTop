import UIKit
import GoogleMaps
import GooglePlacePicker


class MapViewController: CommonViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var placeInfoView: UIView!
    @IBOutlet weak var tableViewWrapper: UIView!
    @IBOutlet weak var tableViewHeader: UIView!
    @IBOutlet weak var tableViewHeaderLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var markers: [GMSMarker] = []
    var mapMaker:MapMaker!
    var mapViewDelegate:MapViewDelegate!
    //Flags
    var tableViewAppear = false
    var placeInfoAppear = false
    var nc = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapMaker = MapMaker()
        folder = dataController.getFolder(folderIndex: folderIndexPath)
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
        
        tableView.dataSource = self
        tableView.delegate = self
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
        
        
        folder = dataController.getFolder(folderIndex: folderIndexPath)
        refreshTableView()
        
        if !tableViewAppear && !placeInfoAppear{
            tableViewWrapper.center.y += tableViewWrapper.bounds.height
        }
        
        if !placeInfoAppear{
           tableViewWrapper.center.y -= tableViewHeader.bounds.height
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
    
    
    override func instantiateDetailView(_ spot:Spot){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "toDetailView") as! SpotDetailViewController
        //set placeID
        vc.placeID = spot.placeID!
        vc.saved = true
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
    
    override func markerTapped(_ marker:GMSMarker, _ isSaved:Bool){
        
        myplaceInfoView.saved = isSaved
        
        if !placeInfoAppear {
            Animation().animateShow(tableViewWrapper, placeInfoView, self.tableViewHeader.bounds.height, ViewControllerFlag.mapVC)
            placeInfoAppear = true
            setGeneralInformation(marker)
        } else{
            setGeneralInformation(marker)
        }
        
    }
    
    override func coordinateTapped(){
        
        if placeInfoAppear{
            Animation().animateHide(tableViewWrapper, placeInfoView, self.tableViewHeader.bounds.height, ViewControllerFlag.mapVC)
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


extension MapViewController: UITableViewDataSource ,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder.spots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        
        let spot = folder.spots[indexPath.row]
        cell.placeName.text = spot.spotName
        cell.placeAddress.text = spot.placeID
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        
        let marker = markers[indexPath.row]
        
        setGeneralInformation(marker)
        let camera = GMSCameraPosition(target: (marker.position), zoom: 15, bearing: 0, viewingAngle: 0)
        mapView.animate(to: camera)
        myplaceInfoView.saved = true
        
        Animation().animateHideList(tableViewWrapper, tableViewHeaderLabel, tableViewHeader.bounds.height)
        
        Animation().animateShow(tableViewWrapper, placeInfoView, tableViewHeader.bounds.height, ViewControllerFlag.mapVC)
        
        tableViewAppear = false
        placeInfoAppear = true
    }
    
    

}


