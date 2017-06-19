//
//  CategoryCell.swift
//  CollectionViewTop
//
//  Created by ayako_sayama on 2017-06-18.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//


import UIKit

class CategoryCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    

    
    private let cellid = "myspotCellid"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    
    //add another collectionview in category cell
    let myspotsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        layout.scrollDirection = .horizontal
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let divideLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameCatLabel:UILabel = {
       let label = UILabel()
        label.text = "Best New Apps"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    func setUpViews(){
        self.backgroundColor = UIColor.clear
        
        addSubview(myspotsCollectionView)
        addSubview(divideLineView)
        addSubview(nameCatLabel)
        
        myspotsCollectionView.dataSource = self
        myspotsCollectionView.delegate = self
        
        myspotsCollectionView.register(MySpotCell.self, forCellWithReuseIdentifier: cellid)
        
        //horizontal constraint
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": divideLineView]))
        
        //vertital constraint
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": myspotsCollectionView]))
        
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameCatLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameCatLabel(30)][v0][v1(0.5)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": myspotsCollectionView, "v1": divideLineView, "nameCatLabel": nameCatLabel]))
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{

        return collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: frame.height - 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }

}


class MySpotCell: UICollectionViewCell{
    
    
    //Add imageView
    let imageView:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "cafe1")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}
