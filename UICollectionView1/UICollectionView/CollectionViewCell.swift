


import UIKit

class CollectionViewCell: UICollectionViewCell {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    var textLabel: UILabel!
    var imageView: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height*2/3))
        imageView.backgroundColor = UIColor.blue
        imageView.contentMode = UIViewContentMode.scaleToFill
        contentView.addSubview(imageView)
        
        let textFrame = CGRect(x: 0, y: frame.size.height*2/3, width: frame.size.width, height: frame.size.height/3)
        textLabel = UILabel(frame: textFrame)
        textLabel.backgroundColor = UIColor.orange
        textLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        textLabel.textAlignment = .center
        contentView.addSubview(textLabel)
    }
}
