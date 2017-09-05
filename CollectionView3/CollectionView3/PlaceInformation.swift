
import UIKit
import GoogleMaps
import GooglePlaces

class PlaceInformation: UIView, UIGestureRecognizerDelegate{

    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var addressName: UILabel!
    @IBOutlet weak var placeRating: UILabel!
    @IBOutlet weak var distanceIcon: UIImageView!
    
    
    var place:GMSPlace!
    
    var placeID: String = ""
    var saved: Bool = false    
    var dataController:DataController!
    var marker:GMSMarker!
    var alertControl:AlertControl!
    
    @IBOutlet var gestureR: UITapGestureRecognizer!
    
    init(_ alertControl:AlertControl, _ dataController:DataController, frame: CGRect) {
        super.init(frame: frame)
        
        self.dataController = dataController
        self.alertControl = alertControl
        autoresizesSubviews = false
        loadXibView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXibView()
    }

    @IBAction func savedIconTapped(_ sender: Any?) {
        
        if !saved{
            self.alertControl.saveToFolder(dataController.getFolders(), self)
        } else {
            self.alertControl.deleteFromFolder(self)
        }
    }

    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if touch.view == distanceIcon{
            return false
        }
        return true
    }
    
    func loadXibView() {
        
        let view = Bundle.main.loadNibNamed( "PlaceInformation", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.placeName.textColor = UIColor.mainDarkGreen()
        self.distanceIcon.isUserInteractionEnabled = true
        self.addSubview(view)
    }
    
    
    func setUpInfo(_ place:GMSPlace){
        self.place = place
        
        setSelectedPlaceName(place.name)
        setSelectedAddress(place.formattedAddress!)
        setGooglePlaceID(place.placeID)
        setPlaceRate(place.rating)
    }
    
    
    func setSelectedPlaceName(_ name:String) {
        self.placeName.text = name
    }
    
    func setSelectedAddress(_ address: String) {
        self.addressName.text = address
    }
    
    func setPlaceRate(_ rate: Float) {
        self.placeRating.text = String(rate)
    }
    
    func setSavedIcon() {
        self.distanceIcon.image = UIImage(named: "savedFolder")
    }
    
    func setUnSavedIcon() {
        self.distanceIcon.image = UIImage(named: "saveFolder")
    }
    
    func setGooglePlaceID(_ placeID: String) {
        self.placeID = placeID
    }
    
    func getGooglePlaceID() -> String {
        return self.placeID
    }
    
    func getSavedBool() -> Bool {
        return self.saved
    }
    
}

