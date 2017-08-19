
import UIKit
import GoogleMaps

class PlaceInformation: UIView, UIGestureRecognizerDelegate, AlertControlDelegate{

    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var addressName: UILabel!
    @IBOutlet weak var placeRating: UILabel!
    @IBOutlet weak var distanceIcon: UIImageView!
    
    var placeID: String = ""
    var saved: Bool = false
    var vc:CommonViewController!
    var marker:GMSMarker!
    
    @IBOutlet var gestureR: UITapGestureRecognizer!
    
    init(_ vc:CommonViewController, frame: CGRect) {
        super.init(frame: frame)
        
        self.vc = vc
        autoresizesSubviews = false
        AlertControl.delegate = self
        loadXibView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXibView()
    }

    @IBAction func savedIconTapped(_ sender: Any?) {
//        let alert = AlertControl.init(vc, self)
        
        if !saved{
            AlertControl.saveToFolder(vc, self)
        } else {
            AlertControl.deleteFromFolder(vc, vc.folder, self)
        }
    }
    
    func dataAction(_ action:AlertAction){
        
        switch action {
        case .AddNewSpot:
            vc.dataController.addNewSpot(self, vc.folder.folderName!)
      
            
        default:
            <#code#>
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

