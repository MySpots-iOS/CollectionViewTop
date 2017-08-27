//
//  FolderListTableVC.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-08-07.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

protocol FolderListTableDelegate {
    func receiveFolderOnOff(_ cellIsChecked:[Bool])
}


class FolderListTableVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var cellisChecked:[Bool] = []
    
    var folders:[Folder] = []
    var dataSource:DataController!
    var folderListdelegate:FolderListTableDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        tableView.rowHeight = 80
        folders = dataSource.getFolders()
 
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    
    func back(sender: Any?) {
        
        let cells = tableView.visibleCells
        for foldercell in cells{
                cellisChecked.append(foldercell.isSelected)
        }
        
        self.folderListdelegate?.receiveFolderOnOff(self.cellisChecked)
        self.navigationController?.popViewController(animated: true)
    }

    
    func refreshTableView(){
        tableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension FolderListTableVC: UITableViewDelegate, UITableViewDataSource{


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfFolders()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchVCTableCell", for: indexPath) as! SearchTableCell
        cell.folderName.text = folders[indexPath.row].folderName
        cell.spotsNum.text = "\(folders[indexPath.row].spots.count) spots"
        cell.imageIcon.image = folders[indexPath.row].spots.first?.imageName
        
        if cell.isChecked{
            cell.checkIcon.image = UIImage(named:"icon_checked")
        } else{
            cell.checkIcon.image = UIImage(named: "icon_unchecked")
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! SearchTableCell
        cell.backgroundColor = UIColor.mainLightGray()
        cell.checkIcon.image = UIImage(named: "icon_checked")
            cell.isChecked = false

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! SearchTableCell
        cell.backgroundColor = UIColor.white
        cell.checkIcon.image = UIImage(named: "icon_unchecked")
        cell.isChecked = true

    }
    
  
  
}
