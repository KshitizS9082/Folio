//
//  PageView.swift
//  Folio
//
//  Created by Kshitiz Sharma on 14/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import PencilKit

enum pageViewCurrentTask {
    case addSmallCard
    case addCard
    case addTextCard
    case drawLines
    case delete
    case addMediaCard
    case connectViews
    case noneOfAbove
}
protocol SCardProtocol {
    func resizeSCard(for scard: SmallCard, at sCardView: SmallCardView)
    func makeSCardHeight(for scard: SmallCard, at sCardView: SmallCardView, to height: CGFloat)
    func updateSCard(for scard: SmallCard, at sCardView: SmallCardView)
    func updateSCardNoRelayout(for scard: SmallCard, at sCardView: SmallCardView)
    func showSmallCardInfoView(for scard: SmallCard, at sCardView: SmallCardView)
    func deleteSCard(for scard: SmallCard, at sCardView: SmallCardView)
}
//class gridUIView: UIView {
//    var isGrid = false
//    override func draw(_ rect: CGRect) {
//        if isGrid{
//            let lineSpacing = CGFloat(50)
//            let rect = UIBezierPath(rect: bounds)
//            rect.addClip()
//            pageColor.setFill()
//            rect.fill()
//            let stripes = UIBezierPath()
//            var i=0
//            while( lineSpacing*CGFloat(i)<=bounds.height){
//                stripes.move(to: CGPoint(x: 0, y: lineSpacing*CGFloat(i)) )
//                lineColor.setStroke()
//                stripes.addLine(to: CGPoint(x: bounds.width, y: lineSpacing*CGFloat(i)) )
//                stripes.lineWidth = 1.0
//                stripes.stroke()
//                i+=1
//            }
//            i=0
//            while( lineSpacing*CGFloat(i)<=bounds.width){
//                stripes.move(to: CGPoint(x: lineSpacing*CGFloat(i), y: 0) )
//                lineColor.setStroke()
//                stripes.addLine(to: CGPoint(x: lineSpacing*CGFloat(i), y: bounds.height) )
//                stripes.lineWidth = 1.0
//                stripes.stroke()
//                i+=1
//            }
//        }
//    }
//    var pageColor: UIColor{
//        return UIColor(named: "myBackgroundColor") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//    }
//    var lineColor: UIColor{
//        return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//    }
//}

class PageView: UIView {
    var page=PageData()
    var currentTask = pageViewCurrentTask.noneOfAbove
    var pageDelegate: pageProtocol?
    var myViewController: PageViewController?
    var drawing = DrawingView()
    var canvas: PKCanvasView?
    
//    var gridView = gridUIView()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addInteraction(UIDropInteraction(delegate: self))
    }
    override func draw(_ rect: CGRect) {
//        if isGrid{
//            let lineSpacing = CGFloat(50)
//            let rect = UIBezierPath(rect: bounds)
//            rect.addClip()
//            pageColor.setFill()
//            rect.fill()
//            let stripes = UIBezierPath()
//            var i=0
//            while( lineSpacing*CGFloat(i)<=bounds.height){
//                stripes.move(to: CGPoint(x: 0, y: lineSpacing*CGFloat(i)) )
//                lineColor.setStroke()
//                stripes.addLine(to: CGPoint(x: bounds.width, y: lineSpacing*CGFloat(i)) )
//                stripes.lineWidth = 1.0
//                stripes.stroke()
//                i+=1
//            }
//            i=0
//            while( lineSpacing*CGFloat(i)<=bounds.width){
//                stripes.move(to: CGPoint(x: lineSpacing*CGFloat(i), y: 0) )
//                lineColor.setStroke()
//                stripes.addLine(to: CGPoint(x: lineSpacing*CGFloat(i), y: bounds.height) )
//                stripes.lineWidth = 1.0
//                stripes.stroke()
//                i+=1
//            }
//        }
    }
    func addSmallCard(centeredAt point: CGPoint){
        let newFrame = CGRect(origin: CGPoint(x: max(0, point.x-(smallCardWidth/2)), y: max(0,point.y-(smallCardHeight/2))), size: CGSize(width: smallCardWidth, height: smallCardHeight))
        let nv = SmallCardView(frame: newFrame)
        nv.pageDelegate=myViewController
        nv.isUserInteractionEnabled=true
        self.addSubview(nv)
        self.currentTask = .noneOfAbove
        nv.setNeedsDisplay()
        pageDelegate?.changeContentSize(using: nv)
    }
    func addBigCard(centeredAt point: CGPoint){
        let newFrame = CGRect(origin: CGPoint(x: max(0, point.x-(bigCardWidth/2)), y: max(0,point.y-(bigCardHeight/2))), size: CGSize(width: bigCardWidth, height: bigCardHeight))
        let nv = cardView(frame: newFrame)
        nv.pageDelegate=myViewController
        nv.isUserInteractionEnabled=true
        self.addSubview(nv)
        self.currentTask = .noneOfAbove
        pageDelegate?.changeContentSize(using: nv)
    }
    func addTextCard(centeredAt point: CGPoint){
        let newFrame = CGRect(origin: CGPoint(x: max(0, point.x-(textCardWidth/2)), y: max(0,point.y-(textCardHeight/2))), size: CGSize(width: textCardWidth, height: textCardHeight))
        let nv = TextCardView(frame: newFrame)
        nv.pageDelegate=myViewController
        nv.isUserInteractionEnabled=true
        self.addSubview(nv)
        self.currentTask = .noneOfAbove
        pageDelegate?.changeContentSize(using: nv)
    }
    func addMediaCard(centeredAt point: CGPoint){
        let newFrame = CGRect(origin: CGPoint(x: max(0, point.x-(mediaCardDimension/2)), y: max(0,point.y-(mediaCardDimension/2))), size: CGSize(width: mediaCardDimension, height: mediaCardDimension))
        let nv = MediaCardView(frame: newFrame)
        nv.pageDelegate=myViewController
        nv.isUserInteractionEnabled=true
        self.addSubview(nv)
        nv.layer.masksToBounds=true
//        nv.pageDelegate?.getMeMedia(for: nv)
//        pageDelegate?.getMeMedia(for: newCardView)
//        nv.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongPressMediaView)))
        self.currentTask = .noneOfAbove
        pageDelegate?.changeContentSize(using: nv)
    }
    
    //For drawing connections
    var viewListDictionary = [UUID: UIView]()
    func setupViewListDict(){
        viewListDictionary.removeAll()
        self.subviews.forEach { (sv) in
            if let sv = sv as? cardView{
                viewListDictionary[sv.card.UniquIdentifier]=sv
            }else if let sv = sv as? SmallCardView{
                viewListDictionary[sv.card.UniquIdentifier]=sv
            }else if let sv = sv as? MediaCardView{
                viewListDictionary[sv.card.UniquIdentifier]=sv
            }
        }
    }
    
    weak var shapeLayer: CAShapeLayer?
