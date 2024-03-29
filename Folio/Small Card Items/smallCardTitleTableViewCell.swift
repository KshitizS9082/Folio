//
//  smallCardTitleTableViewCell.swift
//  card2
//
//  Created by Kshitiz Sharma on 15/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class smallCardTitleTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var titleText: UITextView!
    var baseHeight: CGFloat = 40
    var rowValue = 0
    var placheHolderText = "Text"
    var delegate: ExpandingCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleText.delegate = self
        titleText.font = UIFont.preferredFont(forTextStyle: .body)
        titleText.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
    }
    func setHeight(){
        let height = titleText.newHeight(withBaseHeight: baseHeight)
        delegate?.updated(height: height, row: rowValue)
    }
    @objc func tapDone(sender: Any) {
        self.endEditing(true)
    }
}

extension smallCardTitleTableViewCell{
    func textViewDidChange(_ textView: UITextView) {
        let height = textView.newHeight(withBaseHeight: baseHeight)
        delegate?.updated(height: height, row: rowValue)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if(titleText.text.count==0){
            titleText.textColor = UIColor.gray
            titleText.text = placheHolderText
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if titleText.textColor == UIColor.gray{
            titleText.textColor = UIColor.black
            titleText.text = ""
        }
        return true
    }
}
