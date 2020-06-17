//
//  MediaCardTableViewCell.swift
//  card2
//
//  Created by Kshitiz Sharma on 08/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

//TODO: change cell height according to sizetype(changed by pinch in timelineviewcontroller)
import UIKit
//TODO: update cell heights properly, currently updated when image is tapped
class MediaCardTableViewCell: UITableViewCell {

    var delegate: myUpdateCellHeightDelegate?
    var showLinkDelegate: timelineSwitchDelegate?
    var sizeType = cardSizeMode.full
    var row = 0
    var indexpath = IndexPath(row: 0, section: 0)
    var allImages = [UIImage]()
    
    @IBOutlet weak var cardBackgroundView: UIView!{
        didSet{
            cardBackgroundView.layer.cornerRadius=15
            //Draw shaddow for layer
            cardBackgroundView.layer.shadowColor = UIColor.gray.cgColor
            cardBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cardBackgroundView.layer.shadowRadius = 5.0
            cardBackgroundView.layer.shadowOpacity = 0.2
        }
    }
    @IBOutlet weak var linkView: UIImageView!{
        didSet{
            linkView.isUserInteractionEnabled=true
             linkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLinkViewTap)))
        }
    }
    @objc func handleLinkViewTap(){
           print("yet to implement did tap linkview in mediacard timeline")
        showLinkDelegate!.switchToPageAndShowCard(with: (card?.UniquIdentifier)!)
       }
    //    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
//    @IBOutlet weak var myImageView: UIImageView!{
//        didSet{
//            myImageView.contentMode = .scaleAspectFill
//            myImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(updateHeight)))
//        }
//    }
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.dataSource=self
            collectionView.delegate=self
            collectionView.register(ThumbCell.self,forCellWithReuseIdentifier: ThumbCell.reuseIdentifier)
        }
    }
    
    
    var card: MediaCard?
    @objc func updateHeight(){
        print("yet to implement updateHeight")
//        switch sizeType {
//        case .full:
//            imageViewWidthConstraint.constant=125
//        case .medium:
//            imageViewWidthConstraint.constant=85
//        case .small:
//            imageViewWidthConstraint.constant=50
//        default:
//            print("need to handle this value of sizeType in MediaCardTableViewCell")
//        }
//        UIView.animate(withDuration: 0.3, animations: {
//            self.updateHeightDelegate?.updated(height: 100, row: self.row, indexpath: self.indexpath)
//        })
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius=cornerRadius
        self.layer.masksToBounds=true
        allImages.removeAll()
//        if let xyz = card?.data{
//            for dat in xyz{
//                if let x = dat as? UIImage{
//                    allImages.append(x)
//                }
//            }
//        }
        //MARK: media dat to img conversion
//        if let datList = card?.mediaData{
//            for dat in datList{
//                if let img = UIImage(data: dat){
//                    allImages.append(img)
//                    print("succesfully added from dat image")
//                }
//            }
//        }
        //MARK: URL based implementation for getting image
        if let datList = card?.mediaDataURLs{
//            for fileName in datList{
//                if let url = try? FileManager.default.url(
//                    for: .documentDirectory,
//                    in: .userDomainMask,
//                    appropriateFor: nil,
//                    create: true
//                ).appendingPathComponent(fileName){
//                    if let jsonData = try? Data(contentsOf: url){
//                        print("did retrieve jsondata")
//                        if let extract = imageData(json: jsonData){
//                            if let image = UIImage(data: extract.data){
//                                print("did get UIImage from extrated data")
//                                allImages.append(image)
//                            }else{
//                                print("couldn't get UIImage from extrated data, check if sure this file doesn't exist and if so delete it from array")
//                            }
//                        }
            //                    }
            //                }
            //            }
            for _ in datList{
                allImages.append(UIImage())
            }
            for fileName in datList{
                DispatchQueue.global(qos: .background).async {
//                    print("tryihg to retrieve jsondata from url: \(fileName)")
                    if let url = try? FileManager.default.url(
                        for: .documentDirectory,
                        in: .userDomainMask,
                        appropriateFor: nil,
                        create: true
                    ).appendingPathComponent(fileName){
                        if let jsonData = try? Data(contentsOf: url){
//                            print("did retrieve jsondata MediaTableViewcell")
                            if let extract = imageData(json: jsonData){
                                //DO NOT CHANGE TO LET CAUSES PROBLEM IN NEXT ITERATION
//                                print("checking if element a image: json ver MediaTableViewcell")
                                if let image = UIImage(data: extract.data){
//                                    print("did get UIImage from extrated data")
                                    if let pos = datList.firstIndex(of: fileName){
                                        if pos<self.allImages.count{
                                            self.allImages[pos]=image
                                            DispatchQueue.main.async {
                                                self.collectionView.reloadData()
                                            }
                                        }
                                    }
                                }else{
                                    print("couldn't get UIImage from extrated data, check if sure this file doesn't exist and if so delete it from array")
                                }
                            }else{
                                print("couldnt get json from URL")
                            }
                        }
                    }
                }
            }
        }
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        if collectionView != nil{
            self.collectionView.collectionViewLayout = layout
            self.collectionView!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:0, right: 0)
            self.collectionView.isPagingEnabled=true
            if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumInteritemSpacing = spacings
                layout.minimumLineSpacing = spacings
                layout.itemSize = CGSize(width: self.collectionView.frame.size.height-spacings, height: self.collectionView.frame.size.height-spacings)
                layout.invalidateLayout()
            }
            collectionView.reloadData()
        }
    }

}

extension MediaCardTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("no. of images in cv = \(allImages.count) ")
//        return (card?.data.count)!
        return allImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {        let cell:ThumbCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: ThumbCell.reuseIdentifier, for: indexPath) as! ThumbCell
//        cell.imageView.image = card?.data[indexPath.item] as? UIImage
        cell.imageView.image = allImages[indexPath.item]
        cell.layer.cornerRadius=imageCornerRadius
        cell.layer.masksToBounds=true
        cell.imageView.setupImageViewer()
        cell.imageView.setupImageViewer(images: allImages, initialIndex: indexPath.item)
        
        return cell
    }
    
    
    
}

extension MediaCardTableViewCell{
    var imageCornerRadius: CGFloat{
        return 6.0
    }
    var cornerRadius: CGFloat{
        return 20.0
    }
    var spacings: CGFloat{
        return 10.0
    }
}
