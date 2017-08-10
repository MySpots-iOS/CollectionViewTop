
import UIKit
import GooglePlaces

class SpotDetailViewController: UIViewController{
    
    @IBOutlet weak var toggleSaveIcon: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeRating: UILabel!
    
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placePhoto: UIImageView!
    
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var placeHours: UILabel!
    @IBOutlet weak var placePhone: UILabel!
    @IBOutlet weak var placeWebsite: UILabel!
    
    var placeID: String = ""
    
    var longitude:Double!
    var latitude:Double!
    var saved: Bool = false
    fileprivate var placesClient: GMSPlacesClient!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.placeName.textColor = UIColor.mainDarkGreen()
        self.directionButton.backgroundColor = UIColor.mainDarkGreen()
        placesClient = GMSPlacesClient.shared()
        getDetailInformationFromID(self.placeID)
        
        if saved == true {
            setSavedIcon()
        } else {
            setUnSavedIcon()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func directionsPressed(_ sender: Any) {
        
        
        if (UIApplication.shared.canOpenURL(NSURL(string:"https://maps.google.com")! as URL))
        {
            
                    if let url = URL(string: "https://maps.google.com/?q=@\(self.latitude!),\(self.longitude!)") {
                        UIApplication.shared.open(url, options: [:], completionHandler:nil)
                    }
        } else{
            NSLog("Can't use com.google.maps://")
          
        }

    }

    func getDetailInformationFromID(_ placeID: String) {
        placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(placeID)")
                return
            }
            
            self.placeName.text = place.name
            self.placeRating.text = String(place.rating)
            self.placeAddress.text = place.formattedAddress
            self.placePhone.text = place.phoneNumber
            self.placeWebsite.text = place.website?.absoluteString
            
            self.longitude = place.coordinate.longitude
            self.latitude = place.coordinate.latitude
            
        })
        
        placesClient.lookUpPhotos(forPlaceID: placeID, callback: { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        })
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                self.placePhoto.image = photo;
                //self.attributionTextView.attributedText = photoMetadata.attributions;
            }
        })
    }
    
    func setSavedIcon() {
        self.toggleSaveIcon.image = UIImage(named: "savedFolder")
    }
    
    func setUnSavedIcon() {
        self.toggleSaveIcon.image = UIImage(named: "saveFolder")
    }
}
