import UIKit
import GooglePlaces

class ViewController: UIViewController{
    

    @IBOutlet weak var cView: UICollectionView!
    private let nc = NotificationCenter.default

    
    let identifier = "CellIdentifier"
    let headerViewIdentifier = "HeaderView"
    let segIdentifier = "mapSeg"
    
    var dataSource:DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = DataSource()

        nc.addObserver(self, selector: #selector(self.initCompleted(notification:)), name: Notification.Name("FirebaseNotification"), object: nil)

        cView.delegate = self
        cView.dataSource = self
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if getIndexPathForSelectedCell() != nil {
            let newMapView = segue.destination as! MapViewController
            newMapView.folderIndexPath = getIndexPathForSelectedCell()!
            newMapView.dataSource = self.dataSource
        }
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !isEditing
    }
    
    
    func getIndexPathForSelectedCell() -> IndexPath? {
        
        var indexPath:IndexPath?
        
        if cView.indexPathsForSelectedItems!.count > 0 {
            indexPath = cView.indexPathsForSelectedItems![0]
        }
        return indexPath
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
