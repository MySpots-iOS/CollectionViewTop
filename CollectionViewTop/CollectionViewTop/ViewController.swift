//
//  ViewController.swift
//  CollectionViewTop
//
//  Created by ayako_sayama on 2017-06-17.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

class TopPageViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    
    private let cellid = "cellid"
    
    var topPageCategory: [ToppageCategory]?
    
    //Override UICollectionViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        topPageCategory = ToppageCategory.topPageCategories()
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(CategoryCell.self,forCellWithReuseIdentifier: cellid)
        view.addSubview(collectionView!)

    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! CategoryCell
        
        //for each cell, assign it to a ToppageCategory Class
        cell.topPageCategory = topPageCategory?[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = topPageCategory?.count{
            return count
        }
        return 0
    }
    
    
    //Override FlowlayoutDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 230)
    }
    

}


