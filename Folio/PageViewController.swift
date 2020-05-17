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
}

class PageViewController: UIViewController {
    var page=PageData()
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
        print("scrollviewframe = \(scrollView.frame)")
        print("does contain = \(scrollView.subviews.contains(pageView))")
        if let x = sender.view as? UIImageView{
            print("did select image at: \(ImageViews.firstIndex(of: x))")
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
            case 3:
                print("3")
                pageView.currentTask = .delete
            case 4:
                print("4")
                pageView.currentTask = .addMediaCard
            case 5:
                print("5")
                pageView.currentTask = .connectViews
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
        if pageView.frame.size == .zero{
            scrollView.zoomScale=1
            pageView.frame = CGRect(origin: CGPoint.zero, size: view.frame.size.applying(CGAffineTransform(scaleX: 1.75, y: 1.5)))
        }
        scrollView.contentSize = pageView.frame.size
    }
    func updateMinZoomScale(){
        var minZoom = min(self.view.bounds.size.width / pageView.bounds.size.width, self.view.bounds.size.height / pageView.bounds.size.height);
        if (minZoom > 1.0) {
            minZoom = 1.0;
        }
        scrollView.minimumZoomScale = minZoom;
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
    func showFullCardView(for cardView: cardView) {
        print("inside showFullCardView")
    }
    
    func showCardEditView(for cardView: cardView) {
         print("inside showCardEditView")
        
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
    
    func changeContentSize(using newView: UIView) {
        print("yet to implement changeContentSize")
    }
    
    
}
