//
//  cardView.swift
//  card2
//
//  Created by Kshitiz Sharma on 07/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import MaterialTextField
import PencilKit

class cardView: UIView, UITextFieldDelegate, UITableViewDataSource {
    
    
    var card=Card()
    var pageDelegate : pageProtocol?
//    var updatingCardDelegate: UpdateCardProtocol?
//    var showFullVieweDelegate: ShowCardFullViewProtocol?
//    var showCardEditViewDelegate: ShowCardEditViewProtocol?
//    var joiningViewsDelegate: joinViewsProtocol?
    //set heading
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    var headingTextField: UITextField = UITextField()
    private func configureHeadingLabel(){
        if(self.subviews.contains(headingTextField)==false){
            addSubview(headingTextField)
        }
        self.headingTextField.delegate = self
        headingTextField.font = UIFont.preferredFont(forTextStyle: .headline)
//        headingTextField.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: headingTextField.font!)
        headingTextField.translatesAutoresizingMaskIntoConstraints = false
        [
            headingTextField.topAnchor.constraint(equalTo: toolBar.topAnchor, constant: cornerRadius),
            headingTextField.leftAnchor.constraint(equalTo: toolBar.rightAnchor, constant: spacings),
            headingTextField.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -cornerRadius),
            headingTextField.heightAnchor.constraint(equalToConstant: 30)
            ].forEach { (constraints) in
                constraints.isActive = true
        }
        if let headingText = card.Heading{
            headingTextField.text = headingText
        }
        headingTextField.placeholder = "Heading of card"
        
