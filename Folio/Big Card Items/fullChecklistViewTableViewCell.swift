//
//  fullChecklistViewTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 06/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class fullChecklistViewTableViewCell: UITableViewCell, UITextViewDelegate {
    var index = IndexPath(row: 0, section: 0)
    var delegate: newCheckListFullVCProtocol?
    var item = checkListItem()
    
    @IBOutlet weak var doneImageView: UIImageView!{
        didSet{
            doneImageView.tintColor = .systemTeal
            doneImageView.isUserInteractionEnabled=true
            doneImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDoneTap)))
        }
    }
    @objc func handleDoneTap(){
        item.isCompleted = !item.isCompleted!
        self.awakeFromNib()
        delegate?.updateCheckListItem(to: item, at: index)
    }
    
    @IBOutlet weak var titleTextView: UITextView!{
        didSet{
            titleTextView.delegate=self
            self.titleTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        }
    }
    @objc func tapDone(sender: Any) {
        self.endEditing(true)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleTextView.text=item.title
        self.backgroundColor = .clear
        if item.isCompleted ?? false{
            doneImageView.image = UIImage(systemName: "largecircle.fill.circle")
        }else{
            doneImageView.image = UIImage(systemName: "circle")
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        delegate?.updated(indexpath: index)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        item.title=titleTextView.text
        delegate?.updateCheckListItem(to: item, at: index)
    }

}
