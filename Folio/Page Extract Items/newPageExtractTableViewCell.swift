//
//  newPageExtractTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 11/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class newPageExtractTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    var delegate: pageListeProtocol?
    var cardTitles = ["Today", "Scheduled", "All", "Due"]
    var countValues = [0, 0, 0, 0]
    //needs to be consistent with colorScheme in PageExtractViewController
    var colorScheme: [UIColor] = [#colorLiteral(red: 0.1969698071, green: 0.5599908233, blue: 1, alpha: 1), #colorLiteral(red: 0.968898952, green: 0.5462294221, blue: 0.2176432312, alpha: 1), #colorLiteral(red: 0.2600299716, green: 0.8386341929, blue: 0.3872584999, alpha: 1), #colorLiteral(red: 0.9601965547, green: 0.1390784979, blue: 0.327912569, alpha: 1)]
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.dataSource=self
            collectionView.delegate=self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        if collectionView != nil{
            self.collectionView.collectionViewLayout = layout
            self.collectionView!.contentInset = UIEdgeInsets(top: 0, left: 20, bottom:0, right: 0)
            self.collectionView.isPagingEnabled=true
            if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumInteritemSpacing = spacings
                layout.minimumLineSpacing = verticalSpacing
//                layout.itemSize = CGSize(width: self.collectionView.frame.size.height-spacings, height: self.collectionView.frame.size.height-spacings)
//                layout.itemSize = CGSize(width: (self.collectionView.frame.size.height-spacings)*1.6, height: self.collectionView.frame.size.height-spacings)
                layout.itemSize = CGSize(width: 120, height: 110)
                layout.invalidateLayout()
            }
            collectionView.reloadData()
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
//        cell.image.tintColor = .white
//        cell.image.backgroundColor = colorScheme[indexPath.row]
        let cell = cardCell(collectionView, cellForItemAt: indexPath)
        cell.myIndex=indexPath.row
        cell.image.tintColor = .white
//        cell.image.backgroundColor = colorScheme[indexPath.row]
        cell.imageBackgroundView.backgroundColor = colorScheme[indexPath.row]
        cell.numberLabel.text = String(countValues[indexPath.row])
        cell.image.layer.cornerRadius=12
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedIndex)))
        switch indexPath.row {
        case 0:
            cell.image.image = UIImage(systemName: "calendar.circle")
            cell.textLablel.text = "Today"
            return cell
        case 1:
            cell.image.image = UIImage(systemName: "alarm")
            cell.textLablel.text = "Scheduled"
            return cell
        case 2:
            cell.image.image = UIImage(systemName: "tray")
            cell.textLablel.text = "All"
            return cell
        case 3:
            cell.image.image = UIImage(systemName: "exclamationmark.circle")
            cell.textLablel.text = "Due"
            return cell
        default:
            return cell
        }
    }
    func cardCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> MyCollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        cell.contentView.backgroundColor = UIColor(named: "smallCardColor") ?? UIColor.red
        
        cell.layer.cornerRadius = 15.0
        cell.contentView.layer.cornerRadius = 15.0
        cell.layer.masksToBounds = false
        //Draw shaddow for layer
        cell.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 0.2
        return cell
    }
    @objc func selectedIndex(_ sender: UITapGestureRecognizer){
        if let x=sender.view as? MyCollectionViewCell{
            delegate?.performSegueForExtractView(for: x.myIndex)
        }
    }
}

extension newPageExtractTableViewCell{
    var cornerRadius: CGFloat{
        return 20.0
    }
    var spacings: CGFloat{
        return 10.0
    }
    var verticalSpacing: CGFloat{
        return 25.0
    }
}

class MyCollectionViewCell: UICollectionViewCell {
    var myIndex=0
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageBackgroundView: UIView!{
        didSet{
            imageBackgroundView.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var textLablel: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    // have outlets for any views in your storyboard cell
}
