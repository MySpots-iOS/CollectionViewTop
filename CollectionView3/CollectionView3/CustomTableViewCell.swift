//
//  CustomTableViewCell.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-06-30.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.placeName.textColor = UIColor.green
        self.imageIcon = UIImageView(image: UIImage(named: "savedFolder"))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
