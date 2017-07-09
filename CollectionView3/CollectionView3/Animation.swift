//
//  Animation.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-07-08.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import Foundation
import UIKit

struct Animation{
    
    func animateShow(_ view:UIView){
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [],animations: {
            view.center.y -= view.bounds.height
        },completion: nil
        )
    }
    
    
    func animateHide(_ view:UIView){
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [],animations: {
            view.center.y += view.bounds.height
        },completion: nil
        )
    }
}
