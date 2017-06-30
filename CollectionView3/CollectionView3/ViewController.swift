//
//  ViewController.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-06-28.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    @IBOutlet weak var cView: UICollectionView!
    
//    private let nc = NotificationCenter.default

    
    let identifier = "CellIdentifier"
    let headerViewIdentifier = "HeaderView"
    let segIdentifier = "mapSeg"
    
    var dataSource:DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = DataSource()
//
//        nc.addObserver(self, selector: #selector(self.initCompleted(notification:)), name: Notification.Name("FirebaseNotification"), object: nil)

        cView.delegate = self
        cView.dataSource = self
    }
    
//    func initCompleted(notification: Notification?) {
////        self.topPageCategories?.append(fbController.mySpots)
//        // no longer to hold the observer
//        self.nc.removeObserver(self)
//        refreshCollectionView()
//    }
//    
    /**
     If data changed, it must be called to update collection view
     */
//    func refreshCollectionView() {
//        self.cView?.reloadData()
//    }
//    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:- prepareForSegue
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        
//        if getIndexPathForSelectedCell() != nil {
//            
////            let fruit = dataSource.fruitsInGroup(indexPath.section)[indexPath.row]
//            _ = segue.destination as! MapViewController
////            detailViewController.label.text = "\(indexPath)"
//        }
//    }
//    
//    // MARK:- Should Perform Segue
//    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        return !isEditing
//    }
//    
//    // MARK:- Selected Cell IndexPath
//    
//    func getIndexPathForSelectedCell() -> IndexPath? {
//        
//        var indexPath:IndexPath?
//        
//        if cView.indexPathsForSelectedItems!.count > 0 {
//            indexPath = cView.indexPathsForSelectedItems![0]
//        }
//        return indexPath
//    }

}



extension ViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! MySpotsCell
        
//        let fruits: [Fruit] = dataSource.fruitsInGroup(indexPath.section)
//        let fruit = fruits[indexPath.row]
//        
//        let name = fruit.name!
        
        cell.mySpotsImage.image = UIImage(named: "sayama4")
        cell.mySpotsLabel.text = "My Spots"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView: SectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerViewIdentifier, for: indexPath) as! SectionHeader
        
        headerView.headerLabel.text = "My Spots"
        
        return headerView
    }
}



extension ViewController: UICollectionViewDelegateFlowLayout {
    // MARK:- UICollectioViewDelegateFlowLayout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        let length = (UIScreen.main.bounds.width-15)/2 - 10
        return CGSize(width: length,height: length*2.5/3);
    }
}
