//
//  journalNotesTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 30/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class journalNotesTableViewCell: UITableViewCell, UITextViewDelegate {
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
    
    @IBOutlet weak var cardBackgroundView: UIView!{
        didSet{
            cardBackgroundView.layer.cornerRadius = 10
            //Draw shaddow for layer
            cardBackgroundView.layer.shadowColor = UIColor.gray.cgColor
            cardBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cardBackgroundView.layer.shadowRadius = 5.0
            cardBackgroundView.layer.shadowOpacity = 0.2
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var showFullViewImageView: UIImageView!{
        didSet{
            showFullViewImageView.isUserInteractionEnabled=true
            showFullViewImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFullJournal)))
        }
    }
    @objc func showFullJournal(){
        delegate?.showJournalFullView(at: index)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        print("didselect in setSelected")
//        notesIsEditingTextView.isHidden=false
//        notesIsEditingTextView.font = notesLabel.font
//        notesIsEditingTextView.text = notesLabel.text
//        notesIsEditingTextView.becomeFirstResponder()
    }
    @objc func didSelctTextView() {
        print("didselect in setSelected")
        notesIsEditingTextView.isHidden=false
        notesIsEditingTextView.font = notesLabel.font
        notesIsEditingTextView.text = notesLabel.text
        notesIsEditingTextView.becomeFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        notesLabel.text = notesIsEditingTextView.text
        notesLabel.isHidden=false
        notesIsEditingTextView.isHidden=true
        delegate?.updateJournalNotesEntry(at: index, with:  notesIsEditingTextView.text)
//        notesIsEditingTextView.resignFirstResponder()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text=="\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