        headingTextField.textAlignment = .left
//        headingTextField.animatesPlaceholder = false
//        headingTextField.placeholderAnimatesOnFocus = true
    }
    
    //set time label
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    var timeLable = UILabel()
    var timeLabelHeadingConstraint: NSLayoutConstraint?
    private func configureTimeLabel(){
        if(self.subviews.contains(timeLable)==false){
            addSubview(timeLable)
        }
        timeLable.translatesAutoresizingMaskIntoConstraints = false
        [
            timeLable.topAnchor.constraint(equalTo: headingTextField.bottomAnchor),
            timeLable.leftAnchor.constraint(equalTo: toolBar.rightAnchor, constant: spacings),
            timeLable.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -cornerRadius)
            ].forEach { (constraints) in
                constraints.isActive = true
        }
        if timeLabelHeadingConstraint==nil{
            timeLabelHeadingConstraint=timeLable.heightAnchor.constraint(equalToConstant: checkBoxDimensions)
        }
        timeLabelHeadingConstraint?.isActive=true
        timeLable.font = UIFont.preferredFont(forTextStyle: .subheadline)
        if let time = card.reminder{
            timeLabelHeadingConstraint?.constant = checkBoxDimensions
            let formatter = DateFormatter()
            formatter.dateFormat = "d/M/yy, hh:mm a"
            timeLable.text = formatter.string(from: time)
            formatter.dateFormat = "d/M/yy"
            if(formatter.string(from: time)==formatter.string(from: Date()) ){
                if(card.isCompleted){
                    timeLable.textColor = UIColor.systemGreen
                }else{
                    timeLable.textColor = UIColor.systemOrange
                }
            }else if(time<Date()){
                timeLable.textColor = UIColor.systemRed
                if(card.isCompleted){
                    timeLable.textColor = UIColor.systemGray2
                }else{
                    timeLable.textColor = UIColor.systemRed
                }
            }else{
                timeLable.textColor = UIColor.systemGray2
            }
        }else{
            timeLabelHeadingConstraint?.constant = 0
            timeLable.text = nil
        }
    }
    
    //Set bottom toolbar
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    var toolBar = toolBarView()
    private func configureToolbar(){
        if self.subviews.contains(toolBar) == false{
            addSubview(toolBar)
        }
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        [
            toolBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            toolBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            toolBar.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            toolBar.widthAnchor.constraint(equalToConstant: checkBoxDimensions)
            ].forEach { (constraints) in
                constraints?.isActive=true
        }
        toolBar.layer.cornerRadius = cornerRadius
        
        //create checkmark option
        if(card.isCompleted){
            toolBar.checkMark.image = UIImage(systemName: "largecircle.fill.circle")
//            self.alpha = completedCardOpacity
        }else{
            toolBar.checkMark.image = UIImage(systemName: "circle")
            self.alpha = 1.0
        }
        if self.toolBar.subviews.contains(toolBar.checkMark) == false {
            toolBar.addSubview(toolBar.checkMark)
        }
        toolBar.checkMark.translatesAutoresizingMaskIntoConstraints = false
        [
            toolBar.checkMark.topAnchor.constraint(equalTo: toolBar.topAnchor, constant: cornerRadius),
            toolBar.checkMark.leftAnchor.constraint(equalTo: toolBar.leftAnchor, constant: +cornerRadius),
            toolBar.checkMark.heightAnchor.constraint(equalToConstant: checkBoxDimensions),
            toolBar.checkMark.widthAnchor.constraint(equalTo: toolBar.checkMark.heightAnchor)
            ].forEach { (constratints) in
                constratints?.isActive = true
        }
        toolBar.checkMark.isUserInteractionEnabled = true
        var tap = UITapGestureRecognizer(target: self, action: #selector(handleCardCheckBoxTap))
        toolBar.checkMark.addGestureRecognizer(tap)
        
        //create reminderclock option
//        if(card.reminder != nil){
//            toolBar.reminderClock.image = UIImage(systemName: "bell.circle");
//        }else{
//            toolBar.reminderClock.image =  UIImage(systemName: "circle")
//        }
//        if self.toolBar.subviews.contains(toolBar.reminderClock) == false {
//            toolBar.addSubview(toolBar.reminderClock)
//        }
//        toolBar.reminderClock.translatesAutoresizingMaskIntoConstraints = false
//        [
//            toolBar.reminderClock.topAnchor.constraint(equalTo: toolBar.checkMark.bottomAnchor, constant: cornerRadius),
//            toolBar.reminderClock.leftAnchor.constraint(equalTo: toolBar.checkMark.leftAnchor),
//            toolBar.reminderClock.widthAnchor.constraint(equalTo: toolBar.checkMark.widthAnchor),
//            toolBar.reminderClock.heightAnchor.constraint(equalTo: toolBar.checkMark.widthAnchor),
//            ].forEach { (constratints) in
//                constratints?.isActive = true
//        }
        
        //create editboundsbutton
        if self.toolBar.subviews.contains(toolBar.editBounds) == false {
            //            print("addes subview fullViewArrowView")
            toolBar.addSubview(toolBar.editBounds)
        }
        toolBar.editBounds.translatesAutoresizingMaskIntoConstraints = false
        [
//            toolBar.editBounds.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor),
            toolBar.editBounds.topAnchor.constraint(equalTo: toolBar.checkMark.bottomAnchor, constant: cornerRadius),
            toolBar.editBounds.leftAnchor.constraint(equalTo: toolBar.checkMark.leftAnchor),
            toolBar.editBounds.widthAnchor.constraint(equalTo: toolBar.checkMark.heightAnchor),
            toolBar.editBounds.heightAnchor.constraint(equalTo: toolBar.checkMark.heightAnchor)
            ].forEach { (constraints) in
                constraints.isActive = true
        }
        toolBar.editBounds.isUserInteractionEnabled = true
        tap = UITapGestureRecognizer(target: self, action: #selector(handleResizeBounds))
        toolBar.editBounds.addGestureRecognizer(tap)
        
        //create fullview option
        if self.toolBar.subviews.contains(toolBar.fullView) == false {
            toolBar.addSubview(toolBar.fullView)
        }
        toolBar.fullView.translatesAutoresizingMaskIntoConstraints = false
        [
            toolBar.fullView.leftAnchor.constraint(equalTo: toolBar.checkMark.leftAnchor),
            toolBar.fullView.topAnchor.constraint(equalTo: toolBar.editBounds.bottomAnchor, constant: cornerRadius),
            toolBar.fullView.widthAnchor.constraint(equalTo: toolBar.checkMark.heightAnchor),
            toolBar.fullView.heightAnchor.constraint(equalTo: toolBar.checkMark.heightAnchor)
            ].forEach { (constratints) in
                constratints?.isActive = true
        }
        toolBar.fullView.isUserInteractionEnabled = true
        tap = UITapGestureRecognizer(target: self, action: #selector(showFullView))
        toolBar.fullView.addGestureRecognizer(tap)
        
        //create editmenu option
        if(toolBar.subviews.contains(toolBar.editMenu) == false){
            //            print("addes subview editMenuView")
            toolBar.addSubview(toolBar.editMenu)
        }
        toolBar.editMenu.translatesAutoresizingMaskIntoConstraints = false
        [
//            toolBar.editMenu.rightAnchor.constraint(equalTo: toolBar.rightAnchor, constant: -cornerRadius),
//            toolBar.editMenu.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor),
            toolBar.editMenu.leftAnchor.constraint(equalTo: toolBar.checkMark.leftAnchor),
            toolBar.editMenu.topAnchor.constraint(equalTo: toolBar.fullView.bottomAnchor, constant: cornerRadius),
            toolBar.editMenu.widthAnchor.constraint(equalTo: toolBar.checkMark.heightAnchor),
            toolBar.editMenu.heightAnchor.constraint(equalTo: toolBar.checkMark.heightAnchor)
            ].forEach { (constratints) in
                constratints?.isActive = true
        }
        toolBar.editMenu.isUserInteractionEnabled = true
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTapEditMenu))
        toolBar.editMenu.addGestureRecognizer(tap)
        
    }
    @objc private func handleCardCheckBoxTap(){
        card.isCompleted = !card.isCompleted
        layoutSubviews()
//        updatingCardDelegate?.nowUpdateCard(newCard: card, for: self)
    }
    @objc private func showFullView(){
        pageDelegate?.showFullCardView(for: self)
    }
    @objc private func handleTapEditMenu(){
        pageDelegate?.showCardEditView(for: self)
    }
    @objc private func handleResizeBounds(){
        print("in handlre resize bounds")
        isResizing = true
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
    //Set notes
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    var notesTextView = UITextView()
    private func configureNotesTextView(){
        if(self.subviews.contains(notesTextView)==false){
            addSubview(notesTextView)
        }
        notesTextView.font = UIFont.preferredFont(forTextStyle: .body)
        notesTextView.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: notesTextView.font!)
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        [
            notesTextView.topAnchor.constraint(equalTo: timeLable.bottomAnchor),
            notesTextView.leftAnchor.constraint(equalTo: toolBar.rightAnchor, constant: spacings),
            notesTextView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -cornerRadius)
            ,notesTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -spacings)
            ].forEach { (constraints) in
                constraints.isActive = true
        }
        
        //set offset from corners of notes
        notesTextView.textContainerInset = UIEdgeInsets(top: cornerRadius/2, left: cornerRadius/2, bottom: cornerRadius/2, right: cornerRadius/2)
        notesTextView.layer.cornerRadius = cornerRadius/2
        notesTextView.autocorrectionType = UITextAutocorrectionType.no
        notesTextView.backgroundColor = noteColour
        notesTextView.isEditable = false
        notesTextView.text = card.notes
        
        //        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        //        drawingViewPreview.addGestureRecognizer(swipe)
    }
    
    //Set Checklist
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    var checkListTable = UITableView()
    func configureCheckListTable(){
        checkListTable.dataSource=self
        checkListTable.register(UITableViewCell.self, forCellReuseIdentifier: "cardCheckListCell")
        if(self.subviews.contains(checkListTable)==false){
            addSubview(checkListTable)
        }
        checkListTable.translatesAutoresizingMaskIntoConstraints = false
        [
            checkListTable.topAnchor.constraint(equalTo: timeLable.bottomAnchor),
            checkListTable.leftAnchor.constraint(equalTo: toolBar.rightAnchor, constant: spacings),
            checkListTable.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -cornerRadius),
            checkListTable.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -spacings)
            ].forEach { (constraints) in
                constraints.isActive = true
        }
        checkListTable.allowsSelection = false
        checkListTable.layer.cornerRadius = cornerRadius
        //        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        //        drawingViewPreview.addGestureRecognizer(swipe)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return card.checkList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("checklist length= \(card.checkList.count)")
