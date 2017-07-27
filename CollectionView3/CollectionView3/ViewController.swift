import UIKit
import GooglePlaces

class ViewController: UIViewController{
    

    @IBOutlet weak var cView: UICollectionView!
    private let nc = NotificationCenter.default

    
    let identifier = "CellIdentifier"
    let headerViewIdentifier = "HeaderView"
    let segIdentifier = "mapSeg"
    
    var dataSource:DataSource!
    
    //Search bar on navigation bar
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = DataSource()

        nc.addObserver(self, selector: #selector(self.initCompleted(notification:)), name: Notification.Name("FirebaseNotification"), object: nil)

        cView.delegate = self
        cView.dataSource = self
        
        searchBarInit()
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
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if getIndexPathForSelectedCell() != nil {
//            let newMapView = segue.destination as! MapViewController
//            newMapView.folderIndexPath = getIndexPathForSelectedCell()!
//            newMapView.dataController = self.dataSource
//        }
//    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        return !isEditing
//    }
    
    
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
}


extension ViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.folders.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! MySpotsCell


        let placesClient:GMSPlacesClient = GMSPlacesClient.shared()
        dataSource.getImageNameAtIndex(indexPath, placesClient, cell)

        let folderName = dataSource.getFolderLabelAtIndex(indexPath.row)
        let spotsNum = dataSource.numberOfSpots(indexPath.row)

        cell.mySpotsLabel.text = folderName
        cell.spotsNumLabel.text = "\(spotsNum) Spots"

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView: SectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerViewIdentifier, for: indexPath) as! SectionHeader
        
        headerView.headerLabel.text = "My Spots"
        return headerView
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
            
            let newMapView = self.storyboard?.instantiateViewController(withIdentifier: "MapView") as! MapViewController
            newMapView.folderIndexPath = getIndexPathForSelectedCell()!
            newMapView.dataController = self.dataSource
            
            navigationController?.pushViewController(newMapView, animated: true)
//            performSegue(withIdentifier: "showDetail", sender: cell)
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
