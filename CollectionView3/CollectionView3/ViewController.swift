import UIKit
import GooglePlaces

class ViewController: UIViewController{
    

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var cView: UICollectionView!
    private let nc = NotificationCenter.default

    var editModeEnabled = false

    let identifier = "CellIdentifier"
    let headerViewIdentifier = "HeaderView"
    let segIdentifier = "mapSeg"
    
    var dataController:DataController!
    
    //Search bar on navigation bar
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nc.addObserver(self, selector: #selector(self.initCompleted(notification:)), name: Notification.Name("FirebaseNotification"), object: nil)

        cView.delegate = self
        cView.dataSource = self
        
        searchBarInit()
    }
    

    @IBAction func addNewFolder(_ sender: UIButton) {
        
        AlertControl.addToNewFolder(self)
    }
    
    
    func initCompleted(notification: Notification?) {
        self.nc.removeObserver(self)
        refreshCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refreshCollectionView()
    }
    
    //If data changed, it must be called to update collection view
    func refreshCollectionView() {
        self.cView?.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func editFolders(_ sender: Any) {
        
        if(editModeEnabled == false) {
            // Put the collection view in edit mode
            editButton.style = .plain
            editButton.title = "Done"
            editModeEnabled = true
            
           //  Loop through the collectionView's visible cells
            for item in self.cView!.visibleCells as! [MySpotsCell] {
                let indexPath: NSIndexPath = self.cView!.indexPath(for: item as MySpotsCell)! as NSIndexPath
                let cell: MySpotsCell = self.cView.cellForItem(at: indexPath as IndexPath) as! MySpotsCell!
                cell.deleteButton.isHidden = false // Hide all of the delete buttons
            }
        } else {
            // Take the collection view out of edit mode
            editButton.style = .plain
            editButton.title = "Edit"
            editModeEnabled = false
            
            // Loop through the collectionView's visible cells
            for item in self.cView!.visibleCells as! [MySpotsCell] {
                let indexPath: NSIndexPath = self.cView.indexPath(for: item as MySpotsCell)! as NSIndexPath
                let cell = self.cView!.cellForItem(at: indexPath as IndexPath) as! MySpotsCell!
                cell?.deleteButton.isHidden = true  // Hide all of the delete buttons
            }
        }
    }
    

    
    
    func getIndexPathForSelectedCell() -> IndexPath? {
        
        var indexPath:IndexPath?
        
        if cView.indexPathsForSelectedItems!.count > 0 {
            indexPath = cView.indexPathsForSelectedItems![0]
        }
        return indexPath
    }
    
    func searchBarInit(){
        //Searchbar Init
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        navigationItem.leftBarButtonItem? = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(goBack))

        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    
    func goBack(){
        self.dismiss(animated: true)
    }
    
    
    func gotoMapView(){
        let newMapView = self.storyboard?.instantiateViewController(withIdentifier: "MapView") as! MapViewController
        
        if getIndexPathForSelectedCell() != nil {
            newMapView.folderIndexPath = getIndexPathForSelectedCell()!
        }
        newMapView.dataController = self.dataController
        
        navigationController?.pushViewController(newMapView, animated: true)
    }
}


extension ViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataController.numberOfFolders()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! MySpotsCell

        
        let image:UIImage = dataController.getImageAtIndex(indexPath.row)
        let folderName = dataController.getFolderLabelAtIndex(indexPath.row)
        let spotsNum = dataController.numberOfSpots(indexPath.row)

        cell.mySpotsLabel.text = folderName
        cell.spotsNumLabel.text = "\(spotsNum) Spots"
        cell.update(image)
        
        if self.navigationItem.rightBarButtonItem!.title == "Edit" {
            cell.deleteButton.isHidden = true
        } else {
            cell.deleteButton.isHidden = false
        }
        
        // Give the delete button an index number
        cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
        
        // Add an action function to the delete button]
        cell.deleteButton.addTarget(self, action: #selector(deleteMySpotsFolder), for: .touchUpInside)
 
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView: SectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerViewIdentifier, for: indexPath) as! SectionHeader
        
        headerView.headerLabel.text = "My Spots"
        return headerView
    }
    
    
    func deleteMySpotsFolder(sender:UIButton) {
        let i: Int = (sender.layer.value(forKey: "index")) as! Int
        dataController.deleteFolderDatabase(i, cView)

    }

}


extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let length = (UIScreen.main.bounds.width-15)/2 - 10
        return CGSize(width: length,height: length*2.5/3);
    }
}

extension ViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) != nil {
            gotoMapView()
        } else {
            // Error indexPath is not on screen: this should never happen.
        }
    }

}


extension ViewController:GMSAutocompleteResultsViewControllerDelegate{

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchMap") as! UINavigationController
        
        let tableVC = vc.viewControllers.first as! SearchMapViewController
        tableVC.place = place
        tableVC.dataController = self.dataController
        self.present(vc, animated: true, completion: nil)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