//        print("trying to access= \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCheckListCell", for: indexPath)
        cell.textLabel?.text = card.checkList[indexPath.row].title
        if(card.checkList[indexPath.row].isCompleted!){
            cell.imageView?.image =  UIImage(systemName: "largecircle.fill.circle")
        }else{
            cell.imageView?.image = UIImage(systemName: "circle")
        }
        cell.imageView?.isUserInteractionEnabled=true
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        cell.textLabel?.textColor = UIColor(named: "subMainTextColor") ?? UIColor.red
        let tap = myTapRecogniser(target: self, action: #selector(toggleCheckBox(sender:)))
        tap.indexPath = indexPath
        cell.imageView?.addGestureRecognizer(tap)
        //        print("returning cell")
        return cell
    }
    @objc func toggleCheckBox(sender: myTapRecogniser){
        print(sender.index)
        card.checkList[sender.indexPath!.row].isCompleted = !card.checkList[sender.indexPath!.row].isCompleted!
        self.checkListTable.reloadRows(at: [sender.indexPath!], with: UITableView.RowAnimation.automatic)
//        self.updatingCardDelegate?.updateCardbutNoRelayout(newCard: card)
    }
    class myTapRecogniser: UITapGestureRecognizer {
        var indexPath: IndexPath?
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.card.checkList.remove(at: indexPath.row)
//            self.updatingCardDelegate?.updateCardbutNoRelayout(newCard: card)
            self.checkListTable.deleteRows(at: [indexPath], with: .automatic)
//            self.updatingCardDelegate?.updateCardbutNoRelayout(newCard: card)
            print("deleted")
        }
    }
    
    //Set Drawing
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    var drawingViewPreview = customDrawingPreviewView()
    private func configureDrawingviewPreview(){
        if(self.subviews.contains(drawingViewPreview) == false){
            addSubview(drawingViewPreview)
        }
        drawingViewPreview.clipsToBounds = true
        drawingViewPreview.layer.cornerRadius = cornerRadius
        drawingViewPreview.translatesAutoresizingMaskIntoConstraints = false
        [
            drawingViewPreview.topAnchor.constraint(equalTo: timeLable.bottomAnchor),
            drawingViewPreview.leftAnchor.constraint(equalTo: toolBar.rightAnchor, constant: spacings),
            drawingViewPreview.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -cornerRadius),
            drawingViewPreview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -spacings)
            ].forEach { (constraints) in
                constraints.isActive = true
        }
        drawingViewPreview.drawingImage.contentMode = .scaleAspectFit
        if(drawingViewPreview.subviews.contains(drawingViewPreview.backgroundImageView)==false){
            drawingViewPreview.addSubview(drawingViewPreview.backgroundImageView)
        }
        drawingViewPreview.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        [
            (drawingViewPreview.backgroundImageView.leadingAnchor.constraint(equalTo: drawingViewPreview.safeAreaLayoutGuide.leadingAnchor)),
            drawingViewPreview.backgroundImageView.trailingAnchor.constraint(equalTo: drawingViewPreview.safeAreaLayoutGuide.trailingAnchor),
            drawingViewPreview.backgroundImageView.topAnchor.constraint(equalTo: drawingViewPreview.safeAreaLayoutGuide.topAnchor),
            drawingViewPreview.backgroundImageView.bottomAnchor.constraint(equalTo: drawingViewPreview.safeAreaLayoutGuide.bottomAnchor)
            ].forEach { (constraints) in
                constraints.isActive = true
        }
        drawingViewPreview.backgroundImageView.image = UIImage(named: "defaultDrawingImage")
        
        if(drawingViewPreview.subviews.contains(drawingViewPreview.drawingImage)==false){
            drawingViewPreview.addSubview(drawingViewPreview.drawingImage)
        }
        drawingViewPreview.drawingImage.translatesAutoresizingMaskIntoConstraints = false
        [
            (drawingViewPreview.drawingImage.leadingAnchor.constraint(equalTo: drawingViewPreview.safeAreaLayoutGuide.leadingAnchor)),
            drawingViewPreview.drawingImage.trailingAnchor.constraint(equalTo: drawingViewPreview.safeAreaLayoutGuide.trailingAnchor),
            drawingViewPreview.drawingImage.topAnchor.constraint(equalTo: drawingViewPreview.safeAreaLayoutGuide.topAnchor),
            drawingViewPreview.drawingImage.bottomAnchor.constraint(equalTo: drawingViewPreview.safeAreaLayoutGuide.bottomAnchor)
            ].forEach { (constraints) in
                constraints.isActive = true
        }
        
