//
//  PageViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 13/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import SPStorkController
import UserNotifications
import PencilKit

protocol pageProtocol {
    func changeContentSize(using newView: UIView)
    func resizeCard(for cardView: UIView)
    func showSmallCardInfoView(for cardView: SmallCardView)
    func showFullCardView(for cardView: cardView)
    func showCardEditView(for cardView: cardView)
    func getMeMedia(for cardView: MediaCardView)
    func showMedias(for cardView: MediaCardView)
    func updateCurrentTaskToNone()
    
    func addMeAsWantingToJoinConnectLines(for newView: UIView, with uid: UUID)
    func reloadAllLines(animated: Bool)
    func reloadLine(with uid: UUID, animated: Bool)
}

class PageViewController: UIViewController {
    var pageID: pageInfo?
    //WARNING: never use page.connecteviews as it is inconsistent with pageView.page.connectedviews which is correct one
    var page: PageData? {
        get{
            var retVal = PageData()
            retVal.pageWidth = Double(pageViewWidhtConstraint!.constant)
            retVal.pageHeight = Double(pageViewHeightConstraint!.constant)
            retVal.gridStyle = self.gridStyle
            if let dat = pageView.canvas?.drawing.dataRepresentation(){
                    retVal.drawingData = dat
            }
            pageView.subviews.forEach { (sv) in
                if let cv = sv as? SmallCardView{
                    retVal.smallCards.append(smallCardData(card: cv.card, frame: cv.frame, isHidden: cv.isHidden))
                }
                if let cv = sv as? cardView{
                    retVal.bigCards.append(bigCardData(card: cv.card, frame: cv.frame, isHidden: cv.isHidden))
                }
                //TODO: Gesture recognisers for mediacard not added automatically
                if let cv =  sv as? MediaCardView{
                    retVal.mediaCards.append(mediaCardData(card: cv.card, frame: cv.frame, isHidden: cv.isHidden))
                }
            }
            retVal.conntectedViews = pageView.page.conntectedViews
            print("gonna get page: PageData? ")
            return retVal
        }
        set{
            print("is now in set page: PageData?")
            pageView.subviews.forEach { (sv) in
                sv.removeFromSuperview()
            }
            if let newVal = newValue{
                pageViewWidhtConstraint?.constant = CGFloat(newVal.pageWidth)
                pageViewHeightConstraint?.constant = CGFloat(newVal.pageHeight)
                self.gridStyle=newVal.gridStyle
                self.updateMinZoomScale()
//                pageView.page=newVal
                pageView.setNeedsDisplay()//TODO: check if needed
                var d=PKDrawing()
                do {
                    try d = PKDrawing.init(data: newVal.drawingData)
                    pageView.canvas?.drawing = d
                } catch  {
                    print("Error loading drawing object")
                }
                newVal.bigCards.forEach({ (cardData) in
                    let nc = cardView(frame: cardData.frame)
                    nc.card=cardData.card
                    nc.pageDelegate=self
                    pageView.addSubview(nc)
                    nc.isHidden=cardData.isHidden
                })
                newVal.smallCards.forEach({ (cardData) in
                    let nc = SmallCardView(frame: cardData.frame)
                    nc.card=cardData.card
                    nc.pageDelegate=self
                    pageView.addSubview(nc)
                    nc.isHidden=cardData.isHidden
                })
                newVal.mediaCards.forEach({ (cardData) in
                    let nc = MediaCardView(frame: cardData.frame)
                    nc.card=cardData.card
                    nc.pageDelegate=self
                    pageView.addSubview(nc)
                    nc.isHidden=cardData.isHidden
                })
                pageView.setupViewListDict()
//                print("adding lines from \( newValue.conntectedViews)")
                pageView.page=newVal
                pageView.page.conntectedViews = doConnectingLInesDataCleanupAndSetupViewListDict(connectingViews: pageView.page.conntectedViews)
//                pageView.page.conntectedViews.forEach { (cvTupple) in
//                    self.addLines(from: cvTupple.first!, to: cvTupple.second!, animated: true)
//                }
                for (i,_) in  pageView.page.conntectedViews.enumerated().reversed() {
//                    a.removeAtIndex(i)
                    let cvTupple = pageView.page.conntectedViews[i]
                    if self.addLines(from: cvTupple.first!, to: cvTupple.second!, animated: true)==false{
                        print("removed a line not found")
                        pageView.page.conntectedViews.remove(at: i)
                    }
                }
                pageView.layoutSubviews()
            }else{
                print("got nil for newValue in set in PageData in PageViewController")
            }
            viewDidLoad()
        }
    }
    var gridStyle = PageData.gridValues.gridless{
        didSet{
            if ImageViews.count>6{
                switch self.gridStyle {
                case .horizontal:
                    ImageViews[5].image = UIImage(systemName: "rectangle.grid.1x2")
                case .vertical:
                    ImageViews[5].image = UIImage(systemName: "rectangle.split.3x1")
                case .cross:
                    ImageViews[5].image = UIImage(systemName: "rectangle.split.3x3")
                case .gridless:
                    ImageViews[5].image = UIImage(systemName: "rectangle.3.offgrid")
                }
            }
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
                iv.layer.cornerRadius=iv.bounds.width/2.0
                iv.layer.masksToBounds=true
            }
            ImageViews[5].layer.cornerRadius=0
        }
    }
    
    
    
    @objc func handleImageViewTap(_ sender: UITapGestureRecognizer){
        print("pageviewframe = \(pageView.frame)")
        print("pageviewbounds = \(pageView.bounds)")
        if let x = sender.view as? UIImageView{
            self.connectingViews.first=nil; self.connectingViews.second=nil
//            print("did select image at: \(ImageViews.firstIndex(of: x))")
            if x.tintColor == .systemTeal, [5, 6, 7 , 8, 9, 10].contains(ImageViews.firstIndex(of: x))==false {
                x.tintColor = .systemPink
            }else{
                x.tintColor = .systemTeal
            }
            pageView.subviews.forEach { (subv) in
                subv.subviews.forEach { (sv) in
                    sv.isUserInteractionEnabled=true
                }
            }
            switch ImageViews.firstIndex(of: x) {
            case 0:
                print("0")
                pageView.currentTask = .addSmallCard
            case 1:
                print("1")
                pageView.currentTask = .addCard
            case 2:
                print("2")
                switch pageView.currentTask {
                case .drawLines:
                    pageView.currentTask = .noneOfAbove
                default:
                    pageView.currentTask = .drawLines
                }
                pageView.setupDrawing()
            case 3:
                print("3")
                switch pageView.currentTask {
                case .connectViews:
                    pageView.currentTask = .noneOfAbove
                default:
                    pageView.currentTask = .connectViews
                    pageView.subviews.forEach { (subv) in
                        subv.subviews.forEach { (sv) in
                            sv.isUserInteractionEnabled=false
                        }
                    }
                }
            case 4:
                print("4")
                pageView.currentTask = .addMediaCard
            case 5:
                print("5")
                toggleGridStyle()
            case 6:
                print("6")
                pageView.currentTask = .noneOfAbove
                togglePageResize()
            case 7:
                print("7")
                self.changePageView(horizontalFactor: 0, verticalFactor: -1)
            case 8:
                print("8")
                self.changePageView(horizontalFactor: 0, verticalFactor: 1)
            case 9:
                print("9")
                self.changePageView(horizontalFactor: -1, verticalFactor: 0)
            case 10:
                print("10")
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
        dropZone.backgroundColor=UIColor(named: "smallCardColor") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
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
        if pageView.frame.size == .zero{
            scrollView.zoomScale=1
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
        if pageView.canvas==nil{
            pageView.canvas = PKCanvasView()
        }
        pageView.addSubview(pageView.canvas!)
        pageView.sendSubviewToBack(pageView.canvas!)
        pageView.canvas?.isUserInteractionEnabled=false
        pageView.canvas?.backgroundColor = pageColor
        pageView.canvas?.translatesAutoresizingMaskIntoConstraints=false
        [
            pageView.canvas?.leftAnchor.constraint(equalTo: pageView.leftAnchor),
            pageView.canvas?.rightAnchor.constraint(equalTo: pageView.rightAnchor),
            pageView.canvas?.topAnchor.constraint(equalTo: pageView.topAnchor),
            pageView.canvas?.bottomAnchor.constraint(equalTo: pageView.bottomAnchor)
            ].forEach { (cst) in
                cst?.isActive=true
        }
        if let window = UIApplication.shared.windows.last, let toolPicker = PKToolPicker.shared(for: window) {
            toolPicker.setVisible(true, forFirstResponder: pageView.canvas!)
            toolPicker.addObserver(pageView.canvas!)
            toolPicker.addObserver(self)
        }
        setGridLayer()
    }
    var pageViewHeightConstraint: NSLayoutConstraint?
    var pageViewWidhtConstraint: NSLayoutConstraint?
    func updateMinZoomScale(){
        print("in updateminzoomscale")
        var minZoom = min(self.view.bounds.size.width / pageViewWidhtConstraint!.constant, self.view.bounds.size.height / pageViewHeightConstraint!.constant);
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
//        print("is now saving page with cvs \(page?.conntectedViews)")
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
                } catch let error {
                    print ("couldn't save \(error)")
                }
            }
        }
    }
    func scrollToCard(with uniqueID: UUID){
        self.scrollView.zoomScale=1.0
        for sv in pageView.subviews{
            if let x = sv as? SmallCardView{
                if x.card.UniquIdentifier == uniqueID{
                    let point = CGPoint(x: max(0, x.frame.midX-view.bounds.width/2), y: max(0, x.frame.midY-view.bounds.height/2))
                    scrollView.setContentOffset(point, animated: true)
                    sv.isHidden=false
                    return
                }
            }
            if let x = sv as? cardView{
                if x.card.UniquIdentifier == uniqueID{
                    let point = CGPoint(x: max(0, x.frame.midX-view.bounds.width/2), y: max(0, x.frame.midY-view.bounds.height/2))
                    scrollView.setContentOffset(point, animated: true)
                    sv.isHidden=false
                    return
                }
            }
            if let x = sv as? MediaCardView{
                if x.card.UniquIdentifier == uniqueID{
                    let point = CGPoint(x: max(0, x.frame.midX-view.bounds.width/2), y: max(0, x.frame.midY-view.bounds.height/2))
                    scrollView.setContentOffset(point, animated: true)
                    sv.isHidden=false
                    return
                }
            }
        }
    }
    
    @IBOutlet var ivHeightConstraintLists: [NSLayoutConstraint]!
    
    @IBOutlet var ivTopConstraints: [NSLayoutConstraint]!
    
    
    func toggleToolBar(){
        if ivTopConstraints[0].constant==0{
            for ind in 0..<10{
                ivTopConstraints[ind].constant=CGFloat(50+50*ind)
            }
        }else{
            for ind in 0..<10{
                ivTopConstraints[ind].constant=CGFloat(0)
            }
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    func togglePageResize(){
        if ivTopConstraints[6].constant==ivTopConstraints[5].constant{
            for ind in 6..<10{
                ivTopConstraints[ind].constant=ivTopConstraints[5].constant+CGFloat(50*(ind-5))
            }
        }else{
            for ind in 6..<10{
                ivTopConstraints[ind].constant=ivTopConstraints[5].constant
            }
        }
        view.bringSubviewToFront(ImageViews[6])
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
//    var isGrid=false
    var gridShapeLayers = [CAShapeLayer]()
    func toggleGridStyle(){
        print("tgsyle")
         print("set from to \(self.gridStyle)")
        switch self.gridStyle {
        case .horizontal:
            self.gridStyle = .vertical
        case .vertical:
            self.gridStyle = .cross
        case .cross:
            self.gridStyle = .gridless
        case .gridless:
            self.gridStyle = .horizontal
        }
        print("set to \(self.gridStyle)")
        self.viewDidLoad()
    }
    func setGridLayer(){
         print("setting using \(self.gridStyle)")
        gridShapeLayers.forEach { (shlayer) in
            shlayer.removeFromSuperlayer()
        }
        let lineSpacing = CGFloat(250)
        let horSpacing = CGFloat(125)
        let stripes = UIBezierPath()
        var i=0
        switch self.gridStyle {
        case .horizontal:
            while( horSpacing*CGFloat(i)<=pageView.bounds.height){
                stripes.move(to: CGPoint(x: 0, y: horSpacing*CGFloat(i)) )
                stripes.addLine(to: CGPoint(x: pageView.bounds.width, y: horSpacing*CGFloat(i)) )
                i+=1
            }
        case .vertical:
            while( lineSpacing*CGFloat(i)<=pageView.bounds.width){
                stripes.move(to: CGPoint(x: lineSpacing*CGFloat(i), y: 0) )
                stripes.addLine(to: CGPoint(x: lineSpacing*CGFloat(i), y: pageView.bounds.height) )
                i+=1
            }
        case .cross:
            while( horSpacing*CGFloat(i)<=pageView.bounds.height){
                stripes.move(to: CGPoint(x: 0, y: horSpacing*CGFloat(i)) )
                stripes.addLine(to: CGPoint(x: pageView.bounds.width, y: horSpacing*CGFloat(i)) )
                i+=1
            }
            i=0
            while( lineSpacing*CGFloat(i)<=pageView.bounds.width){
                stripes.move(to: CGPoint(x: lineSpacing*CGFloat(i), y: 0) )
                stripes.addLine(to: CGPoint(x: lineSpacing*CGFloat(i), y: pageView.bounds.height) )
                i+=1
            }
        case .gridless:
            gridShapeLayers.forEach { (shlayer) in
                shlayer.removeFromSuperlayer()
            }
            return
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = stripes.cgPath
        shapeLayer.strokeColor = pageView.lineColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1
        gridShapeLayers.append(shapeLayer)
        pageView.layer.addSublayer(shapeLayer)
        pageView.subviews.forEach { (sv) in
            if sv != shapeLayer && sv != pageView.canvas{
                pageView.bringSubviewToFront(sv)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent(pageID!.fileName){
//            print("trying to extract contents of jsonData")
            if let jsonData = try? Data(contentsOf: url){
                if let extract = PageData(json: jsonData){
//                    print("did set page = extract i.e. \(extract) succesfully")
                    page = extract
//                    viewDidLoad()
                }else{
                    print("ERROR: found PageData(json: jsonData) to be nil so didn't set it")
                }
            }
        }
    }
    //variables for show big card edit view segue and //variables for show card checklist full view segue
    var bigCardViewLinkedTo: cardView?
    var bigCardForLinkedView = Card()
    
    //variables for show small card info view segue
    var smallCardViewLinkedTo: SmallCardView?
    var smallCardForLinkedView = SmallCard()
        
    //variables for connecting views
    var connectingViews = connectingViewTupple()
    var linesShapeLayers = [CAShapeLayer]()
    
    //MARK: Navigaion
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? newEditCardViewController{
            vc.viewLinkedTo=bigCardViewLinkedTo
            vc.card=self.bigCardForLinkedView
        }
        if let vc = segue.destination as? newSmallCardInfoViewController{
            vc.viewLinkedTo=smallCardViewLinkedTo
            vc.sCard=self.smallCardForLinkedView
        }
        if let vc = segue.destination as? newCheckListFullViewController{
            vc.viewLinkedTo=bigCardViewLinkedTo
            vc.card=self.bigCardForLinkedView
        }
    }
}
extension PageViewController{
    var basePageViewHeight: CGFloat{
        return UIScreen.main.bounds.height * 1.5
    }
    var basePageViewWidth: CGFloat{
        return UIScreen.main.bounds.width * 3.0
    }
    var widthToIncreaseOnHorizontalOutOfBonds: CGFloat{
        return 150
    }
    var HeightToIncreaseOnVerticalOutOfBonds: CGFloat{
        return 150
    }
    var pageColor: UIColor{
        return UIColor(named: "myBackgroundColor") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//        return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//        return #colorLiteral(red: 0.9411764706, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
    }
}
extension PageViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return pageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
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
    func addMeAsWantingToJoinConnectLines(for newView: UIView, with uid: UUID) {
        print("inside addMeAsWantingToJoinConnectLines")
        if pageView.currentTask != .connectViews{
            return
        }
        if connectingViews.first==nil{
            connectingViews.first = uid
            pageView.setupViewListDict()
        }else if connectingViews.first != uid{
            connectingViews.second = uid
//            var shouldReturn = false
//            var duplicatValue = connectingViewTupple()
//            pageView.page.conntectedViews.forEach({ (cvt) in
//                if cvt.first==connectingViews.first && cvt.second==connectingViews.second{
//                    print("found same so returning")
//                    self.connectingViews.first=nil; self.connectingViews.second=nil
//                    shouldReturn=true
//                    duplicatValue=cvt
//                }
//                if cvt.first==connectingViews.second && cvt.second==connectingViews.first{
//                    print("found same so returning")
//                    self.connectingViews.first=nil; self.connectingViews.second=nil
//                    shouldReturn=true
//                    duplicatValue=cvt
//                }
//            })
            for (i,_) in pageView.page.conntectedViews.enumerated().reversed(){
                let cvt =  pageView.page.conntectedViews[i]
                if cvt.first==connectingViews.first && cvt.second==connectingViews.second{
                    print("found same so returning")
                    self.connectingViews.first=nil; self.connectingViews.second=nil
                    pageView.page.conntectedViews.remove(at: i)
//                    self.reloadLine(with: cvt.first!, animated: false)
//                    self.reloadLine(with: cvt.second!, animated: false)
                    self.reloadAllLines(animated: false)
                    return
                }
                if cvt.first==connectingViews.second && cvt.second==connectingViews.first{
                    print("found same so returning")
                    self.connectingViews.first=nil; self.connectingViews.second=nil
                    pageView.page.conntectedViews.remove(at: i)
//                    self.reloadLine(with: cvt.first!, animated: false)
//                    self.reloadLine(with: cvt.second!, animated: false)
                    self.reloadAllLines(animated: false)
                    return
                }
            }
            print("going to add")
            self.addLines(from: connectingViews.first!, to: connectingViews.second!, animated: true)
            pageView.page.conntectedViews.append(self.connectingViews)
            print("new cv = \(pageView.page.conntectedViews)")
            self.connectingViews.first=nil; self.connectingViews.second=nil
        }
    }
    func doConnectingLInesDataCleanupAndSetupViewListDict(connectingViews: [connectingViewTupple]) -> [connectingViewTupple]{
        pageView.setupViewListDict()
        return connectingViews.filter { (cvt) -> Bool in
            return (self.pageView.viewListDictionary.keys.contains(cvt.first!) || self.pageView.viewListDictionary.keys.contains(cvt.second!))
        }
    }
    //Returns false on failure if vies is deleted i.e. not in view
    func addLines(from firstID: UUID, to secondId: UUID, animated: Bool) -> Bool{
//        // remove old shape layer if any
//        self.shapeLayer?.removeFromSuperlayer()
        // create whatever path you want

        //TODO: make this work, probably something like this being calles somewhere elser
        let path = UIBezierPath()
        if pageView.viewListDictionary[firstID]==nil{
            return false
        }
        let first = pageView.viewListDictionary[firstID]!
        path.move(to: CGPoint(x: first.frame.midX, y: first.frame.midY))
        
        if pageView.viewListDictionary[secondId]==nil{
            return false
        }
        let second = pageView.viewListDictionary[secondId]!
        path.addLine(to: CGPoint(x: second.frame.midX, y: second.frame.midY))

        // create shape layer for that path

        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = UIColor.systemTeal.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.path = path.cgPath

        // animate it

//        pageView.layer.addSublayer(shapeLayer)
        pageView.layer.insertSublayer(shapeLayer, at: 1)
        pageView.bringSubviewToFront(first)
        pageView.bringSubviewToFront(second)
        if animated{
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.duration = 0.4
            shapeLayer.add(animation, forKey: "MyAnimation")
        }

        // save shape layer

        self.linesShapeLayers.append(shapeLayer)
        return true
    }
    
    func reloadAllLines(animated: Bool){
        self.linesShapeLayers.forEach { (lineLayer) in
            lineLayer.removeFromSuperlayer()
        }
        pageView.setupViewListDict()
        pageView.page.conntectedViews.forEach { (cvTupple) in
            addLines(from: cvTupple.first!, to: cvTupple.second!, animated: animated)
        }
    }
    func reloadLine(with uid: UUID, animated: Bool){
        for ind in pageView.page.conntectedViews.indices{
            if pageView.page.conntectedViews[ind].first == uid || pageView.page.conntectedViews[ind].second==uid{
                self.linesShapeLayers[ind].removeFromSuperlayer()
                let path = UIBezierPath()
                let first = pageView.viewListDictionary[pageView.page.conntectedViews[ind].first!]!
                path.move(to: CGPoint(x: first.frame.midX, y: first.frame.midY))
                let second = pageView.viewListDictionary[pageView.page.conntectedViews[ind].second!]!
                path.addLine(to: CGPoint(x: second.frame.midX, y: second.frame.midY))
                
                // create shape layer for that path
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
                shapeLayer.strokeColor = UIColor.systemTeal.cgColor
                shapeLayer.lineWidth = 2
                shapeLayer.path = path.cgPath
                
                // animate it
                pageView.layer.insertSublayer(shapeLayer, at: 1)
                pageView.bringSubviewToFront(first)
                pageView.bringSubviewToFront(second)
                if animated{
                    let animation = CABasicAnimation(keyPath: "strokeEnd")
                    animation.fromValue = 0
                    animation.duration = 0.4
                    shapeLayer.add(animation, forKey: "MyAnimation")
                }
                
                // save shape layer
                self.linesShapeLayers[ind]=shapeLayer
            }
        }
    }
    
    func updateCurrentTaskToNone() {
        ImageViews.forEach { (iv) in
            iv.tintColor = .systemTeal
        }
    }
    
    
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
//        if isGrid{
//            var origin = newView.frame.origin
//            let lineSpacing = CGFloat(250)
//            origin = CGPoint(x: lineSpacing*CGFloat(Int(origin.x/lineSpacing))+5, y: lineSpacing*CGFloat(Int(origin.y/lineSpacing))+5)
//            newView.frame=CGRect(origin: origin, size: newView.frame.size)
//        }
        var origin = newView.frame.origin
        let lineSpacing = CGFloat(250)
        let horSpacing = CGFloat(125)
        switch self.gridStyle {
        case .horizontal:
            origin = CGPoint(x: origin.x, y: horSpacing*CGFloat(Int(origin.y/horSpacing))+5)
        case .vertical:
            origin = CGPoint(x: lineSpacing*CGFloat(Int(origin.x/lineSpacing))+5, y: origin.y)
        case .cross:
            origin = CGPoint(x: lineSpacing*CGFloat(Int(origin.x/lineSpacing))+5, y: horSpacing*CGFloat(Int(origin.y/horSpacing))+5)
        case .gridless:
            return
        default:
            print("ERROR: unknown grid value")
        }
        newView.frame=CGRect(origin: origin, size: newView.frame.size)
    }
    
    func showCardEditView(for cardView: cardView) {
        print("inside showCardEditView")
//        let controller = EditCardViewController()
//        let transitionDelegate = SPStorkTransitioningDelegate()
//        transitionDelegate.customHeight = 500
//        transitionDelegate.showIndicator = true
//        transitionDelegate.indicatorColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        transitionDelegate.indicatorMode = .auto
//        transitionDelegate.hideIndicatorWhenScroll = true
//        transitionDelegate.showCloseButton = true
//        transitionDelegate.swipeToDismissEnabled = true
//        transitionDelegate.tapAroundToDismissEnabled = true
//        controller.transitioningDelegate = transitionDelegate
//        controller.modalPresentationStyle = .custom
//        controller.modalPresentationCapturesStatusBarAppearance = true
//        transitionDelegate.hapticMoments = [.willPresent, .willDismiss]
//        transitionDelegate.cornerRadius = 10
//        controller.card=cardView.card
//        controller.viewLinkedTo=cardView
//        self.present(controller, animated: true, completion: nil)
        self.bigCardViewLinkedTo=cardView
        self.bigCardForLinkedView=cardView.card
        performSegue(withIdentifier: "bigCardEditViewSegue", sender: self)
        
    }
    func showSmallCardInfoView(for cardView: SmallCardView) {
//        print("yet to implement showSmallCardInfoView")
//        let controller = SmallCardInfoViewController()
//        let transitionDelegate = SPStorkTransitioningDelegate()
//        transitionDelegate.customHeight = self.view.bounds.height * 0.85
//        transitionDelegate.showIndicator = true
//        transitionDelegate.indicatorColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        transitionDelegate.indicatorMode = .auto
//        transitionDelegate.hideIndicatorWhenScroll = true
//        transitionDelegate.showCloseButton = true
//        transitionDelegate.swipeToDismissEnabled = true
//        transitionDelegate.tapAroundToDismissEnabled = true
//        controller.transitioningDelegate = transitionDelegate
//        controller.modalPresentationStyle = .custom
//        controller.modalPresentationCapturesStatusBarAppearance = true
////        controller.smallcardDelegate=self
//        transitionDelegate.storkDelegate = controller
//        controller.sCard = cardView.card
//        controller.viewLinkedTo = cardView
//        transitionDelegate.hapticMoments = [.willPresent, .willDismiss]
//        transitionDelegate.cornerRadius = 10
//        self.present(controller, animated: true, completion: nil)
        //New verions
        self.smallCardViewLinkedTo=cardView
        self.smallCardForLinkedView=cardView.card
        performSegue(withIdentifier: "smallCardInfoViewSegue", sender: self)
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
//        let controller = checkListFullViewController()
//        let transitionDelegate = SPStorkTransitioningDelegate()
//        transitionDelegate.customHeight = 800
//        transitionDelegate.showIndicator = true
//        transitionDelegate.indicatorColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        transitionDelegate.indicatorMode = .auto
//        transitionDelegate.hideIndicatorWhenScroll = true
//        transitionDelegate.showCloseButton = true
//        transitionDelegate.swipeToDismissEnabled = false
//        transitionDelegate.tapAroundToDismissEnabled = true
//        controller.transitioningDelegate = transitionDelegate
//        controller.modalPresentationStyle = .custom
//        controller.modalPresentationCapturesStatusBarAppearance = true
//        transitionDelegate.hapticMoments = [.willPresent, .willDismiss]
//        transitionDelegate.cornerRadius = 10
//        transitionDelegate.storkDelegate = controller
//        controller.card=cardView.card
//        controller.viewLinkedTo=cardView
//        self.present(controller, animated: true, completion: nil)
        self.bigCardViewLinkedTo = cardView
        self.bigCardForLinkedView = cardView.card
        performSegue(withIdentifier: "showCardCheckLIstSegue", sender: self)
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
//                cardView.frame = CGRect.
                cardView.isHidden=true
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
        if pageView.currentTask == .connectViews{
            return
        }
        
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

extension PageViewController: PKToolPickerObserver{
    
}
