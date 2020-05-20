//
//  PageViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 13/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import SPStorkController
protocol pageProtocol {
    func changeContentSize(using newView: UIView)
    func resizeCard(for cardView: UIView)
    func showSmallCardInfoView(for cardView: SmallCardView)
    func showFullCardView(for cardView: cardView)
    func showCardEditView(for cardView: cardView)
    func getMeMedia(for cardView: MediaCardView)
    func showMedias(for cardView: MediaCardView)
}

class PageViewController: UIViewController {
    var pageID: pageInfo?
    var page: PageData? {
        get{
            var retVal = PageData()
            retVal.pageWidth = Double(pageViewWidhtConstraint!.constant)
            retVal.pageHeight = Double(pageViewHeightConstraint!.constant)
            pageView.subviews.forEach { (sv) in
                if let cv = sv as? SmallCardView{
                    retVal.smallCards.append(smallCardData(card: cv.card, frame: cv.frame))
                }
                if let cv = sv as? cardView{
                    retVal.bigCards.append(bigCardData(card: cv.card, frame: cv.frame))
                }
                //TODO: Gesture recognisers for mediacard not added automatically
                if let cv =  sv as? MediaCardView{
                    retVal.mediaCards.append(mediaCardData(card: cv.card, frame: cv.frame))
                }
            }
            print("gonna get page: PageData? ")
            return retVal
        }
        set{
            print("is now in set page: PageData?")
            pageView.subviews.forEach { (sv) in
                sv.removeFromSuperview()
            }
            if let newValue = newValue{
                pageViewWidhtConstraint?.constant = CGFloat(newValue.pageWidth)
                pageViewHeightConstraint?.constant = CGFloat(newValue.pageHeight)
                self.updateMinZoomScale()
                pageView.setNeedsDisplay()//TODO: check if needed
                newValue.bigCards.forEach({ (cardData) in
                    let nc = cardView(frame: cardData.frame)
                    nc.card=cardData.card
                    nc.pageDelegate=self
                    pageView.addSubview(nc)
                    
                })
                newValue.smallCards.forEach({ (cardData) in
                    let nc = SmallCardView(frame: cardData.frame)
                    nc.card=cardData.card
                    nc.pageDelegate=self
                    pageView.addSubview(nc)
                })
                newValue.mediaCards.forEach({ (cardData) in
                    let nc = MediaCardView(frame: cardData.frame)
                    nc.card=cardData.card
                    nc.pageDelegate=self
                    pageView.addSubview(nc)
                })
                pageView.layoutSubviews()
            }else{
                print("got nil for newValue in set in PageData in PageViewController")
            }
            viewDidLoad()
        }
    }
    var isToolBarHidden=true
    
    var dropZone: UIView = UIView()
    var scrollView = UIScrollView()
    var pageView = PageView()
    
