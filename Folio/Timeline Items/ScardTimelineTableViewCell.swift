//
//  ScardTimelineTableViewCell.swift
//  card2
//
//  Created by Kshitiz Sharma on 30/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//
//TODO: save the changed data
import UIKit
//protocol updateSmallCardFromCell{
//    func newValuesFor(card: SmallCard, isDone: Bool, titleText: String, notesText: String)
//}

class ScardTimelineTableViewCell: UITableViewCell {

    var delegate: myUpdateCellHeightDelegate?
    var card: SmallCard?{
        didSet{
            if (card?.title.count ?? 0)>0{
                title = card?.title ?? titlePlaceHolder
            }
            if (card?.notes.count ?? 0)>0{
                notes = card?.notes ?? notesPlaceHolder
            }
            isDone = card?.isDone ?? false
        }
    }
//    var updateCardDelegate: updateSmallCardFromCell?
    var showLinkDelegate: timelineSwitchDelegate?
    var sizeType = cardSizeMode.full
    var baseHeight: CGFloat = 40
    var row = 0
    var indexpath = IndexPath(row: 0, section: 0)
    var isDone = false
    var title = ""
    var notes = ""
    lazy var constr  = notesTextView.heightAnchor.constraint(equalToConstant: 0)
    
    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var linkView: UIImageView!{
        didSet{
            linkView.isUserInteractionEnabled=true
            linkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLinkViewTap)))
        }
    }
    @IBOutlet weak var titleTextView: UITextView!{
        didSet{
            titleTextView.delegate=self
        }
    }
    var titlePlaceHolder = "Title"
    @IBOutlet weak var notesTextView: UITextView!{
        didSet{
            notesTextView.delegate=self
        }
    }
    var notesPlaceHolder = "Notes"
    @IBOutlet weak var reminderLabel: UILabel!
    @objc func handleCheckBoxTap(){
        self.isDone = !self.isDone
        print("changed is done")
        awakeFromNib()
        self.updateCard()
    }
    @objc func handleLinkViewTap(){
        print("yet to implement did tap linkview")
        showLinkDelegate!.switchToPageAndShowCard(with: card!.UniquIdentifier)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius=cornerRadius
        if isDone{
            checkBox.image = UIImage(systemName: "largecircle.fill.circle")
        }else{
            checkBox.image = UIImage(systemName: "circle")
        }
        self.checkBox.isUserInteractionEnabled=true
        self.checkBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCheckBoxTap)))
        titleTextView.text = title
        notesTextView.text = notes
        if titleTextView.text.count==0{
            titleTextView.text = titlePlaceHolder
            titleTextView.textColor = UIColor.lightGray
        }else{
            titleTextView.textColor = UIColor.black
        }
        
        switch self.sizeType {
        case .full:
            constr.isActive=false
            if notesTextView.text.count==0{
                notesTextView.text = notesPlaceHolder
                notesTextView.textColor = UIColor.lightGray
            }else{
                notesTextView.textColor = UIColor.darkGray
            }
        case .medium:
            constr.isActive=true
        case .small:
            constr.isActive=true
        }
        setReminderLabe()
    }
    private func setReminderLabe(){
        if let sCard = card{
            if let time=sCard.reminderDate{
                reminderLabel.isHidden=false
                let formatter = DateFormatter()
                formatter.dateFormat = "d/M/yy, hh:mm a"
                reminderLabel.text = formatter.string(from: time)
                formatter.dateFormat = "d/M/yy"
                if(formatter.string(from: time)==formatter.string(from: Date()) ){
                    if(sCard.isDone){
                        reminderLabel.textColor = UIColor.systemGreen
                    }else{
                        reminderLabel.textColor = UIColor.systemOrange
                    }
                }else if(time<Date()){
                    reminderLabel.textColor = UIColor.systemRed
                    if(sCard.isDone){
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
        print("yet to implement updateCard")
//        updateCardDelegate!.newValuesFor(card: card!, isDone: isDone, titleText: self.title, notesText: self.notes)
    }
}
extension ScardTimelineTableViewCell: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if titleTextView.textColor == UIColor.lightGray, textView.frame==titleTextView.frame {
            titleTextView.text=""
            titleTextView.textColor = UIColor.black
        }
        if notesTextView.textColor == UIColor.lightGray, notesTextView.frame==textView.frame{
            notesTextView.text=""
            notesTextView.textColor = UIColor.darkGray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        title=titleTextView.text
        notes=notesTextView.text
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
        if notesTextView.textColor != UIColor.lightGray{
            if notesTextView.text.count==0{
                notesTextView.text = notesPlaceHolder
                notesTextView.textColor = UIColor.lightGray
            }
        }
        self.updateCard()
    }
    
}
extension ScardTimelineTableViewCell{
    var cornerRadius: CGFloat{
        return 20
    }
}
