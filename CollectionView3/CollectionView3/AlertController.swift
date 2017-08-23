//
//  AlertController.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-07-13.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit


enum AlertAction{
    case AddNewSpot
    case DeleteSpot
    case MakeNewFolder(String)
    case DeleteMarkerDatabase
    case AddFolder(String)
    case MakeEmptyNewFolder(String)
}



protocol AlertControlDelegate{
    func dataAction(_ alertAction:AlertAction)
}


protocol AlertPresentDelegate {
    func showAlertController(_ alertAction: UIAlertController)
}


class AlertControl{
    
    var delegate: AlertControlDelegate?
    var presentDelegate: AlertPresentDelegate??

    
    func saveToFolder(_ folders:[Folder], _ placeInfo:PlaceInformation){

        let alert = UIAlertController(title:"Save to Folder", message: "Select a folder to save your spot", preferredStyle: UIAlertControllerStyle.alert)
        
        
            for folder in folders{
                
                let action = UIAlertAction(title: folder.folderName, style: UIAlertActionStyle.default, handler: {
                    (action: UIAlertAction!) in
                    
                    print(folder.folderName!)
                    print(placeInfo.addressName)
                    
                    self.delegate?.dataAction(AlertAction.AddNewSpot)
                })
                alert.addAction(action)
            }

        
        //The last one creates another dialog
        
        let action3 = UIAlertAction(title: "+ Create New Folder", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            
            let alertController = UIAlertController(title: "Add to New Folder",
                                                    message: "Input new folder name",
                                                    preferredStyle: .alert)
            
            // Add 1 textField and customize it
            alertController.addTextField { (textField: UITextField) in
                textField.keyboardAppearance = .dark
                textField.keyboardType = .default
                textField.autocorrectionType = .default
                textField.placeholder = "Type something here"
                textField.clearButtonMode = .whileEditing
            }
            
            // Submit button
            let submitAction = UIAlertAction(title: "Submit", style:.destructive , handler: { (action) -> Void in
                // Get 1st TextField's text
                let textField = alertController.textFields![0]
                print(textField.text!)
                
                self.delegate?.dataAction(AlertAction.MakeNewFolder(textField.text!))
            })
            
            // Cancel button
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in })
            
            // Add action buttons and present the Alert
            alertController.addAction(cancel)
            alertController.addAction(submitAction)
            
            
            self.presentDelegate??.showAlertController(alertController)
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in
        })
        
        alert.addAction(action3)
        alert.addAction(cancel)
        
        self.presentDelegate??.showAlertController(alert)
    }
    
    
    func deleteFromFolder(_ placeInfo:PlaceInformation){
        
        
        let alertController = UIAlertController(title: "Delete Spot?",
                                                message: " ",
                                                preferredStyle: .alert)
        
        // Submit button
        let submitAction = UIAlertAction(title: "Delete", style:.destructive , handler: { (action) -> Void in
            
            placeInfo.marker.map = nil
            placeInfo.setUnSavedIcon()
            placeInfo.saved = false

            self.delegate?.dataAction(AlertAction.DeleteMarkerDatabase)
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in })
        
        // Add action buttons and present the Alert
        alertController.addAction(cancel)
        alertController.addAction(submitAction)
        
        self.presentDelegate??.showAlertController(alertController)
    }

    
    
    func addToNewFolder(){
        let alertController = UIAlertController(title: "Add New Folder",
                                                message: "Input new folder name",
                                                preferredStyle: .alert)
        
        // Add 1 textField and customize it
        alertController.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Type something here"
            textField.clearButtonMode = .whileEditing
        }
        
        // Submit button
        let submitAction = UIAlertAction(title: "Add", style:.destructive , handler: { (action) -> Void in
            // Get 1st TextField's text
            let textField = alertController.textFields![0]
            print(textField.text!)
            
            self.delegate?.dataAction(AlertAction.AddFolder(textField.text!))
            self.delegate?.dataAction(AlertAction.MakeEmptyNewFolder(textField.text!))
            
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in })
        
        // Add action buttons and present the Alert
        alertController.addAction(cancel)
        alertController.addAction(submitAction)
        
        self.presentDelegate??.showAlertController(alertController)
    }

}