//    func addLines(from firstID: UUID, to secondId: UUID){
//        // remove old shape layer if any
//
//        self.shapeLayer?.removeFromSuperlayer()
//
//        // create whatever path you want
//
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 10, y: 50))
//        path.addLine(to: CGPoint(x: 200, y: 50))
//        path.addLine(to: CGPoint(x: 200, y: 240))
//
//        // create shape layer for that path
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
//        shapeLayer.strokeColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1).cgColor
//        shapeLayer.lineWidth = 4
//        shapeLayer.path = path.cgPath
//
//        // animate it
//
//        self.layer.addSublayer(shapeLayer)
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.fromValue = 0
//        animation.duration = 2
//        shapeLayer.add(animation, forKey: "MyAnimation")
//
//        // save shape layer
//
//        self.shapeLayer = shapeLayer
//    }

    func setupDrawing(){
        switch currentTask {
        case .drawLines:
            print("readyng for draw lines")
            if let scrollView = superview as? UIScrollView {
                print("found scrollview to disable")
                // if we are in a scroll view, disable its recognizers
                // so that ours will get the touch events instead
                scrollView.panGestureRecognizer.isEnabled = false
            }
            canvas?.isUserInteractionEnabled=true
            canvas?.becomeFirstResponder()
        default:
            if let scrollView = superview as? UIScrollView {
                print("found scrollview to enable")
                scrollView.panGestureRecognizer.isEnabled = true
            }
            canvas?.isUserInteractionEnabled=false
            canvas?.resignFirstResponder()
        }
    }
    override func layoutSubviews() {
        self.layer.shadowColor = UIColor.gray.cgColor
//               self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
               self.layer.shadowRadius = 30.0
               self.layer.shadowOpacity = 0.4
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        switch currentTask {
        case .addSmallCard:
            print("addSmallCard")
            self.addSmallCard(centeredAt: point)
            self.pageDelegate?.updateCurrentTaskToNone()
        case .addCard:
            print("addCard")
            self.addBigCard(centeredAt: point)
            self.pageDelegate?.updateCurrentTaskToNone()
        case .addTextCard:
            print("add textCard")
            self.addTextCard(centeredAt: point)
            self.pageDelegate?.updateCurrentTaskToNone()
        case .drawLines:
            print("drawLines")
            return
        case .delete:
            print("drawLines")
        case .addMediaCard:
            print("addMediaCard")
            self.addMediaCard(centeredAt: point)
            self.pageDelegate?.updateCurrentTaskToNone()
        case .connectViews:
            print("connectViews")
        case .noneOfAbove:
            print("noneOfAbove")
//        default:
//            print("dunno what to do with touch began")
//            canvas?.isUserInteractionEnabled=false
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentTask = .noneOfAbove
        self.pageDelegate?.updateCurrentTaskToNone()
    }
}
extension PageView{
    var pageColor: UIColor{
        return UIColor(named: "myBackgroundColor") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//        return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//        return #colorLiteral(red: 0.9411764706, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
    }
    var lineColor: UIColor{
        return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//        return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    var smallCardWidth: CGFloat{
        return 240
    }
    var smallCardHeight: CGFloat{
        return 110
    }
    var bigCardWidth: CGFloat{
        return 240
    }
    var bigCardHeight: CGFloat{
        return 170
    }
    var textCardHeight: CGFloat{
        return 60
    }
    var textCardWidth: CGFloat{
        return 170
    }
    var mediaCardDimension: CGFloat{
        return 100
    }
}
extension PageView: UIDropInteractionDelegate{
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSAttributedString.self) { providers in
            let dropPoint = session.location(in: self)
            print("point= \(dropPoint)")
            for attributedString in providers as? [NSAttributedString] ?? [] {
                print(attributedString.string)
                switch attributedString.string {
                case "Big Card":
                    self.addBigCard(centeredAt: dropPoint)
                case "Small Card":
                    self.addSmallCard(centeredAt: dropPoint)
                    //                case "Add Image":
                    //                    self.addImageCard(with: attributedString, centeredAt: dropPoint)
                case "Media Card":
                    self.addMediaCard(centeredAt: dropPoint)
                default:
                    print("handled a string with value not the one we conform to as a card")
                }
            }
        }
    }
}

