//
//  addHabbitTargetDateTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class addHabbitTargetDateTableViewCell: UITableViewCell {
var delegate: addHabiitVCProtocol?
    var targetDate: Date?
    var index = IndexPath(row: 0, section: 0)
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerHeightAnchor: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        if targetDate==nil{
            datePickerHeightAnchor.constant=0
            switchButton.setOn(false, animated: false)
            delegate?.updated(indexpath: index)
        }else{
            datePickerHeightAnchor.constant=150
            switchButton.setOn(true, animated: false)
            delegate?.updated(indexpath: index)
        }
        // Initialization code
    }

    @IBAction func switchButtonClick(_ sender: UISwitch) {
        if sender.isOn{
            datePickerHeightAnchor.constant=150
            switchButton.setOn(true, animated: false)
            delegate?.setHabitTargetDate(datePicker.date)
            delegate?.updated(indexpath: index)
        }else{
            datePickerHeightAnchor.constant=0
            switchButton.setOn(false, animated: false)
            delegate?.setHabitTargetDate(nil)
            delegate?.updated(indexpath: index)
        }
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        delegate?.setHabitTargetDate(datePicker.date)
    }
    
}
