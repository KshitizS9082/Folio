//
//  SmallCardView.swift
//  Folio
//
//  Created by Kshitiz Sharma on 16/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import PencilKit

class SmallCardView: UIView {
    var card = SmallCard()
    var isEditting = false
    var pageDelegate : pageProtocol?
    
    var checkBox = UIImageView()
    private func configureCheckBox(){
        checkBox.translatesAutoresizingMaskIntoConstraints=false
        checkBox.isUserInteractionEnabled=true
        if self.subviews.contains(checkBox)==false{
            addSubview(checkBox)
        }
        [
            checkBox.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: cornerRadius),
            checkBox.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: cornerRadius),
            checkBox.widthAnchor.constraint(equalToConstant: checkBoxDimensions),
            checkBox.heightAnchor.constraint(equalToConstant: checkBoxDimensions)
            ].forEach { (constraint) in
                constraint.isActive=true
        }
        if(card.isDone){
            checkBox.image = UIImage(systemName: "largecircle.fill.circle")
        }else{
            checkBox.image = UIImage(systemName: "circle")
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCheckboxTap))
        checkBox.addGestureRecognizer(tap)
    }
    @objc private func handleCheckboxTap(){
        print("tapped checkbox")
        card.isDone = !card.isDone
        setNeedsLayout()
    }
    override func layoutSubviews() {
        if(isResizing){
            return
        }
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.backgroundColor = cardColour
        configureCheckBox()
        configureResizingButton()
        configureTitleTextAndInfoView()
        addTitleBottomBorderWithColor()
        configureReminderTextField()
        configureNotesTextView()
        addNotesBottomBorderWithColor()
//        pageDelegate?.resizeCard(for: self)
    }
   var resizingButton = UIImageView(image: UIImage(systemName: "crop"));
    private func configureResizingButton(){
        resizingButton.translatesAutoresizingMaskIntoConstraints=false
        resizingButton.isUserInteractionEnabled=true
        if self.subviews.contains(resizingButton)==false{
            addSubview(resizingButton)
        }
        [
            resizingButton.topAnchor.constraint(equalTo: checkBox.bottomAnchor, constant: cornerRadius),
            resizingButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: cornerRadius),
            resizingButton.widthAnchor.constraint(equalToConstant: checkBoxDimensions),
            resizingButton.heightAnchor.constraint(equalToConstant: checkBoxDimensions)
            ].forEach { (constraint) in
                constraint.isActive=true
        }
        if(isEditting){
            resizingButton.removeFromSuperview()
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleResizeButtonTap))
        resizingButton.addGestureRecognizer(tap)
    }
    @objc private func handleResizeButtonTap(){
        print("inside handleResizeButtonTap")
        isResizing=true
        self.subviews.forEach { (sv) in
            sv.isHidden = true
            sv.isUserInteractionEnabled = false
        }
        if let scrollView = superview?.superview as? UIScrollView {
            // if we are in a scroll view, disable its recognizers
            // so that ours will get the touch events instead
            scrollView.panGestureRecognizer.isEnabled = false
            scrollView.pinchGestureRecognizer?.isEnabled = false
        }
    }
    
    var titleTextView = UITextView()
    var infoButtonView = UIImageView()
    var titleTextBottomBorder = CALayer()
    private func configureTitleTextAndInfoView(){
        titleTextView.translatesAutoresizingMaskIntoConstraints=false
        if self.subviews.contains(titleTextView)==false{
            addSubview(titleTextView)
        }
        titleTextView.text = card.title
        if card.title.count==0 {
            titleTextView.text = "Title"
            titleTextView.textColor = UIColor.systemGray2
        }
        [
            titleTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: cornerRadius),
            titleTextView.leftAnchor.constraint(equalTo: checkBox.rightAnchor, constant: cornerRadius),
            titleTextView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -cornerRadius),
            titleTextView.bottomAnchor.constraint(greaterThanOrEqualTo: checkBox.bottomAnchor)
            ].forEach { (constraint) in
                constraint.isActive=true
        }
        titleTextView.delegate=self
        titleTextView.font = UIFont.preferredFont(forTextStyle: .headline)
        titleTextView.isScrollEnabled=false
        titleTextView.backgroundColor = #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 0)
        if(isEditting==false){
            infoButtonView.removeFromSuperview()
        }else{
            
            if titleTextView.textColor == UIColor.systemGray2{
                titleTextView.text=""
                titleTextView.textColor = UIColor.black
            }
            infoButtonView.isHidden=false
            infoButtonView.isUserInteractionEnabled = true
            infoButtonView.translatesAutoresizingMaskIntoConstraints=false
            if self.subviews.contains(infoButtonView)==false{
                addSubview(infoButtonView)
            }
            [
                infoButtonView.topAnchor.constraint(equalTo: checkBox.bottomAnchor, constant: cornerRadius),
                infoButtonView.leftAnchor.constraint(equalTo: checkBox.leftAnchor),
                infoButtonView.heightAnchor.constraint(equalToConstant: checkBoxDimensions),
                infoButtonView.widthAnchor.constraint(equalToConstant: checkBoxDimensions)
                ].forEach { (constraint) in
                    constraint.isActive=true
            }
            infoButtonView.image = UIImage(systemName: "info.circle")
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapInfoButton))
            infoButtonView.addGestureRecognizer(tap)
        }
    }
    func addTitleBottomBorderWithColor() {
        titleTextBottomBorder.backgroundColor = UIColor.systemGray.cgColor
        titleTextBottomBorder.frame = CGRect(x: 0, y: titleTextView.frame.height - 1, width: titleTextView.frame.width, height: 1)
        if titleTextView.layer.sublayers?.contains(titleTextBottomBorder)==false{
            titleTextView.layer.addSublayer(titleTextBottomBorder)
        }
        self.layer.masksToBounds = true
    }
    @objc private func handleTapInfoButton(){
        card.title = titleTextView.text; card.notes = notesTextView.text
        self.isEditting=false
        titleTextView.resignFirstResponder(); notesTextView.resignFirstResponder()
        pageDelegate?.showSmallCardInfoView(for: self)
    }
    
    var reminderTextField = UILabel()
    private func configureReminderTextField(){
        reminderTextField.translatesAutoresizingMaskIntoConstraints=false
        if self.subviews.contains(reminderTextField)==false{
            addSubview(reminderTextField)
            reminderTextField.text = card.notes
        }
        
        [
            reminderTextField.topAnchor.constraint(equalTo: titleTextView.bottomAnchor),
            reminderTextField.leftAnchor.constraint(equalTo: checkBox.rightAnchor, constant: cornerRadius),
            reminderTextField.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -cornerRadius),
            reminderTextField.bottomAnchor.constraint(greaterThanOrEqualTo: checkBox.bottomAnchor)
            ].forEach { (constraint) in
                constraint.isActive=true
        }
        
        reminderTextField.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        if let time=card.reminderDate{
            let formatter = DateFormatter()
            formatter.dateFormat = "d/M/yy, hh:mm a"
            reminderTextField.text = formatter.string(from: time)
            formatter.dateFormat = "d/M/yy"
            if(formatter.string(from: time)==formatter.string(from: Date()) ){
                if(card.isDone){
                    reminderTextField.textColor = UIColor.systemGreen
                }else{
                    reminderTextField.textColor = UIColor.systemOrange
                }
            }else if(time<Date()){
                reminderTextField.textColor = UIColor.systemRed
                if(card.isDone){
                    reminderTextField.textColor = UIColor.systemGray2
                }else{
                    reminderTextField.textColor = UIColor.systemRed
                }
            }else{
                reminderTextField.textColor = UIColor.systemGray2
            }
        }else{
            reminderTextField.text = nil
        }
        reminderTextField.sizeToFit()
    }
    
    var notesTextView = UITextView()
    var notesTextBottomBorder = CALayer()
    private func configureNotesTextView(){
        notesTextView.translatesAutoresizingMaskIntoConstraints=false
        if self.subviews.contains(notesTextView)==false{
            addSubview(notesTextView)
        }
        notesTextView.text = card.notes
        if card.notes.count==0 {
            notesTextView.text="Notes"
            notesTextView.textColor=UIColor.systemGray2
        }else{
            notesTextView.textColor = UIColor.systemGray
        }
        [
            notesTextView.topAnchor.constraint(equalTo: reminderTextField.bottomAnchor),
            notesTextView.leftAnchor.constraint(equalTo: checkBox.rightAnchor, constant: cornerRadius),
            notesTextView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -cornerRadius),
            notesTextView.bottomAnchor.constraint(greaterThanOrEqualTo: checkBox.bottomAnchor)
            ].forEach { (constraint) in
                constraint.isActive=true
        }
        notesTextView.delegate=self
        notesTextView.font = UIFont.preferredFont(forTextStyle: .subheadline)
        notesTextView.isScrollEnabled=false
        notesTextView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    func addNotesBottomBorderWithColor() {
        notesTextBottomBorder.backgroundColor = UIColor.systemGray.cgColor
        notesTextBottomBorder.frame = CGRect(x: 0, y: notesTextView.frame.height - 1, width: notesTextView.frame.width, height: 1)
        if notesTextView.layer.sublayers?.contains(notesTextBottomBorder)==false{
            notesTextView.layer.addSublayer(notesTextBottomBorder)
        }
        self.layer.masksToBounds = true
    }
    
