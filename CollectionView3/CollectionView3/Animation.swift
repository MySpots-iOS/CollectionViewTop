//
//  Animation.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-07-17.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import Foundation
import UIKit


class Animation {
    

    static func animateShow(_ tableViewWrapper: UIView, _ placeInfoView:UIView,  _ boundsHeight:CGFloat, _ vcFlag:ViewControllerFlag){
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [],animations: {
            placeInfoView.center.y -= boundsHeight
            tableViewWrapper.center.y += boundsHeight
        },completion: nil
        )
    }
    
    static func animateHide(_ tableViewWrapper: UIView, _ placeInfoView:UIView,  _ boundsHeight:CGFloat, _ vcFlag:ViewControllerFlag){
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [],animations: {
            placeInfoView.center.y += boundsHeight
            tableViewWrapper.center.y -= boundsHeight
        },completion: nil
        )
    }
    
    static func animateShowList(_ tableViewWrapper:UIView, _ tableViewHeader:UILabel, _ boundsHeight:CGFloat){
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut,animations: {
            tableViewWrapper.center.y -= boundsHeight - tableViewHeader.bounds.height
            tableViewHeader.text = "Hide List"
        },completion: nil
        )
    }
    
    static func animateHideList(_ tableViewWrapper:UIView, _ tableViewHeader:UILabel, _ boundsHeight:CGFloat){
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut,animations: {
            tableViewWrapper.center.y += boundsHeight - tableViewHeader.bounds.height
            tableViewHeader.text = "Show List"
        },completion: nil
        )
    }
    
    
}


