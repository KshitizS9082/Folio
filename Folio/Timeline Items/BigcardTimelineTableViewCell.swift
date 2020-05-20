//
//  BigcardTimelineTableViewCell.swift
//  card2
//
//  Created by Kshitiz Sharma on 02/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import PencilKit
//protocol updateBigCardFromCell{
//    func newValuesFor(card: Card, isDone: Bool, titleText: String)
//}

class BigcardTimelineTableViewCell: UITableViewCell {
    
    var delegate: myUpdateCellHeightDelegate?
//    var updateCardDelegate: updateBigCardFromCell?
    var showLinkDelegate: timelineSwitchDelegate?
    var sizeType = cardSizeMode.full
    var card: Card?{
        didSet{
            if (card?.Heading?.count ?? 0)>0{
                title = card?.Heading ?? titlePlaceHolder
            }
            isDone = card?.isCompleted ?? false
        }
    }
    var baseHeight: CGFloat = 40
    var row = 0
    var indexpath = IndexPath(row: 0, section: 0)
    var isDone = false
    var title = ""
    @IBOutlet weak var reminderLabel: UILabel!
    
    
    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var titleTextView: UITextView!{
        didSet{
            titleTextView.delegate=self
        }
    }
    
    @IBOutlet weak var additionViewAspecRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var additionalView: UIView!{
        didSet{
            additionalView.layer.cornerRadius = cornerRadius
            additionalView.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
    var titlePlaceHolder = "Title"
    @objc func handleCheckBoxTap(){
        self.isDone = !self.isDone
        print("changed is done")
        awakeFromNib()
        self.updateCard()
        print("a b \(additionalView.bounds)")
        print("nt b \(notesTextView.bounds)")
    }
    @IBOutlet weak var linkView: UIImageView!{
        didSet{
            linkView.isUserInteractionEnabled=true
            linkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLinkViewTap)))
        }
    }
    @objc func handleLinkViewTap(){
        print("yet to implement did tap linkview bigcardtimelinecell")
        self.updateCard()
        showLinkDelegate!.switchToPageAndShowCard(with: (card!.UniquIdentifier))
    }
    lazy var constr  = additionalView.heightAnchor.constraint(equalToConstant: 0)
    override func awakeFromNib() {
        super.awakeFromNib()
        checkListTable.reloadData()
        self.layer.cornerRadius = cornerRadius
        if isDone{
            checkBox.image = UIImage(systemName: "largecircle.fill.circle")
        }else{
            checkBox.image = UIImage(systemName: "circle")
        }
        self.checkBox.isUserInteractionEnabled=true
        self.checkBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCheckBoxTap)))
        titleTextView.text = title
        if titleTextView.text.count==0{
            titleTextView.text = titlePlaceHolder
            titleTextView.textColor = UIColor.lightGray
        }else{
            titleTextView.textColor = UIColor.black
        }
        titleTextView.font = UIFont.preferredFont(forTextStyle: .headline)
        setReminderLabe()
        if self.sizeType == .full{
            constr.isActive=false
            setAdditionView()
        }else if self.sizeType == .medium{
            constr.isActive=true
        }else{
            constr.isActive=true
        }
    }
    
    private func setReminderLabe(){
        if let sCard = card{
            //TODO: set accroding to reminder or start time
            if let time=sCard.reminder{
                reminderLabel.isHidden=false
                let formatter = DateFormatter()
                formatter.dateFormat = "d/M/yy, hh:mm a"
                reminderLabel.text = formatter.string(from: time)
                formatter.dateFormat = "d/M/yy"
                if(formatter.string(from: time)==formatter.string(from: Date()) ){
                    if(sCard.isCompleted){
                        reminderLabel.textColor = UIColor.systemGreen
                    }else{
                        reminderLabel.textColor = UIColor.systemOrange
                    }
                }else if(time<Date()){
                    reminderLabel.textColor = UIColor.systemRed
                    if(sCard.isCompleted){
                        reminderLabel.textColor = UIColor.systemGray2
                    }else{
                        reminderLabel.textColor = UIColor.systemRed
                    }
                }else{
                    reminderLabel.textColor = UIColor.systemGray2
                }
            }else{
                reminderLabel.text = nil
                reminderLabel.isHidden=true
            }
        }
    }
    
    
    private func setAdditionView(){
        switch card?.type {
        case .CheckList:
            print("cc case")
            setChecklist()
        case .Drawing:
            print("drawing case")
            setDrawingviewPreview()
        case .Notes:
            print("notes case")
            setNotes()
        default:
            print("not identified case, errorline-84")
        }
    }
    var notesTextView = UITextView()
    private func setNotes(){
        if additionalView.subviews.contains(notesTextView)==false{
            additionalView.addSubview(notesTextView)
        }
        notesTextView.translatesAutoresizingMaskIntoConstraints=false
        [
            notesTextView.topAnchor.constraint(equalTo: additionalView.topAnchor),
            notesTextView.bottomAnchor.constraint(equalTo: additionalView.bottomAnchor),
            notesTextView.leftAnchor.constraint(equalTo: additionalView.leftAnchor),
            notesTextView.rightAnchor.constraint(equalTo: additionalView.rightAnchor),
            ].forEach { (cst) in
                cst.isActive=true
        }
        notesTextView.text = card?.notes
        notesTextView.isEditable=false
        notesTextView.font = UIFont.preferredFont(forTextStyle: .caption1)
        additionalView.bringSubviewToFront(notesTextView)
    }
    
    var checkListTable = UITableView()
    private func setChecklist(){
//        card?.checkList.append(checkListItem(isCompleted: true, title: "1", notes: "dfsad", url: nil))
//        card?.checkList.append(checkListItem(isCompleted: true, title: "22222222222222222", notes: "dfsad", url: nil))
//        card?.checkList.append(checkListItem(isCompleted: false, title: "3", notes: "dfsad", url: nil))
//        card?.checkList.append(checkListItem(isCompleted: true, title: "1", notes: "dfsad", url: nil))
//        card?.checkList.append(checkListItem(isCompleted: true, title: "22222222222222222", notes: "dfsad", url: nil))
//        card?.checkList.append(checkListItem(isCompleted: false, title: "3", notes: "dfsad", url: nil))
        checkListTable.dataSource=self
        checkListTable.register(UITableViewCell.self, forCellReuseIdentifier: "cardCheckListCell")
        if additionalView.subviews.contains(checkListTable)==false{
            additionalView.addSubview(checkListTable)
        }
        checkListTable.translatesAutoresizingMaskIntoConstraints=false
        [
            checkListTable.topAnchor.constraint(equalTo: additionalView.topAnchor),
            checkListTable.bottomAnchor.constraint(equalTo: additionalView.bottomAnchor),
            checkListTable.leftAnchor.constraint(equalTo: additionalView.leftAnchor),
            checkListTable.rightAnchor.constraint(equalTo: additionalView.rightAnchor),
            ].forEach { (cst) in
                cst.isActive=true
        }
        checkListTable.allowsSelection = false
        checkListTable.layer.cornerRadius = cornerRadius
        additionalView.bringSubviewToFront(checkListTable)
    }
    
    var drawingViewPreview = customDrawingPreviewView()
    private func setDrawingviewPreview(){
        if additionalView.subviews.contains(drawingViewPreview)==false{
            additionalView.addSubview(drawingViewPreview)
        }
        drawingViewPreview.translatesAutoresizingMaskIntoConstraints=false
        [
            drawingViewPreview.topAnchor.constraint(equalTo: additionalView.topAnchor),
            drawingViewPreview.bottomAnchor.constraint(equalTo: additionalView.bottomAnchor),
            drawingViewPreview.leftAnchor.constraint(equalTo: additionalView.leftAnchor),
            drawingViewPreview.rightAnchor.constraint(equalTo: additionalView.rightAnchor),
            ].forEach { (cst) in
                cst.isActive=true
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
//        drawingViewPreview.drawingImage.image = card?.savedpkDrawing.image(from: (card?.savedpkDrawing.bounds)! , scale: 1.0)
        //MARK: PKData attempt
        if let crd = card{
            do {
                let d = try PKDrawing.init(data: crd.savedPKData)
                drawingViewPreview.drawingImage.image = d.image(from: d.bounds, scale: 1.0)
                print("succesfully did set pkd")
            } catch  {
                print("error trying to initilise pkd from data")
            }
        }

    }
    func updateHeight(){
        var maxy = baseHeight-6
        for sv in self.subviews{
            if sv.bounds.maxY > maxy{
                maxy = sv.bounds.maxY
            }
        }
        let height = maxy + 6
        delegate?.updated(height: height, row: row, indexpath: indexpath)
    }
    func updateCard(){
        print("yet to implement update bigcard")
//        updateCardDelegate!.newValuesFor(card: card!, isDone: isDone, titleText: title)
        card?.isCompleted=self.isDone
        card?.Heading=self.titleTextView.text
        delegate?.saveBigCard(with: card!)
        
    }
}