//    override func setNeedsDisplay() {
//        self.pageDelegate?.resizeCard(for: self)
//    }
    //MARK: Make view resizable
    var isResizing = false
    enum Edge {
        case topLeft, topRight, bottomLeft, bottomRight, bottom, top, left, right, none
    }
    static var edgeSize: CGFloat = 20.0
    var currentEdge: Edge = .none
    var touchStart = CGPoint.zero
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("found touch")
        //        joiningViewsDelegate?.joinMe(with: self, forID: self.sCard.UniquIdentifier!)
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
            //used to redraw connecting lines if either view is moved
            if let page = superview as? PageView{
                page.setNeedsDisplay()
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isResizing{
            print("ended")
            if let scrollView = superview?.superview as? UIScrollView {
                // if we are in a scroll view, disable its recognizers
                // so that ours will get the touch events instead
                scrollView.panGestureRecognizer.isEnabled = true
                scrollView.pinchGestureRecognizer?.isEnabled = true
            }
            isResizing=false
            let minwidth =  checkBoxDimensions*4
            if frame.width < minwidth{
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: minwidth, height: self.frame.height)
            }
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: max(minwidth, self.frame.width), height: max(self.frame.height, checkBoxDimensions*2+cornerRadius*2))
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
            //used to redraw connecting lines if either view is moved
            if let page = superview as? PageView{
                page.setNeedsDisplay()
            }
        }
    }
}

