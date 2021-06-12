////
////  TextCardView.swift
////  Folio
////
////  Created by Kshitiz Developer on 29/06/20.
////  Copyright © 2020 Kshitiz Sharma. All rights reserved.
////
//
//import UIKit
//import PencilKit
//struct TextCard: Codable{
//    var title = "fsadfsddfdf"
//}
//
//class TextCardView: UIView, UITextViewDelegate {
//    var card = TextCard()
////    var pageDelegate : pageProtocol?
//    var textLabel = UITextView()
//    var resizingButton = UIImageView(image: UIImage(systemName: "crop"));
//    var cornerRadius: CGFloat {
//        return 10
//    }
//    var checkBoxDimensions: CGFloat{
//        return 30
//    }
//    override func layoutSubviews() {
//        self.backgroundColor = .clear
//        self.layer.cornerRadius = cornerRadius
//        self.layer.backgroundColor = (UIColor(named: "smallCardColor") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)).cgColor
//        //Draw shaddow for layer
//        self.layer.shadowColor = UIColor.gray.cgColor
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//        self.layer.shadowRadius = 3.0
//        self.layer.shadowOpacity = 0.2
//        
//        resizingButton.translatesAutoresizingMaskIntoConstraints=false
//        resizingButton.isUserInteractionEnabled=true
//        if self.subviews.contains(resizingButton)==false{
//            addSubview(resizingButton)
//        }
//        [
//            //            resizingButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: cornerRadius),
//            resizingButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: cornerRadius),
//            resizingButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
//            resizingButton.widthAnchor.constraint(equalToConstant: checkBoxDimensions),
//            resizingButton.heightAnchor.constraint(equalToConstant: checkBoxDimensions)
//            ].forEach { (constraint) in
//                constraint.isActive=true
//        }
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleResizeButtonTap))
//        resizingButton.addGestureRecognizer(tap)
//        
//        textLabel.translatesAutoresizingMaskIntoConstraints=false
//        if self.subviews.contains(textLabel)==false{
//            addSubview(textLabel)
//        }
//        textLabel.delegate=self
//        textLabel.text = card.title
////        textLabel.backgroundColor = .green
//        [
//            textLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
////            textLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: cornerRadius),
////            textLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -cornerRadius),
//            textLabel.leftAnchor.constraint(equalTo: resizingButton.rightAnchor, constant: 2),
//            textLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -cornerRadius),
//            textLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -cornerRadius)
//            ].forEach { (constraint) in
//                constraint.isActive=true
//        }
//        textLabel.font = UIFont.preferredFont(forTextStyle: .title1)
//        textLabel.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
//    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        card.title=textView.text
//    }
//    @objc func tapDone(sender: Any) {
////        self.isEditting=false
//        self.endEditing(true)
//        self.layoutSubviews()
//    }
//    @objc private func handleResizeButtonTap(){
//        print("inside handleResizeButtonTap")
//        isResizing=true
//        self.subviews.forEach { (sv) in
//            sv.isHidden = true
//            sv.isUserInteractionEnabled = false
//        }
//        if let scrollView = superview?.superview as? UIScrollView {
//            // if we are in a scroll view, disable its recognizers
//            // so that ours will get the touch events instead
//            scrollView.panGestureRecognizer.isEnabled = false
//            scrollView.pinchGestureRecognizer?.isEnabled = false
//        }
//    }
//    //MARK: Make view resizable
//    var isResizing = false
//    enum Edge {
//        case topLeft, topRight, bottomLeft, bottomRight, bottom, top, left, right, none
//    }
//    static var edgeSize: CGFloat = 20.0
//    var currentEdge: Edge = .none
//    var touchStart = CGPoint.zero
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("found touch")
//        //        joiningViewsDelegate?.joinMe(with: self, forID: self.sCard.UniquIdentifier!)
//        //            pageDelegate?.addMeAsWantingToJoinConnectLines(for: self, with: self.card.UniquIdentifier)
//        if isResizing{
//            if let touch = touches.first {
//                
//                touchStart = touch.location(in: self)
//                
//                currentEdge = {
//                    if self.bounds.size.width - touchStart.x < Self.edgeSize && self.bounds.size.height - touchStart.y < Self.edgeSize {
//                        return .bottomRight
//                    } else if touchStart.x < Self.edgeSize && touchStart.y < Self.edgeSize {
//                        return .topLeft
//                    } else if self.bounds.size.width-touchStart.x < Self.edgeSize && touchStart.y < Self.edgeSize {
//                        return .topRight
//                    } else if touchStart.x < Self.edgeSize && self.bounds.size.height - touchStart.y < Self.edgeSize {
//                        return .bottomLeft
//                    }else if self.bounds.size.height - touchStart.y < Self.edgeSize{
//                        return .bottom
//                    }else if touchStart.y < Self.edgeSize {
//                        return .top
//                    }else if self.bounds.size.width-touchStart.x < Self.edgeSize{
//                        return .right
//                    } else if touchStart.x < Self.edgeSize {
//                        return .left
//                    }
//                    return .none
//                }()
//            }
//            if let page = superview as? PageView{
//                page.bringSubviewToFront(self)
//            }
//        }
//    }
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if isResizing{
//            if let touch = touches.first {
//                let currentPoint = touch.location(in: self)
//                let previous = touch.previousLocation(in: self)
//                
//                let originX = self.frame.origin.x
//                let originY = self.frame.origin.y
//                let width = self.frame.size.width
//                let height = self.frame.size.height
//                
//                let deltaWidth = currentPoint.x - previous.x
//                let deltaHeight = currentPoint.y - previous.y
//                
//                switch currentEdge {
//                case .topLeft:
//                    self.frame = CGRect(x: originX + deltaWidth, y: originY + deltaHeight, width: width - deltaWidth, height: height - deltaHeight)
//                case .topRight:
//                    self.frame = CGRect(x: originX, y: originY + deltaHeight, width: width + deltaWidth, height: height - deltaHeight)
//                case .bottomRight:
//                    self.frame = CGRect(x: originX, y: originY, width: width + deltaWidth, height: height + deltaWidth)
//                case .bottomLeft:
//                    self.frame = CGRect(x: originX + deltaWidth, y: originY, width: width - deltaWidth, height: height + deltaHeight)
//                case .bottom:
//                    self.frame = CGRect(x: originX, y: originY, width: width, height: height + deltaHeight)
//                case .top:
//                    self.frame = CGRect(x: originX, y: originY+deltaHeight, width: width, height: height - deltaHeight)
//                case .left:
//                    self.frame = CGRect(x: originX+deltaWidth, y: originY, width: width-deltaWidth, height: height)
//                case .right:
//                    self.frame = CGRect(x: originX, y: originY, width: width+deltaWidth, height: height)
//                default:
//                    // Moving
//                    self.frame = CGRect(x: originX+deltaWidth, y: originY+deltaHeight, width: width, height: height)
//                }
//            }
//            //            //used to redraw connecting lines if either view is moved
//            //            if let page = superview as? PageView{
//            //                page.setNeedsDisplay()
//            //            }
//            //                pageDelegate?.reloadLine(with: self.card.UniquIdentifier, animated: false)
//        }
//    }
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if isResizing{
//            print("ended")
//            if let scrollView = superview?.superview as? UIScrollView {
//                // if we are in a scroll view, disable its recognizers
//                // so that ours will get the touch events instead
//                scrollView.panGestureRecognizer.isEnabled = true
//                scrollView.pinchGestureRecognizer?.isEnabled = true
//            }
//            isResizing=false
//            let minwidth =  PageView().textCardWidth
//            if frame.width < minwidth{
//                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: minwidth, height: self.frame.height)
//            }
//            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: max(minwidth, self.frame.width), height: max(self.frame.height, PageView().textCardHeight))
//            self.subviews.forEach { (sv) in
//                sv.isHidden = false
//                sv.isUserInteractionEnabled = true
//            }
//            
//            //Place card allign properly to near by subviewß
//            if let pagev = superview as? PageView{
//                for sv in pagev.subviews{
//                    //is UIButton is done to keep check on gridButtons
//                    if sv.frame==self.frame || sv.isHidden==true || sv is UIButton{
//                        continue
//                    }
//                    if let _ = sv as? PKCanvasView{
//                        continue
//                    }
//                    if self.frame.intersects(sv.frame){
//                        if abs(self.frame.midX-sv.frame.midX) < abs(self.frame.midY-sv.frame.midY){
//                            if self.frame.midY<sv.frame.midY{
//                                self.frame.origin = CGPoint(x: self.frame.origin.x, y: sv.frame.minY-5-self.bounds.height)
//                            }else{
//                                self.frame.origin = CGPoint(x: self.frame.origin.x, y: sv.frame.maxY+5)
//                            }
//                        }else{
//                            if self.frame.midX<sv.frame.midX{
//                                self.frame.origin = CGPoint(x: sv.frame.origin.x-5-self.frame.width, y: self.frame.origin.y)
//                            }else{
//                                self.frame.origin = CGPoint(x: sv.frame.maxX+5, y: self.frame.origin.y)
//                            }
//                        }
//                    }
//                }
//            }
//            self.frame.origin = CGPoint(x: max(0,self.frame.origin.x), y: max(0,self.frame.origin.y))
//            
//            
//            layoutSubviews()
//            currentEdge = .none
//            pageDelegate?.changeContentSize(using: self)
//            //            //used to redraw connecting lines if either view is moved
//            //            if let page = superview as? PageView{
//            //                page.setNeedsDisplay()
//            //            }
//            //                pageDelegate?.reloadLine(with: self.card.UniquIdentifier, animated: false)
//        }
//    }
//    
//    
//}
