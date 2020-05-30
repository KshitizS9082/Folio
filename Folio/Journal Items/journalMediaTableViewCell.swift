//
//  journalMediaTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 30/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class journalMediaTableViewCell: UITableViewCell, UITextViewDelegate{
    var index = IndexPath(row: 0, section: 0)
    var delegate: addCardInJournalProtocol?
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!{
        didSet{
            notesLabel.isUserInteractionEnabled=true
            notesLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelctTextView)))
        }
    }
    @IBOutlet weak var notesIsEditingTextView: UITextView!{
        didSet{
            notesIsEditingTextView.delegate=self
            notesIsEditingTextView.isHidden=true
        }
    }
    @IBOutlet weak var mediaImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mediaImageView.tintColor = ivTintColor
        self.mediaImageView.layer.cornerRadius=ivCornerRadius
        self.mediaImageView.isUserInteractionEnabled=true
        self.mediaImageView.contentMode = .scaleAspectFill
        self.mediaImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getImage)))
    }
    @objc func didSelctTextView() {
        print("didselect in setSelected")
        notesIsEditingTextView.isHidden=false
        notesIsEditingTextView.font = notesLabel.font
        notesIsEditingTextView.text = notesLabel.text
        notesIsEditingTextView.becomeFirstResponder()
    }
    @objc func showImage(){
        print("show image")
    }
    @objc func getImage(){
        delegate?.getJournalMedia(at: index)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        notesLabel.text = notesIsEditingTextView.text
        notesLabel.isHidden=false
        notesIsEditingTextView.isHidden=true
//        delegate?.updateJournalNotesEntry(at: index, with:  notesIsEditingTextView.text)
        delegate?.updateJournalMediasNotesEntry(at: index, with: notesIsEditingTextView.text)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text=="\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
extension journalMediaTableViewCell{
    var ivTintColor: UIColor{
        return UIColor(named: "subMainTextColor") ?? UIColor.red
    }
    var ivCornerRadius: CGFloat{
        return 15
    }
}