//        drawingViewPreview.drawingImage.image = card.savedpkDrawing.image(from: card.savedpkDrawing.bounds , scale: 1.0)
        //MARK: PKData attempt
        do {
            let d = try PKDrawing.init(data: card.savedPKData)
            drawingViewPreview.drawingImage.image = d.image(from: d.bounds, scale: 1.0)
            print("succesfully did set pkd")
        } catch  {
            print("error trying to initilise pkd from data")
        }
        
        //        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        //        drawingViewPreview.addGestureRecognizer(swipe)
        
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //    @objc private func didSwipe(_ gestureRecognizer : UISwipeGestureRecognizer){
    ////        print(did swipe \())
    //        print("did swiped: \(gestureRecognizer.direction)")
    //        if gestureRecognizer.state == .ended{
    //            if gestureRecognizer.direction == .left{
    //                switch card.type {
    //                case .CheckList:
    //                    card.type = .Drawing
    //                case .Drawing:
    //                    card.type = .Notes
    //                case .Notes:
    //                    card.type = .CheckList
    //                }
    //                updatingCardDelegate?.nowUpdateCard(newCard: card, for: self)
    //            }else if gestureRecognizer.direction == .right{
    //                switch card.type {
    //                case .CheckList:
    //                    card.type = .Notes
    //                case .Drawing:
    //                    card.type = .CheckList
    //                case .Notes:
    //                    card.type = .Drawing
    //                }
    //                updatingCardDelegate?.nowUpdateCard(newCard: card, for: self)
    //            }
    //        }
    //    }
    
    
    override func layoutSubviews() {
        self.layer.backgroundColor = cardColour.cgColor
        self.layer.cornerRadius = cornerRadius
        //Draw shaddow for layer
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.2
        
//        self.layer.masksToBounds=true
        if(isResizing){
            return
        }
        print("removes all subview in layoutsubviews to relayout all subviews")
        self.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        configureToolbar()
        configureHeadingLabel()
        configureTimeLabel()
        switch card.type {
        case .CheckList:
            checkListTable.reloadData()
            configureCheckListTable()
        case .Drawing:
            configureDrawingviewPreview()
        case .Notes:
            configureNotesTextView()
        }
//        layoutResizeBoundsView()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        configureHeadingLabel()
        configureToolbar()
        switch card.type {
        case .CheckList:
            print("yet to implement checklistview")
            configureCheckListTable()
        case .Drawing:
            print("yet to implement drawingviewpreviw")
            configureDrawingviewPreview()
        case .Notes:
            configureNotesTextView()
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
//        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
//        roundedRect.addClip()
//        cardColour.setFill()
//        roundedRect.fill()
//        self.layer.masksToBounds=true
    }
    
    //Make view resizable
    var isResizing = false
    enum Edge {
        case topLeft, topRight, bottomLeft, bottomRight, bottom, top, left, right, none
    }
    static var edgeSize: CGFloat = 44.0
    var currentEdge: Edge = .none
    var touchStart = CGPoint.zero
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        joiningViewsDelegate?.joinMe(with: self, forID: self.card.UniquIdentifier!)
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
//            if let page = superview as? PageView{
//                page.setNeedsDisplay()
//            }
            pageDelegate?.reloadLine(with: self.card.UniquIdentifier, animated: false)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isResizing{
            print("ended")
            if let scrollView = superview?.superview as? UIScrollView {
                scrollView.panGestureRecognizer.isEnabled = true
                scrollView.pinchGestureRecognizer?.isEnabled = true
            }
            isResizing=false
//            var minwidth =  self.toolBar.subviews[0].bounds.width+cornerRadius
//            minwidth *= 7
//            if frame.width < minwidth{
//                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: minwidth, height: self.frame.height)
//            }
//            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: max(minwidth, self.frame.width), height: max(self.frame.height, minCardHeight))
//            self.subviews.forEach { (sv) in
//                            sv.isHidden = false
//                sv.isUserInteractionEnabled = true
//            }
            let minwidth =  checkBoxDimensions*4
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: max(minwidth, self.frame.width), height: max(self.frame.height, checkBoxDimensions*4+cornerRadius*5))
            self.subviews.forEach { (sv) in
                sv.isHidden = false
                sv.isUserInteractionEnabled = true
            }
            //TODO: make more strong conditions for this else well as elsewhere this is used
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
//            updatingCardDelegate?.nowUpdateCard(newCard: card, for: self)
            layoutSubviews()
            pageDelegate?.changeContentSize(using: self)
            currentEdge = .none
//            if let page = superview as? PageView{
//                page.setNeedsDisplay()
//            }
            pageDelegate?.reloadLine(with: self.card.UniquIdentifier, animated: false)
        }
    }
    
}

