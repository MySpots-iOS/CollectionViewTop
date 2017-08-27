
import UIKit
import GooglePlaces

class SpotDetailViewController: UIViewController{
    
    @IBOutlet weak var toggleSaveIcon: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeRating: UILabel!
    
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placePhoto: UIImageView!
    
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var placeHours: UITextView!
    @IBOutlet weak var placePhone: UITextView!
    @IBOutlet weak var placeWebsite: UITextView!
    @IBOutlet weak var placeDescription: UITextView!
    
    var gmsPlace:GMSPlace!
    
    var longitude:Double!
    var latitude:Double!
    var saved: Bool = false
    var alertControl:AlertControl!
    var dataController:DataController!
    
    @IBOutlet weak var ratingOne: UIImageView!
    @IBOutlet weak var ratingTwo: UIImageView!
    @IBOutlet weak var ratingThree: UIImageView!
    @IBOutlet weak var ratingFour: UIImageView!
    @IBOutlet weak var ratingFive: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

//        scrollView.delegate = self.scrollView as? UIScrollViewDelegate
//        self.scrollView.contentSize = CGSize(width: 375, height: self.view.frame.height)
        
        
        self.placeName.textColor = UIColor.mainDarkGreen()
        self.directionButton.backgroundColor = UIColor.mainDarkGreen()
        getDetailInformationFromID(gmsPlace)
        alertControl = AlertControl()
        alertControl.delegate = self
        alertControl.presentDelegate = self
        
        if saved == true {
            setSavedIcon()
        } else {
            setUnSavedIcon()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func iconPressed(_ sender: Any) {
        if !saved{
            let folders = dataController.getFolders()
            alertControl.saveToFolder(folders)
        } else {
            alertControl.deleteFromFolder()
        }
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
    
    func setFullStar(_ imageView:UIImageView){
        imageView.image = #imageLiteral(resourceName: "icon_fullstar")
    }
    
    func setEmptyStar(_ imageView:UIImageView){
        imageView.image = #imageLiteral(resourceName: "icon_empty")
    }
    
    func setHalfStar(_ imageView:UIImageView){
        imageView.image = #imageLiteral(resourceName: "icon_halfstar")
    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollView.contentOffset.y = 0.0
//    }
//    


    func getDetailInformationFromID(_ gmsPlace: GMSPlace?) {

        guard let place:GMSPlace = gmsPlace else {
            print("No place details for \(self.gmsPlace.placeID)")
            return
        }
            
        self.placeName.text = place.name


        if place.rating >= 1 { setFullStar(ratingOne)}
        else if place.rating > 0 && place.rating < 1 { setHalfStar(ratingOne)}
        else{setEmptyStar(ratingOne)}
        
        
        if place.rating >= 2 { setFullStar(ratingTwo)}
        else if place.rating > 1 && place.rating < 2 { setHalfStar(ratingTwo)}
        else { setEmptyStar(ratingTwo)}
        
        if place.rating >= 3{ setFullStar(ratingThree)}
        else if place.rating > 2 && place.rating < 3 { setHalfStar(ratingThree)}
        else{ setEmptyStar(ratingThree)}
        
        if place.rating >= 4 { setFullStar(ratingFour)}
        else if place.rating > 3 && place.rating < 4{ setHalfStar(ratingFour)}
        else{ setEmptyStar(ratingFour)}
        
        if place.rating  >= 5 { setFullStar(ratingFive) }
        else if place.rating > 4 && place.rating < 5 { setHalfStar(ratingFive)}
        else { setEmptyStar(ratingFive)}
        
        
        self.placeRating.text = String(place.rating)
        
        self.placeAddress.text = place.formattedAddress
        self.placePhone.text = place.phoneNumber
        self.placeWebsite.text = place.website?.absoluteString
        self.placeDescription.text = place.description
            
//        switch(place.openNowStatus){
//            case .yes:
//                self.placeHours.text = "Now Open"
//            case .no:
//                self.placeHours.text = "Closed"
//            case .unknown:
//                self.placeHours.text = "N/A"
//        }
        
        self.longitude = place.coordinate.longitude
        self.latitude = place.coordinate.latitude
        
        
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: place.placeID, callback: { (photos, error) -> Void in
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


extension SpotDetailViewController: AlertControlDelegate, AlertPresentDelegate{
    
    func showAlertController(_ alertAction: UIAlertController) {
        self.present(alertAction, animated: true, completion: nil)
    }
    
    func dataAction(_ action: AlertAction) {
        
        switch action {
        case let .AddNewSpot(name):
            dataController.addNewSpot(gmsPlace, name)
        case let .MakeNewFolder(name):
            dataController.makeNewFolder(name, gmsPlace)
        case .DeleteMarkerDatabase:
            
            setUnSavedIcon()
            saved = false
            let folderName = dataController.findKeyForValue(self.gmsPlace.placeID)
            dataController.deleteMarkerDatabase(folderName!, self.gmsPlace.placeID)
        default:
            return
        }
    }
    
}
