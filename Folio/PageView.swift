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

class PageView: UIView {
    var page=PageData()
    var currentTask = pageViewCurrentTask.noneOfAbove
    var pageDelegate: pageProtocol?
    var myViewController: PageViewController?
    var drawing = DrawingView()
    var canvas: PKCanvasView?

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
//        let rect = UIBezierPath(rect: bounds)
//        rect.addClip()
//        pageColor.setFill()
//        rect.fill()
//        let stripes = UIBezierPath()
//        var i=0
//        while( 50*CGFloat(i)<=bounds.height){
//            stripes.move(to: CGPoint(x: 0, y: 50*CGFloat(i)) )
//            lineColor.setStroke()
//            stripes.addLine(to: CGPoint(x: bounds.width, y: 50*CGFloat(i)) )
//            stripes.lineWidth = 1.0
//            stripes.stroke()
//            i+=1
//        }
//        i=0
//        while( 50*CGFloat(i)<=bounds.width){
//            stripes.move(to: CGPoint(x: 50*CGFloat(i), y: 0) )
//            lineColor.setStroke()
//            stripes.addLine(to: CGPoint(x: 50*CGFloat(i), y: bounds.height) )
//            stripes.lineWidth = 1.0
//            stripes.stroke()
//            i+=1
//        }
    }
    func addSmallCard(centeredAt point: CGPoint){
        let newFrame = CGRect(origin: CGPoint(x: max(0, point.x-(smallCardWidth/2)), y: max(0,point.y-(smallCardHeight/2))), size: CGSize(width: smallCardWidth, height: smallCardHeight))
        let nv = SmallCardView(frame: newFrame)
        nv.pageDelegate=myViewController
        nv.isUserInteractionEnabled=true
        self.addSubview(nv)
        self.currentTask = .noneOfAbove
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
    func addMediaCard(centeredAt point: CGPoint){
        let newFrame = CGRect(origin: CGPoint(x: max(0, point.x-(mediaCardDimension/2)), y: max(0,point.y-(mediaCardDimension/2))), size: CGSize(width: mediaCardDimension, height: mediaCardDimension))
        let nv = MediaCardView(frame: newFrame)
        nv.pageDelegate=myViewController
        nv.isUserInteractionEnabled=true
        self.addSubview(nv)
        nv.layer.masksToBounds=true
        nv.pageDelegate?.getMeMedia(for: nv)
//        pageDelegate?.getMeMedia(for: newCardView)
//        nv.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongPressMediaView)))
        self.currentTask = .noneOfAbove
        pageDelegate?.changeContentSize(using: nv)
    }

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
        default:
            if let scrollView = superview as? UIScrollView {
                print("found scrollview to enable")
                scrollView.panGestureRecognizer.isEnabled = true
            }
            canvas?.isUserInteractionEnabled=false
        }
    }
    override func layoutSubviews() {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        switch currentTask {
        case .addSmallCard:
            print("addSmallCard")
            self.addSmallCard(centeredAt: point)
        case .addCard:
            print("addCard")
            self.addBigCard(centeredAt: point)
        case .drawLines:
            print("drawLines")
            return
        case .delete:
            print("drawLines")
        case .addMediaCard:
            print("addMediaCard")
            self.addMediaCard(centeredAt: point)
        case .connectViews:
            print("connectViews")
        case .noneOfAbove:
            print("noneOfAbove")
        default:
            print("dunno what to do with touch began")
            canvas?.isUserInteractionEnabled=false
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentTask = .noneOfAbove
    }
}
extension PageView{
    var pageColor: UIColor{
        return #colorLiteral(red: 0.9411764706, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
    }
    var lineColor: UIColor{
        return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    var smallCardWidth: CGFloat{
        return 250
    }
    var smallCardHeight: CGFloat{
        return 150
    }
    var bigCardWidth: CGFloat{
        return 300
    }
    var bigCardHeight: CGFloat{
        return 200
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

