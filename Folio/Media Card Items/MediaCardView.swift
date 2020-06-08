//
//  MediaCardView.swift
//  card2
//
//  Created by Kshitiz Sharma on 05/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import PencilKit
//import CropViewController

//TODO: shadow not wroking properly until masked to bounds set to false, but in that case edge dist. b/w cards doesn't work properly
class MediaCardView: UIView {
    //    var UniquIdentifier: UUID?
    var card = MediaCard()
    var imageViews = [UIImageView]()
    
    override func layoutSubviews() {
        self.layer.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 0.269393706)
        self.layer.masksToBounds=true
        self.layer.cornerRadius=cornerRadius
        self.layer.shadowColor=shadowColor
        self.layer.shadowOpacity=1.0
        if isResizing{
            return
        }
        subviews.forEach { (sv) in
            sv.removeFromSuperview()
        }
        var dist = CGFloat(0)
        //        if imageViews.count != numberOfImagesToShow{
        self.subviews.forEach { (sv) in
            sv.removeFromSuperview()
        }
        self.imageViews.removeAll()
        for _ in 0..<numberOfImagesToShow{
            let view=UIImageView()
            //            view.image=image
            view.contentMode = .scaleAspectFill
            //TODO: if set to false shadows would appear but proper edge distance b/w subviews won't be maintained
            view.layer.masksToBounds=true
            view.layer.shadowColor=shadowColor
            view.layer.shadowOpacity=1.0
            //TODO: see if below line for caching causes a problem in resizing if not set it
            //                view.layer.shouldRasterize=true
            view.layer.shadowRadius = shadowRadius
            view.translatesAutoresizingMaskIntoConstraints=false
            addSubview(view)
            [
                view.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: +dist),
                view.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -dist),
                view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: +dist),
                view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -dist)
                ].forEach { (cst) in
                    cst.isActive=true
            }
                        view.isHidden=true
            imageViews.append(view)
            view.addSubview(UIActivityIndicatorView())
            dist+=distanceOfEachNewImageFromPreviousImage
        }
        //        }
        //MARK: URL based implementation for getting image
