//
//  CollectionViewCell.swift
//  MySpots
//
//  Created by Michinobu Nishimoto on 2017-06-22.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    var folder: Folder? {
        didSet{
            if let name = folder?.folderName {
                nameLabel.text = name
            }
            
            print("Foldername: \(folder?.folderName ?? "no foldername")")
            
            categoryLabel.text = folder?.category
            spotsLabel.text = "\(folder?.spots.count ?? 0) spots"
            
            if let imageName = folder?.imageName {
                imageView.image = UIImage(named: imageName)
            }
        }
    }
    
    //Add imageView
    var imageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Disney"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    
    let categoryLabel:UILabel = {
        let catLabel = UILabel()
        catLabel.text = "categoryLabel"
        catLabel.font = .systemFont(ofSize: 13)
        return catLabel
    }()
    
    
    let spotsLabel:UILabel = {
        let catLabel = UILabel()
        catLabel.text = "13 Spots"
        catLabel.font = .systemFont(ofSize: 13)
        return catLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setUpView(){
        backgroundColor = UIColor.clear
        
        addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        
        addSubview(nameLabel)
        nameLabel.frame = CGRect(x: 0, y: frame.width + 2, width: frame.width, height: 40)
        
        addSubview(categoryLabel)
        categoryLabel.frame = CGRect(x: 0, y: frame.width + 42, width: frame.width, height: 20)
        
        addSubview(spotsLabel)
        spotsLabel.frame = CGRect(x: 0, y: frame.width + 56, width: frame.width, height: 20)
    }
    
    func setSpotFolder(_ folder: Folder?) {
        self.folder = folder
    }
    
}

