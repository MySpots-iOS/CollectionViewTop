//
//  CategoryCell.swift
//  CollectionViewTop
//
//  Created by ayako_sayama on 2017-06-18.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//


import UIKit

class CategoryCell: UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let appCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.black
        
        return collectionView
    }()
    
    
    func setUpViews(){
        self.backgroundColor = UIColor.black
        
        addSubview(appCollectionView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: <#T##String#>, options: <#T##NSLayoutFormatOptions#>, metrics: <#T##[String : Any]?#>, views: <#T##[String : Any]#>))
    }
}