    @IBOutlet var ImageViews: [UIImageView]!{
        didSet{
            ImageViews.forEach { (iv) in
                iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageViewTap)))
                let dragInteraction = UIDragInteraction(delegate: self)
                dragInteraction.isEnabled=true
                iv.addInteraction(dragInteraction)
            }
        }
    }
    
    @objc func handleImageViewTap(_ sender: UITapGestureRecognizer){
        print("pageviewframe = \(pageView.frame)")
        print("pageviewbounds = \(pageView.bounds)")
        if let x = sender.view as? UIImageView{
//            print("did select image at: \(ImageViews.firstIndex(of: x))")
            switch ImageViews.firstIndex(of: x) {
            case 0:
                print("0")
                pageView.currentTask = .addSmallCard
            case 1:
                print("1")
                pageView.currentTask = .addCard
            case 2:
                print("2")
                pageView.currentTask = .drawLines
                //MARK: to be removed as used for testing
                print("\(String(describing: page))")
            case 3:
                print("3")
                pageView.currentTask = .delete
            case 4:
                print("4")
                pageView.currentTask = .addMediaCard
            case 5:
                print("5")
                pageView.currentTask = .connectViews
            case 6:
                print("6")
                self.changePageView(horizontalFactor: 0, verticalFactor: -1)
            case 7:
                print("7")
                self.changePageView(horizontalFactor: 0, verticalFactor: 1)
            case 8:
                print("8")
                self.changePageView(horizontalFactor: -1, verticalFactor: 0)
            case 9:
                print("9")
                self.changePageView(horizontalFactor: 1, verticalFactor: 0)
            default:
                print("unexpected index")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBaseViews()
        view.sendSubviewToBack(dropZone)
        updateMinZoomScale()
    }
    private func configureBaseViews(){
        if view.subviews.contains(dropZone)==false{
            view.addSubview(dropZone)
        }
        dropZone.translatesAutoresizingMaskIntoConstraints=false
        dropZone.backgroundColor=#colorLiteral(red: 0.7836764455, green: 0.7836764455, blue: 0.7836764455, alpha: 1)
        [
            dropZone.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dropZone.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            dropZone.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            dropZone.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            ].forEach { (cst) in
                cst.isActive=true
        }
        dropZone.addInteraction(UIDropInteraction(delegate: self))
        
        if dropZone.subviews.contains(scrollView)==false{
            dropZone.addSubview(scrollView)
            scrollView.setZoomScale(1.0, animated: true)
        }
        scrollView.translatesAutoresizingMaskIntoConstraints=false
        [
            scrollView.topAnchor.constraint(equalTo: dropZone.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: dropZone.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: dropZone.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: dropZone.rightAnchor)
            ].forEach { (cst) in
                cst.isActive=true
        }
        scrollView.isPagingEnabled = false
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 4.0
        
        scrollView.backgroundColor=#colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 0)
        scrollView.delegate = self
        scrollView.delaysContentTouches=false
        if scrollView.subviews.contains(pageView)==false{
            scrollView.addSubview(pageView)
        }
        pageView.pageDelegate=self
        pageView.myViewController=self
        //TODO: handle dimensions and zoom properly
        print("gonna set frame size for pageview which currently is \(pageView.frame.size)")
        if pageView.frame.size == .zero{
            scrollView.zoomScale=1
//            pageView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: basePageViewWidth, height: basePageViewHeight))
        }
        pageView.translatesAutoresizingMaskIntoConstraints=false
        if pageViewWidhtConstraint==nil{
            pageViewWidhtConstraint = pageView.widthAnchor.constraint(equalToConstant: basePageViewWidth)
        }
        if pageViewHeightConstraint==nil{
            pageViewHeightConstraint = pageView.heightAnchor.constraint(equalToConstant: basePageViewHeight)
        }
        pageViewWidhtConstraint?.isActive=true
        pageViewHeightConstraint?.isActive=true
//        pageView.translatesAutoresizingMaskIntoConstraints=false
        scrollView.contentSize = pageView.frame.size
    }
    var pageViewHeightConstraint: NSLayoutConstraint?
    var pageViewWidhtConstraint: NSLayoutConstraint?
    func updateMinZoomScale(){
        var minZoom = min(self.view.bounds.size.width / pageView.bounds.size.width, self.view.bounds.size.height / pageView.bounds.size.height);
        if (minZoom > 1.0) {
            minZoom = 1.0;
        }
        scrollView.minimumZoomScale = minZoom;
    }
    func changePageView(horizontalFactor x: CGFloat, verticalFactor y: CGFloat){
        print("old pageView frame = \(pageView.frame)")
        pageViewWidhtConstraint?.constant = max( basePageViewWidth, pageViewWidhtConstraint!.constant+x*widthToIncreaseOnHorizontalOutOfBonds)
        pageViewHeightConstraint?.constant = max(basePageViewHeight ,pageViewHeightConstraint!.constant+y*HeightToIncreaseOnVerticalOutOfBonds)
        pageView.setNeedsDisplay(); pageView.setNeedsLayout()
        print("new pageView frame = \(pageView.frame)")
        updateMinZoomScale()
    }
    
    func save() {
        if let json = page?.json {
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(pageID!.fileName){
                do {
                    try json.write(to: url)
                    print ("saved successfully")
                    //                    let str = String(data: json, encoding: .utf8)
                    //                    print("jsondata = \(str)")
                } catch let error {
                    print ("couldn't save \(error)")
                }
            }
        }
    }
    func scrollToCard(with uniqueID: UUID){
        for sv in pageView.subviews{
            if let x = sv as? SmallCardView{
                if x.card.UniquIdentifier == uniqueID{
                    let point = CGPoint(x: max(0, x.frame.midX-view.bounds.width/2), y: max(0, x.frame.midY-view.bounds.height/2))
                    scrollView.setContentOffset(point, animated: true)
                }
            }
            if let x = sv as? cardView{
                if x.card.UniquIdentifier == uniqueID{
                    let point = CGPoint(x: max(0, x.frame.midX-view.bounds.width/2), y: max(0, x.frame.midY-view.bounds.height/2))
                    scrollView.setContentOffset(point, animated: true)
                }
            }
            if let x = sv as? MediaCardView{
                if x.card.UniquIdentifier == uniqueID{
                    let point = CGPoint(x: max(0, x.frame.midX-view.bounds.width/2), y: max(0, x.frame.midY-view.bounds.height/2))
                    scrollView.setContentOffset(point, animated: true)
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("inside viewwill appear")
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent(pageID!.fileName){
            print("trying to extract contents of jsonData")
            if let jsonData = try? Data(contentsOf: url){
                if let extract = PageData(json: jsonData){
                    print("did set page = extract i.e. \(extract) succesfully")
                    page = extract
//                    viewDidLoad()
                }else{
                    print("ERROR: found PageData(json: jsonData) to be nil so didn't set it")
                }
            }
        }
    }

}
extension PageViewController{
    var basePageViewHeight: CGFloat{
//        return self.view.frame.height * 1.75
        return UIScreen.main.bounds.height * 1.5
    }
    var basePageViewWidth: CGFloat{
        return UIScreen.main.bounds.width * 1.5
//        return self.view.frame.width * 1.5
    }
    var widthToIncreaseOnHorizontalOutOfBonds: CGFloat{
        return 150
    }
    var HeightToIncreaseOnVerticalOutOfBonds: CGFloat{
        return 150
    }
}
extension PageViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return pageView
    }
}
extension PageViewController: UIDropInteractionDelegate{
    
}
extension PageViewController: UIDragInteractionDelegate{
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        var item = "bakaluka string"
                if let imgview = interaction.view as! UIImageView?{
                    switch imgview.frame {
                    case ImageViews[0].frame:
                        item = "Small Card"
                    case ImageViews[1].frame:
                        item = "Big Card"
                    case ImageViews[4].frame:
                        item = "Media Card"
                    default:
                        print("couldn't identify type of drag interaction card")
                    }
                }
                let dragItem = UIDragItem(itemProvider: NSItemProvider(object: item as String as NSItemProviderWriting))
                dragItem.localObject = item
                return [dragItem]
    }
    
    
}
extension PageViewController: pageProtocol{
    
    func resizeCard(for cardView: UIView){
        var maxy = CGFloat(0)
        cardView.subviews.forEach { (sv) in
            maxy = max(maxy, sv.frame.maxY )
        }
        print("maxy = \(maxy), cardView.frame.maxY = \(cardView.frame.maxY)")
        if (maxy>cardView.bounds.maxY-6) || (maxy < cardView.bounds.maxY-6) {
            cardView.frame = CGRect(origin: cardView.frame.origin, size: CGSize(width: cardView.frame.width, height: maxy+6.0))
        }
    }
    func changeContentSize(using newView: UIView) {
        print("yet to implement changeContentSize")
//        if(newView.frame.maxX >= pageView.bounds.maxX){
//            print("x crossed")
//            pageView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: pageView.frame.width+widthToIncreaseOnHorizontalOutOfBonds, height: pageView.frame.height))
//        }
//        if(newView.frame.maxY >= pageView.bounds.maxY){
//            print("y crossed")
//            print("(newView.frame.maxY, self.frame.maxY \(newView.frame.maxY), \(pageView.frame.maxY)")
//            pageView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: pageView.frame.width, height:  pageView.frame.height+HeightToIncreaseOnVerticalOutOfBonds))
//        }
//        updateMinZoomScale()
    }
    
    func showCardEditView(for cardView: cardView) {
        print("inside showCardEditView")
        let controller = EditCardViewController()
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = 500
        transitionDelegate.showIndicator = true
        transitionDelegate.indicatorColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        transitionDelegate.indicatorMode = .auto
        transitionDelegate.hideIndicatorWhenScroll = true
        transitionDelegate.showCloseButton = true
        transitionDelegate.swipeToDismissEnabled = true
        transitionDelegate.tapAroundToDismissEnabled = true
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
        transitionDelegate.hapticMoments = [.willPresent, .willDismiss]
        transitionDelegate.cornerRadius = 10
        controller.card=cardView.card
        controller.viewLinkedTo=cardView
        self.present(controller, animated: true, completion: nil)
        
    }
    func showSmallCardInfoView(for cardView: SmallCardView) {
        print("yet to implement showSmallCardInfoView")
        let controller = SmallCardInfoViewController()
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = self.view.bounds.height * 0.85
        transitionDelegate.showIndicator = true
        transitionDelegate.indicatorColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        transitionDelegate.indicatorMode = .auto
        transitionDelegate.hideIndicatorWhenScroll = true
        transitionDelegate.showCloseButton = true
        transitionDelegate.swipeToDismissEnabled = true
        transitionDelegate.tapAroundToDismissEnabled = true
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
//        controller.smallcardDelegate=self
        transitionDelegate.storkDelegate = controller
        controller.sCard = cardView.card
        controller.viewLinkedTo = cardView
        transitionDelegate.hapticMoments = [.willPresent, .willDismiss]
        transitionDelegate.cornerRadius = 10
        self.present(controller, animated: true, completion: nil)
    }
    
    func showFullCardView(for cardView: cardView) {
        print("inside showFullCardView")
        switch cardView.card.type {
        case .CheckList:
            print("Checklist")
            showFullCheckListView(for: cardView)
        case .Notes:
            print("notes")
            showFullNotesView(for: cardView)
        case .Drawing:
            print("Drawing")
            showFullDrawingView(for: cardView)
        }
        cardView.layoutSubviews()//Check if required
    }
    private func showFullDrawingView(for cardView: cardView){
        let controller = drawingCardFullViewController()
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = 800
        transitionDelegate.showIndicator = true
        transitionDelegate.indicatorColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        transitionDelegate.indicatorMode = .auto
        transitionDelegate.hideIndicatorWhenScroll = true
        transitionDelegate.showCloseButton = true
        transitionDelegate.swipeToDismissEnabled = false
        transitionDelegate.tapAroundToDismissEnabled = true
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
        transitionDelegate.hapticMoments = [.willPresent, .willDismiss]
        transitionDelegate.cornerRadius = 10
        transitionDelegate.storkDelegate = controller
        controller.card=cardView.card
        controller.isEditing = true
        controller.viewLinkedTo=cardView
        self.present(controller, animated: true, completion: nil)
    }
    private func showFullNotesView(for cardView: cardView){
        let controller = NotesFullViewController()
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = self.view.bounds.height * 0.7
        transitionDelegate.showIndicator = true
        transitionDelegate.indicatorColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        transitionDelegate.indicatorMode = .auto
        transitionDelegate.hideIndicatorWhenScroll = true
        transitionDelegate.showCloseButton = true
        transitionDelegate.swipeToDismissEnabled = false
        transitionDelegate.tapAroundToDismissEnabled = true
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
        transitionDelegate.hapticMoments = [.willPresent, .willDismiss]
        transitionDelegate.cornerRadius = 10
        transitionDelegate.storkDelegate = controller
        controller.card=cardView.card
        controller.viewLinkedTo=cardView
        self.present(controller, animated: true, completion: nil)
    }
    private func showFullCheckListView(for cardView: cardView){
        let controller = checkListFullViewController()
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = 800
        transitionDelegate.showIndicator = true
        transitionDelegate.indicatorColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        transitionDelegate.indicatorMode = .auto
        transitionDelegate.hideIndicatorWhenScroll = true
        transitionDelegate.showCloseButton = true
        transitionDelegate.swipeToDismissEnabled = false
        transitionDelegate.tapAroundToDismissEnabled = true
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
        transitionDelegate.hapticMoments = [.willPresent, .willDismiss]
        transitionDelegate.cornerRadius = 10
        transitionDelegate.storkDelegate = controller
        controller.card=cardView.card
        controller.viewLinkedTo=cardView
        self.present(controller, animated: true, completion: nil)
    }
    
    func getMeMedia(for cardView: MediaCardView) {
        ImagePickerManager().pickImage(self){ image, shouldDelete, shouldDeleteFromPage, resizeView in
            print("should delete = \(shouldDelete)")
            if let img = image{
                //MARK: media dat to img conversion
//                cardView.card.mediaData.append(img.pngData()!)
//                print("did append image to newView.card.mediaData")
                //MARK: set a new json and use corrosponding url for new image
                let fileName=String.uniqueFilename(withPrefix: "iamgeData")+".json"
//                if let json = imageData(instData: img.pngData()!).json {
                //TODO: currently reduces data size of image for efficiency, donot do that
//                if let json = imageData(instData: img.jpeg(.lowest)!).json {
                DispatchQueue.global(qos: .background).async {
                    if let json = imageData(instData: (img.resizedTo1MB()!).pngData()!).json {
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
                                cardView.card.mediaDataURLs.append(fileName)
                            } catch let error {
                                print ("couldn't save \(error)")
                            }
                        }
                    }
                    DispatchQueue.main.sync {
                        cardView.layoutSubviews()
                    }
                }
            }
            if shouldDeleteFromPage{
                cardView.frame = CGRect.zero
            }
            if shouldDelete{
                cardView.deleteMe()
//                cardView.removeFromSuperview()
            }
            if resizeView{
                cardView.startResizing()
            }
        }
        print("WARNING: COULDN'T inserted image in pagedata")
    }
    //TODO: optimise as animation very laggy for now
    func showMedias(for cardView: MediaCardView) {
        print("yet to implement show medias")
        var images = [UIImage]()
//        for dat in cardView.card.mediaData{
//             //MARK: media dat to img conversion
//            if let im = UIImage(data: dat){
//                images.append(im)
//            }
//        }
         //MARK: URL based implementation for getting image
        for fileName in cardView.card.mediaDataURLs{
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(fileName){
                if let jsonData = try? Data(contentsOf: url){
                    print("did retrieve jsondata")
                    if let extract = imageData(json: jsonData){
                        if let image = UIImage(data: extract.data){
                            print("did get UIImage from extrated data")
                            images.append(image)
                        }else{
                            print("couldn't get UIImage from extrated data, check if sure this file doesn't exist and if so delete it from array")
                        }
                    }
                }
            }
        }
        let vc = WithImagesViewController()
        vc.images=images
        vc.viewLinkedTo=cardView
        vc.myViewController=self
        //If want to have a fixed
        //presentAsStork(vc, height: view.bounds.height, showIndicator: true, showCloseButton: false, complection: nil)
        self.present(vc, animated: true, completion: nil)
        return
    }
}
