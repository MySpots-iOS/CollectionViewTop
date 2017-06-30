import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    var birds = ["bird1","bird2", "bird3","bird4","bird5","bird6"]
    
    let cvIdentifier = "CollectionViewCell"
    let headerIdentifier = "mySpotsHeader"

    
    @IBOutlet var cView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 90)
        
        cView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        cView!.dataSource = self
        cView!.delegate = self
        cView!.register(CollectionViewCell.self, forCellWithReuseIdentifier: cvIdentifier)
        cView!.backgroundColor = UIColor.white
        
        self.view.addSubview(cView!)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // CollectionViewDelegate Overrides
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return birds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cvIdentifier, for: indexPath) as! CollectionViewCell
        cell.backgroundColor = UIColor.black
//        cell.textLabel?.text = "\(indexPath.section):\(indexPath.row)"
        cell.textLabel?.text = birds[indexPath.row]
        
        cell.imageView?.image = UIImage(named: "mySpot\([indexPath.row])")
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView: SectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! SectionHeader
        
        headerView.headerLabel.text = "My Spots"
        
        return headerView
    }

    
    //Override FlowlayoutDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 144, height: 90)
    }

}

