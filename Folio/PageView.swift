//
//  PageView.swift
//  Folio
//
//  Created by Kshitiz Sharma on 14/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
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
    override func layoutSubviews() {
//        self.isExclusiveTouch=false
    }
    override func draw(_ rect: CGRect) {
//        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: pageCornerRadius)
        let rect = UIBezierPath(rect: bounds)
        rect.addClip()
        pageColor.setFill()
        rect.fill()
        let stripes = UIBezierPath()
        var i=0
        while( 50*CGFloat(i)<=bounds.height){
            stripes.move(to: CGPoint(x: 0, y: 50*CGFloat(i)) )
            lineColor.setStroke()
            stripes.addLine(to: CGPoint(x: bounds.width, y: 50*CGFloat(i)) )
            stripes.lineWidth = 1.0
            stripes.stroke()
            i+=1
        }
        i=0
        while( 50*CGFloat(i)<=bounds.width){
            stripes.move(to: CGPoint(x: 50*CGFloat(i), y: 0) )
            lineColor.setStroke()
            stripes.addLine(to: CGPoint(x: 50*CGFloat(i), y: bounds.height) )
            stripes.lineWidth = 1.0
            stripes.stroke()
            i+=1
        }
    }
    func addSmallCard(centeredAt point: CGPoint){
//        if let nib = Bundle.main.loadNibNamed("SmallCardView", owner: self),
//            let nibView = nib.first as? UIView {
//            let newFrame = CGRect(origin: CGPoint(x: max(0, point.x-(smallCardWidth/2)), y: max(0,point.y-(smallCardHeight/2))), size: CGSize(width: smallCardWidth, height: smallCardHeight))
//            nibView.frame = newFrame
//            nibView.autoresizingMask = [.flexibleHeight]
//            self.addSubview(nibView)
//            print("view bounds = \(self.bounds), newviewframe = \(nibView.frame)")
//        }
//        setNeedsDisplay()
        
        let newFrame = CGRect(origin: CGPoint(x: max(0, point.x-(smallCardWidth/2)), y: max(0,point.y-(smallCardHeight/2))), size: CGSize(width: smallCardWidth, height: smallCardHeight))
        let nv = SmallCardView(frame: newFrame)
        nv.isUserInteractionEnabled=true
        self.addSubview(nv)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         guard let point = touches.first?.location(in: self) else { return }
        switch currentTask {
        case .addSmallCard:
            print("addSmallCard")
            self.addSmallCard(centeredAt: point)
        case .addCard:
            print("addCard")
        case .drawLines:
            print("drawLines")
        case .delete:
            print("drawLines")
        case .addMediaCard:
            print("addMediaCard")
        case .connectViews:
            print("connectViews")
        case .noneOfAbove:
            print("noneOfAbove")
        default:
            print("dunno what to do with touch began")
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
}