extension SmallCardView{
    var cornerRadius: CGFloat {
        return 6
    }
    var checkBoxDimensions: CGFloat{
        return 30
    }
    var cardColour: UIColor{
        return UIColor(named: "smallCardColor") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
}

extension SmallCardView: UITextViewDelegate{
    //TODO: too many saves, remove the one's which are unnecessary
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("didbegin")
        if textView.textColor == UIColor.systemGray2{
            textView.textColor = UIColor.black
            textView.text = ""
        }
        if !isEditting{
            isEditting = true
            layoutSubviews()
        }
        pageDelegate?.resizeCard(for: self)
    }
    func textViewDidChange(_ textView: UITextView) {
        card.title=self.titleTextView.text
        card.notes=self.notesTextView.text
        pageDelegate?.resizeCard(for: self)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        card.title=self.titleTextView.text
        card.notes=self.notesTextView.text
        if titleTextView.text.count==0{
            titleTextView.text="Title"
            titleTextView.textColor=UIColor.systemGray2
        }
        if notesTextView.text.count==0{
            notesTextView.text="Notes"
            notesTextView.textColor=UIColor.systemGray2
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("shouldchange")
        if text == "\n" {
            textView.resignFirstResponder()
            isEditting=false
            card.title = titleTextView.text
            card.notes = notesTextView.text
            layoutSubviews()
            return false
        }
        return true
    }
}
