//
//  Animation.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-07-17.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import Foundation
import UIKit


struct Animation {
    
    
    
    func animateShow(_ mapVC:MapViewController){
        UIView.animate(withDuration: 0.5, delay: 0, options: [],animations: {
            mapVC.placeInfoView.center.y -= mapVC.view.bounds.height
        },completion: nil
        )
    }
    
    func animateHide(_ mapVC:MapViewController){
        UIView.animate(withDuration: 0.5, delay: 0, options: [],animations: {
            mapVC.placeInfoView.center.y += mapVC.view.bounds.height
        },completion: nil
        )
    }
}