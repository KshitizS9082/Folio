//
//  ExpandableTextSCardInfoTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 05/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class ExpandableTextSCardInfoTableViewCell: UITableViewCell {
    var index = IndexPath(row: 0, section: 0)
    var delegate: newSmallCardInfoVCProtocol?
//    var placheHolderText = "Text"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextView: UITextView!{
        didSet{
            inputTextView.delegate=self
            inputTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
            inputTextView.layer.borderWidth = 0.5
            inputTextView.layer.borderColor = UIColor.systemGray.cgColor
            inputTextView.layer.cornerRadius = 5.0
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc func tapDone(sender: Any) {
        self.endEditing(true)
    }
    @IBOutlet weak var heightToTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var distToBottomConstraint: NSLayoutConstraint!
    
}
extension ExpandableTextSCardInfoTableViewCell: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        delegate?.updated(indexpath: index)
        switch self.index.row {
        case 0:
            delegate?.updateTitle(to: inputTextView.text)
        case 1:
            delegate?.updateNotes(to: inputTextView.text)
        case 2:
            delegate?.updateURL(to: inputTextView.text)
        case 4:
            delegate?.updateDetailedNotes(to: inputTextView.text)
        default:
            print("not handled ")
        }
//        let height = textView.newHeight(withBaseHeight: baseHeight)
//        delegate?.updated(height: height, row: rowValue)
    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if(inputTextView.text.count==0){
//            inputTextView.textColor = UIColor.gray
//            inputTextView.text = placheHolderText
//        }
//    }
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        if inputTextView.textColor == UIColor.gray{
//            inputTextView.textColor = UIColor.black
//            inputTextView.text = ""
//        }
//        return true
//    }
}
