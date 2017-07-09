//
//  PlaceInformation.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-06-30.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

class PlaceInformation: UIView {

    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var addressName: UILabel!
    @IBOutlet weak var distanceIcon: UIImageView!
    
    var placeID: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizesSubviews = false
        loadXibView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXibView()
    }
    
    func loadXibView() {
        let view = Bundle.main.loadNibNamed( "PlaceInformation", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.placeName.textColor = UIColor.green
        self.distanceIcon.isUserInteractionEnabled = true
        self.addSubview(view)
    }
    
    func setSelectedPlaceName(_ name:String) {
        self.placeName.text = name
    }
    
    func setSelectedAddress(_ address: String) {
        self.addressName.text = address
    }
    
    func setGooglePlaceID(_ placeID: String) {
        self.placeID = placeID
    }
    
    func gerGooglePlaceID() -> String {
        return self.placeID
    }
    


}
