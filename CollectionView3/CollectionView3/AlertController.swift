//
//  AlertController.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-07-13.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

class AlertControl{

    static func saveToFolder(_ vc:CommonViewController, _ placeInfo:PlaceInformation){

        let alert = UIAlertController(title:"Save to Folder", message: "Select a folder to save your spot", preferredStyle: UIAlertControllerStyle.alert)
        
        
        let folders = vc.dataController.getFolders()
        for folder in folders{
            
            let action = UIAlertAction(title: folder.folderName, style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                
                print(folder.folderName!)
                 print(placeInfo.addressName)
                
                vc.dataController.addNewSpot(placeInfo, folder.folderName!)
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
                vc.dataController.makeNewFolder(textField.text!, placeInfo)
            })
            
            // Cancel button
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in })
            
            // Add action buttons and present the Alert
            alertController.addAction(cancel)
            alertController.addAction(submitAction)
            vc.present(alertController, animated: true, completion: nil)
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in
        })
        
        alert.addAction(action3)
        alert.addAction(cancel)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    
    static func deleteFromFolder(_ vc:CommonViewController, _ folder:Folder, _ placeInfo:PlaceInformation){
        
        
        let alertController = UIAlertController(title: "Delete Spot?",
                                                message: " ",
                                                preferredStyle: .alert)
        
        // Submit button
        let submitAction = UIAlertAction(title: "Delete", style:.destructive , handler: { (action) -> Void in
            
            placeInfo.marker.map = nil
            placeInfo.setUnSavedIcon()
            placeInfo.saved = false

            
            
            vc.dataController.deleteMarkerDatabase(folder.folderName!, placeInfo)
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in })
        
        // Add action buttons and present the Alert
        alertController.addAction(cancel)
        alertController.addAction(submitAction)
        vc.present(alertController, animated: true, completion: nil)
    }

    
    
    static func addToNewFolder(_ vc:ViewController){
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
            
            vc.dataController.addFolder(textField.text!)
            vc.cView.reloadData()
            
            vc.dataController.makeEmptyNewFolder(textField.text!)
            
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in })
        
        // Add action buttons and present the Alert
        alertController.addAction(cancel)
        alertController.addAction(submitAction)
        vc.present(alertController, animated: true, completion: nil)
    }

}
