//
//  PlaceInfo.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-07-08.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import Foundation
import UIKit

class PlaceInfo: UIView{
    
    override init(frame: CGRect) {
        super.init(frame:frame )
        loadXibView()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXibView()
    }
    
    func loadXibView() {
        
        let load = Bundle.main.loadNibNamed("PlaceInfo", owner: self, options: nil)?.first as! UIView
 
        load.frame = self.bounds
        self.addSubview(load)
    }

}
