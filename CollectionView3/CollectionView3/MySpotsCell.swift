//
//  MySpotsCell.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-06-28.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

class MySpotsCell: UICollectionViewCell {
    
    
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


}
