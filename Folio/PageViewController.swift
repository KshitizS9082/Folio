//
//  PageViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 13/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {
    var page=PageData()
    var isToolBarHidden=true
    
    @IBOutlet weak var dropZone: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var pageView = PageView()
    
    @IBOutlet var ImageViews: [UIImageView]!{
        didSet{
            ImageViews.forEach { (iv) in
                iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageViewTap)))
            }
        }
    }
    
    @objc func handleImageViewTap(_ sender: UITapGestureRecognizer){
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
    
    private func configureScollView(){
        scrollView.delegate=self
        scrollView.setZoomScale(1.0, animated: true)
        scrollView.minimumZoomScale = 0.3
        scrollView.maximumZoomScale = 4.0
        if scrollView.subviews.contains(pageView)==false{
            scrollView.addSubview(pageView)
        }
        pageView.translatesAutoresizingMaskIntoConstraints=false
        if pageView.frame.size == .zero{
            scrollView.zoomScale=1
            pageView.frame = CGRect(origin: CGPoint.zero, size: view.frame.size.applying(CGAffineTransform(scaleX: 1.75, y: 1.5)))
        }
        scrollView.contentSize = pageView.frame.size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScollView()
        updateMinZoomScale()
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
