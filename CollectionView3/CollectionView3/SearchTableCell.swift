//
//  SearchTableCell.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-08-02.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

class SearchTableCell: UITableViewCell {
    
    
    @IBOutlet weak var folderName: UILabel!
    @IBOutlet weak var spotsNum: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    
    @IBOutlet weak var checkIcon: UIImageView!
    
    var isChecked:Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.placeName.textColor = UIColor.green
//        self.imageIcon = UIImageView(image: UIImage(named: "savedFolder"))
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        // Configure the view for the selected state
//    }
    
}
