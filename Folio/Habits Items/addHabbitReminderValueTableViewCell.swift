//
//  addHabbitReminderValueTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class addHabbitReminderValueTableViewCell: UITableViewCell {
var delegate: addHabiitVCProtocol?
    var reminderValue = habitCardData.ReminderTime.notSet
    override func awakeFromNib() {
        super.awakeFromNib()
        switch reminderValue{
        case .notSet:
            switchButton.setOn(false, animated: false)
            segment.isUserInteractionEnabled=false
            segment.layer.opacity = 0.5
        default:
            switchButton.setOn(true, animated: false)
            segment.isUserInteractionEnabled=true
            segment.layer.opacity = 1.0
        }
        // Initialization code
    }
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var switchButton: UISwitch!
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn{
            segment.isUserInteractionEnabled=true
            segment.layer.opacity = 1.0
            switch segment.selectedSegmentIndex {
            case 0:
                delegate?.setReminderValue(.morning)
            case 1:
                delegate?.setReminderValue(.noon)
            case 2:
                delegate?.setReminderValue(.night)
            case 3:
                delegate?.setReminderValue(.fifteenMinute)
            case 4:
                delegate?.setReminderValue(.oneHour)
            default:
                print("ERROR: unhandled index in addHabbitReminderValueTableViewCell")
            }
        }else{
            delegate?.setReminderValue(.notSet)
            segment.isUserInteractionEnabled=false
            segment.layer.opacity = 0.5
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            delegate?.setReminderValue(.morning)
        case 1:
            delegate?.setReminderValue(.noon)
        case 2:
            delegate?.setReminderValue(.night)
        case 3:
            delegate?.setReminderValue(.fifteenMinute)
        case 4:
            delegate?.setReminderValue(.oneHour)
        default:
            print("ERROR: unhandled index in addHabbitReminderValueTableViewCell")
        }
    }

}
