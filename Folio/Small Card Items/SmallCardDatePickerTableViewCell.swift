//
//  SmallCardDatePickerTableViewCell.swift
//  card2
//
//  Created by Kshitiz Sharma on 17/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
protocol DatePickerTableViewCellDelegate: class {
    func dateChangedTo(toDate date: Date)
}
class SmallCardDatePickerTableViewCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
     var rowValue = 0
    weak var delegate: DatePickerTableViewCellDelegate?
    var updateHeightDelegate: ExpandingCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureWithCard(scard: SmallCard, currentDate: Date?) {
        self.datePicker.date = currentDate ?? Date()
        let newFrame=datePicker.sizeThatFits(self.frame.size)
        updateHeightDelegate.updated(height: newFrame.height, row: rowValue)
    }

    @IBAction func datePickerChangedValue(_ sender: UIDatePicker) {
         self.delegate?.dateChangedTo(toDate: datePicker.date)
        let newFrame=datePicker.sizeThatFits(self.frame.size)
         updateHeightDelegate.updated(height: newFrame.height, row: rowValue)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