//        }
        var x = Data()
        let st=max(0,card.mediaDataURLs.count-numberOfImagesToShow)
        let end=card.mediaDataURLs.count
        for ind in st..<end{
            DispatchQueue.global(qos: .background).async {
//                print("tryihg to retrieve jsondata from url: \(self.card.mediaDataURLs[ind])")
                if let url = try? FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                ).appendingPathComponent(self.card.mediaDataURLs[ind]){
                    if let jsonData = try? Data(contentsOf: url){
//                        print("did retrieve jsondata")
                        if let extract = imageData(json: jsonData){
                            //DO NOT CHANGE TO LET CAUSES PROBLEM IN NEXT ITERATION
                            x=extract.data
//                            print("checking if element a image: json ver")
                            if let image = UIImage(data: x){
                                //            if let image = x as? UIImage{
//                                print("found a image and setting at iv \(ind-st) from imvcnt \(subviews.count)")
                                DispatchQueue.main.async {
                                    self.imageViews[ind-st].image=image
                                    self.imageViews[ind-st].backgroundColor = #colorLiteral(red: 0.3667180918, green: 0.6686031065, blue: 0.1868030611, alpha: 0.4038567342)
                                    self.imageViews[ind-st].isHidden=false
                                }
                            }
                        }else{
                            print("couldnt get json from URL")
                        }
                    }
                }
            }
        }
        
        subviews.forEach { (sv) in
            sv.layer.cornerRadius=cornerRadius
        }
        self.isUserInteractionEnabled=true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPreview)))
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongPressMediaView)))
    }
    //MARK: set a new json and use corrosponding url for new image
    @objc func showPreview(){
        print("inside showfrepview")
        pageDelegate?.showMedias(for: self)
    }
    @objc func didLongPressMediaView(sender: UIGestureRecognizer){
        pageDelegate?.getMeMedia(for: self)
    }
    func deleteMe(){
        let fileManager = FileManager.default
            for fileName in self.card.mediaDataURLs{
                if let url = try? FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                ).appendingPathComponent(fileName){
                    do{
                        try fileManager.removeItem(at: url)
                        print("deleted item \(url) succefully")
                    } catch{
                        print("ERROR: item  at \(url) couldn't be deleted")
                    }
                }
            }
        self.removeFromSuperview()
    }
    //Make view resizable
    var isResizing = false
    var pageDelegate: pageProtocol?
    enum Edge {
        case topLeft, topRight, bottomLeft, bottomRight, bottom, top, left, right, none
    }
    static var edgeSize: CGFloat = 20.0
    var currentEdge: Edge = .none
    var touchStart = CGPoint.zero
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("found touch")
        pageDelegate?.addMeAsWantingToJoinConnectLines(for: self, with: self.card.UniquIdentifier)
        if isResizing{
            if let touch = touches.first {
                
                touchStart = touch.location(in: self)
                
                currentEdge = {
                    if self.bounds.size.width - touchStart.x < Self.edgeSize && self.bounds.size.height - touchStart.y < Self.edgeSize {
                        return .bottomRight
                    } else if touchStart.x < Self.edgeSize && touchStart.y < Self.edgeSize {
                        return .topLeft
                    } else if self.bounds.size.width-touchStart.x < Self.edgeSize && touchStart.y < Self.edgeSize {
                        return .topRight
                    } else if touchStart.x < Self.edgeSize && self.bounds.size.height - touchStart.y < Self.edgeSize {
                        return .bottomLeft
                    }else if self.bounds.size.height - touchStart.y < Self.edgeSize{
                        return .bottom
                    }else if touchStart.y < Self.edgeSize {
                        return .top
                    }else if self.bounds.size.width-touchStart.x < Self.edgeSize{
                        return .right
                    } else if touchStart.x < Self.edgeSize {
                        return .left
                    }
                    return .none
                }()
            }
            if let page = superview as? PageView{
                page.bringSubviewToFront(self)
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isResizing{
            if let touch = touches.first {
                let currentPoint = touch.location(in: self)
                let previous = touch.previousLocation(in: self)
                
                let originX = self.frame.origin.x
                let originY = self.frame.origin.y
                let width = self.frame.size.width
                let height = self.frame.size.height
                
                let deltaWidth = currentPoint.x - previous.x
                let deltaHeight = currentPoint.y - previous.y
                
                switch currentEdge {
                case .topLeft:
                    self.frame = CGRect(x: originX + deltaWidth, y: originY + deltaHeight, width: width - deltaWidth, height: height - deltaHeight)
                case .topRight:
                    self.frame = CGRect(x: originX, y: originY + deltaHeight, width: width + deltaWidth, height: height - deltaHeight)
                case .bottomRight:
                    self.frame = CGRect(x: originX, y: originY, width: width + deltaWidth, height: height + deltaWidth)
                case .bottomLeft:
                    self.frame = CGRect(x: originX + deltaWidth, y: originY, width: width - deltaWidth, height: height + deltaHeight)
                case .bottom:
                    self.frame = CGRect(x: originX, y: originY, width: width, height: height + deltaHeight)
                case .top:
                    self.frame = CGRect(x: originX, y: originY+deltaHeight, width: width, height: height - deltaHeight)
                case .left:
                    self.frame = CGRect(x: originX+deltaWidth, y: originY, width: width-deltaWidth, height: height)
                case .right:
                    self.frame = CGRect(x: originX, y: originY, width: width+deltaWidth, height: height)
                default:
                    // Moving
                    self.frame = CGRect(x: originX+deltaWidth, y: originY+deltaHeight, width: width, height: height)
                }
            }
//            //used to redraw connecting lines if either view is moved
//            if let page = superview as? PageView{
//                page.setNeedsDisplay()
//            }
            pageDelegate?.reloadLine(with: self.card.UniquIdentifier, animated: false)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isResizing{
            print("ended")
            self.gestureRecognizers?.forEach({ (gst) in
                gst.isEnabled=true
            })
            if let scrollView = superview?.superview as? UIScrollView {
                // if we are in a scroll view, disable its recognizers
                // so that ours will get the touch events instead
                scrollView.panGestureRecognizer.isEnabled = true
                scrollView.pinchGestureRecognizer?.isEnabled = true
            }
            isResizing=false
            
            //                   if frame.width < minWidth{
            //                       self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: minwidth, height: self.frame.height)
            //                   }
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: max(minWidth, self.frame.width), height: max(minWidth, self.frame.width))
            self.subviews.forEach { (sv) in
                sv.isHidden = false
                sv.isUserInteractionEnabled = true
            }
            
            //Place card allign properly to near by subviewß
            if let pagev = superview as? PageView{
                for sv in pagev.subviews{
                    if sv.frame==self.frame{
                        continue
                    }
                    if let _ = sv as? PKCanvasView{
                        continue
                    }
                    if self.frame.intersects(sv.frame){
                        if abs(self.frame.midX-sv.frame.midX) < abs(self.frame.midY-sv.frame.midY){
                            if self.frame.midY<sv.frame.midY{
                                self.frame.origin = CGPoint(x: self.frame.origin.x, y: sv.frame.minY-5-self.bounds.height)
                            }else{
                                self.frame.origin = CGPoint(x: self.frame.origin.x, y: sv.frame.maxY+5)
                            }
                        }else{
                            if self.frame.midX<sv.frame.midX{
                                self.frame.origin = CGPoint(x: sv.frame.origin.x-5-self.frame.width, y: self.frame.origin.y)
                            }else{
                                self.frame.origin = CGPoint(x: sv.frame.maxX+5, y: self.frame.origin.y)
                            }
                        }
                    }
                }
            }
            self.frame.origin = CGPoint(x: max(0,self.frame.origin.x), y: max(0,self.frame.origin.y))
            
            
            layoutSubviews()
            currentEdge = .none
            pageDelegate?.changeContentSize(using: self)
            
//            //used to redraw connecting lines if either view is moved
//            if let page = superview as? PageView{
//                page.setNeedsDisplay()
//            }
            pageDelegate?.reloadLine(with: self.card.UniquIdentifier, animated: false)
        }
    }
    
    func startResizing(){
        print("now starting to resize mediacardview")
        self.isResizing=true
        self.subviews.forEach { (sv) in
            sv.isHidden = true
            sv.isUserInteractionEnabled = false
        }
        self.gestureRecognizers?.forEach({ (gst) in
            gst.isEnabled=false
        })
        if let scrollView = superview?.superview as? UIScrollView {
            // if we are in a scroll view, disable its recognizers
            // so that ours will get the touch events instead
            scrollView.panGestureRecognizer.isEnabled = false
            scrollView.pinchGestureRecognizer?.isEnabled = false
        }
    }
    
}
extension MediaCardView{
    var numberOfImagesToShow: Int{
        return 3
    }
    var distanceOfEachNewImageFromPreviousImage: CGFloat{
        return 7.0
    }
    var shadowRadius: CGFloat{
        return 2.0
    }
    var cornerRadius: CGFloat{
        return 6.0
    }
    var shadowColor: CGColor{
        return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    var minWidth: CGFloat{
        return 100
    }
    var minHeight: CGFloat{
        return 100
    }
}

//MARK: media dat to img conversion: Data based implementation
//        for ind in card.mediaData.indices{
//            if ind<card.mediaData.count-numberOfImagesToShow{
//                continue
//            }
//            //DO NOT CHANGE TO LET CAUSES PROBLEM IN NEXT ITERATION
//            var x=card.mediaData[ind]
//            print("checking if element a image")
//            if let image = UIImage(data: x){
//                //            if let image = x as? UIImage{
//                print("found a image")
//                let view=UIImageView()
//                view.image=image
//                view.contentMode = .scaleAspectFill
//                //TODO: if set to false shadows would appear but proper edge distance b/w subviews won't be maintained
//                view.layer.masksToBounds=true
//                view.layer.shadowColor=shadowColor
//                view.layer.shadowOpacity=1.0
//                //TODO: see if below line for caching causes a problem in resizing if not set it
//                //                view.layer.shouldRasterize=true
//                view.layer.shadowRadius = shadowRadius
//                view.translatesAutoresizingMaskIntoConstraints=false
//                addSubview(view)
//                [
//                    view.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: +dist),
//                    view.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -dist),
//                    view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: +dist),
//                    view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -dist)
//                    ].forEach { (cst) in
//                        cst.isActive=true
//                }
//                imageViews.append(view)
//
//            }
//            i+=1
//            dist+=distanceOfEachNewImageFromPreviousImage
//            if i>=numberOfImagesToShow{
//                break
//            }
//        }
