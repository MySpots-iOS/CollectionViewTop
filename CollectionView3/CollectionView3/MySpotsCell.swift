//
//  MySpotsCell.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-06-28.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

class MySpotsCell: UICollectionViewCell {
    
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var spotsNumLabel: UILabel!
    @IBOutlet weak var mySpotsImage: UIImageView!
    @IBOutlet weak var mySpotsLabel: UILabel!
    

    var folder: Folder?{
        didSet{
//            if let name = folder?.folderName{
//                mySpotsLabel.text = name
//            }
//            
            print("Foldername: \(folder?.folderName ?? "no foldername")")
            
//            mySpotsLabel.text = "\(folder?.spotsNum ?? 0) spots"
//            
//            if let imageName = folder?.imageName{
//                mySpotsImage.image = UIImage(named: imageName)
//            }
        }
    }
    

    
    
    func update(_ image:UIImage?){
        if let photoImage = image{
            mySpotsImage.image = photoImage
        } else{
            mySpotsImage.image = nil
        }
    }
    
//    func update(_ image:UIImage?, _ placeName:String?, _ spotsNum:String?){
//        
//        if image != nil{
//            mySpotsImage.image = image
//        } else{
//            mySpotsImage.image = nil
//        }
//        
//        if placeName != nil{
//            mySpotsLabel.text = placeName
//        }
//        
//        if spotsNum != nil{
//            spotsNumLabel.text = spotsNum
//        }
//    }


}