extension BigcardTimelineTableViewCell: UITextViewDelegate{
     func textViewDidBeginEditing(_ textView: UITextView) {
            if titleTextView.textColor == UIColor.lightGray, textView.frame==titleTextView.frame {                titleTextView.text=""
                titleTextView.textColor = UIColor.black
            }
        }
        func textViewDidChange(_ textView: UITextView) {
            title=titleTextView.text
            updateHeight()
        }
        func textViewDidEndEditing(_ textView: UITextView) {
            print("didennd")
            if titleTextView.textColor != UIColor.lightGray{
                if titleTextView.text.count==0{
                    titleTextView.text = titlePlaceHolder
                    titleTextView.textColor = UIColor.lightGray
                }
            }
            updateCard()
        }
        
}
//TODO: not properly tested, update checklist values after done deleting ,checking/unchecking etc.
extension BigcardTimelineTableViewCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return card?.checkList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("checklist length= \(String(describing: card?.checkList.count))")
        print("trying to access= \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCheckListCell", for: indexPath)
        cell.textLabel?.text = card!.checkList[indexPath.row].title
        if(card!.checkList[indexPath.row].isCompleted!){
            cell.imageView?.image =  UIImage(systemName: "largecircle.fill.circle")
        }else{
            cell.imageView?.image = UIImage(systemName: "circle")
        }
        cell.imageView?.isUserInteractionEnabled=true
        let tap = myTapRecogniser(target: self, action: #selector(toggleCheckBox(sender:)))
        tap.indexPath = indexPath
        cell.imageView?.addGestureRecognizer(tap)
        return cell
    }
    @objc func toggleCheckBox(sender: myTapRecogniser){
        print(sender.index)
        card!.checkList[sender.indexPath!.row].isCompleted = !card!.checkList[sender.indexPath!.row].isCompleted!
        self.checkListTable.reloadRows(at: [sender.indexPath!], with: UITableView.RowAnimation.automatic)
    }
    class myTapRecogniser: UITapGestureRecognizer {
        var indexPath: IndexPath?
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.card!.checkList.remove(at: indexPath.row)
            self.checkListTable.deleteRows(at: [indexPath], with: .automatic)
            print("deleted")
        }
    }
}

extension BigcardTimelineTableViewCell{
    var cornerRadius: CGFloat{
        return 20
    }
    
}