extension cardView{
    var cornerRadius: CGFloat {
        return 10
//        return bounds.size.height * 0.03
    }
    var spacings:CGFloat {
        return 15
    }
    var checkBoxDimensions: CGFloat{
        return 30
    }
    var cardColour: UIColor{
        return UIColor(named: "bigCardColor") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
    var noteColour: UIColor{
        return #colorLiteral(red: 0.9839849829, green: 0.9880542423, blue: 0.9669427433, alpha: 1)
    }
    var resizeBoundsColor: UIColor{
        return #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 0.4511993838)
    }
    var toolBarHeight: CGFloat{
        return bounds.size.height * 0.1
    }
    var minCardHeight: CGFloat{
        return 80
    }
    var toolBarToUpperViewSafeDistance: CGFloat{
        return bounds.size.height * 0.03/2
    }
    var completedCardOpacity: CGFloat{
        return 0.5
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        card.Heading = headingTextField.text
//        self.updatingCardDelegate?.nowUpdateCard(newCard: card, for: self)
        return true
    }
}

class toolBarView: UIView{
    var editMenu: UIImageView = UIImageView(image: UIImage(systemName: "ellipsis.circle"));
    var reminderClock: UIImageView = UIImageView(image: UIImage(systemName: "clock"));
    var checkMark: UIImageView = UIImageView(image: UIImage(systemName: "checkmark.square"));
    var fullView  = UIImageView(image: UIImage(systemName: "chevron.down"));
    var editBounds = UIImageView(image: UIImage(systemName: "crop"));
}
class customDrawingPreviewView: UIView{
    var drawingImage: UIImageView = UIImageView()
    var backgroundImageView: UIImageView = UIImageView(image: UIImage(named: "defaultDrawingImage"))
}

