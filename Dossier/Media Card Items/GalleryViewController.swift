//
//  GalleryViewController.swift
//  card2
//
//  Created by Kshitiz Sharma on 08/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//
import UIKit
import ImageViewer_swift
import SPStorkController
import SPFakeBar
import ImagePicker

class WithImagesViewController:UIViewController {

    var images = [UIImage]()
//    var viewLinkedTo:MediaCardView?
//    var myViewController: PageViewController?
    
    lazy var layout = GalleryFlowLayout()
    let navBar = SPFakeBarView(style: .noContent)
    
    lazy var collectionView:UICollectionView = {
        // Flow layout setup
//        layout.sectionInset = UIEdgeInsets(top: 50, left: 50, bottom: 0, right: 0)
        let cv = UICollectionView(
            frame: .zero, collectionViewLayout: layout)
        cv.register(
            ThumbCell.self,
            forCellWithReuseIdentifier: ThumbCell.reuseIdentifier)
        cv.dataSource = self
        return cv
    }()
    @objc func addImage(){
        //MARK: set a new json and use corrosponding url for new image
        print("now have to add image")
        
        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 0
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
        /*
        pickImage().pickImage(self) { (image) in
            self.images.append(image)
            self.collectionView.reloadData()
            let fileName=String.uniqueFilename(withPrefix: "iamgeData")+".json"
            if let json = imageData(instData: (image.resizedTo1MB()!).pngData()!).json {
                if let url = try? FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                ).appendingPathComponent(fileName){
                    do {
                        try json.write(to: url)
                        print ("saved successfully")
                        //MARK: is a data leak to be corrected
                        //TODO: sometimes fileName added but not deleted
                        self.viewLinkedTo?.card.mediaDataURLs.append(fileName)
                        self.viewLinkedTo?.layoutSubviews()
                    } catch let error {
                        print ("couldn't save \(error)")
                    }
                }
            }
        }
        */
    }
    
    override func loadView() {
        super.loadView()
        view = UIView()
        self.navBar.titleLabel.text = "Media"
        navBar.backgroundColor = navBarColour
        navBar.rightButton = UIButton()
//        navBar.rightButton.titleLabel?.text = "Done"
//        navBar.rightButton.titleLabel?.tintColor = .systemTeal
//        navBar.rightButton.actions(forTarget: self.dismiss(animated: true, completion: nil), forControlEvent: .touchDown)
        navBar.titleLabel.textColor = UIColor.systemTeal
        if(view.subviews.contains(self.navBar)==false){
            view.addSubview(self.navBar)
        }
        view.backgroundColor = backgroundColor
        collectionView.backgroundColor = backgroundColor
        view.addSubview(collectionView)
        collectionView.backgroundColor = navBar.backgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor
            .constraint(equalTo: navBar.bottomAnchor)
            .isActive = true
        collectionView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
            .isActive = true
        collectionView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
            .isActive = true
        collectionView.bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
            .isActive = true
        collectionView.delegate=self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gallery"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateLayout(view.frame.size)
    }
    
    private func updateLayout(_ size:CGSize) {
        if size.width > size.height {
            layout.columns = 4
        } else {
            layout.columns = 3
        }
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator) {
        updateLayout(size)
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
}

extension WithImagesViewController:UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return images.count+1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:ThumbCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: ThumbCell.reuseIdentifier,
                                 for: indexPath) as! ThumbCell
        cell.layer.cornerRadius=cellCornerRadius
        cell.layer.masksToBounds=true
        if indexPath.item<images.count{
            cell.imageView.image = images[indexPath.item]
            // Setup Image Viewer with [UIImage]
            cell.imageView.setupImageViewer(
                images: images,
                initialIndex: indexPath.item)
        }else{
            let image =  UIImage(systemName: "plus")!
//            cell.imageView.preferredSymbolConfiguration = .some(UIImage.SymbolConfiguration.init(pointSize: 20, weight: .thin))
            cell.imageView.preferredSymbolConfiguration = .init(pointSize: 20, weight: .thin, scale: .small)
            cell.imageView.image = image
            cell.imageView.tintColor = .systemTeal
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addImage)))
        }
        return cell
    }
}

extension WithImagesViewController: UICollectionViewDelegate, UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SPStorkController.scrollViewDidScroll(scrollView)
    }
}
extension WithImagesViewController: ImagePickerDelegate{
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("x")
        imagePicker.expandGalleryView()
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("y")
//        imagePicker.dismiss(animated: true) {
//            self.images.append(contentsOf: images)
//            self.collectionView.reloadData()
//            for image in images{
//                let fileName=String.uniqueFilename(withPrefix: "iamgeData")+".json"
//                if let json = imageData(instData: (image.resizedTo1MB()!).pngData()!).json {
//                    if let url = try? FileManager.default.url(
//                        for: .documentDirectory,
//                        in: .userDomainMask,
//                        appropriateFor: nil,
//                        create: true
//                    ).appendingPathComponent(fileName){
//                        do {
//                            try json.write(to: url)
//                            print ("saved successfully")
//                            //MARK: is a data leak to be corrected
//                            //TODO: sometimes fileName added but not deleted
//                            self.viewLinkedTo?.card.mediaDataURLs.append(fileName)
//                            self.viewLinkedTo?.layoutSubviews()
//                        } catch let error {
//                            print ("couldn't save \(error)")
//                        }
//                    }
//                }
//            }
//        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("z")
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
}

extension WithImagesViewController{
    var navBarColour: UIColor{
        return UIColor(named: "myBackgroundColor") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
    var backgroundColor: UIColor{
        return UIColor(named: "myBackgroundColor") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
    var cellCornerRadius: CGFloat{
        return 8.0
    }
}
