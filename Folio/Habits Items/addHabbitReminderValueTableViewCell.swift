//
//  addHabbitReminderValueTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import UserNotifications

class addHabbitReminderValueTableViewCell: UITableViewCell {
    var delegate: addHabiitVCProtocol?
    var firstReminderDate = Date()
    var index = IndexPath(row: 0, section: 0)
    var reminderValue = habitCardData.ReminderTime.notSet
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        switch reminderValue{
        case .notSet:
            switchButton.setOn(false, animated: false)
            segment.isUserInteractionEnabled=false
            segment.layer.opacity = 0.5
            datePickerHeightConstraint.constant=0
        default:
            switchButton.setOn(true, animated: false)
            segment.isUserInteractionEnabled=true
            segment.layer.opacity = 1.0
            datePickerHeightConstraint.constant=125
        }
        delegate?.updated(indexpath: index)
        datePicker.minimumDate = Date()
        datePicker.date=firstReminderDate
        // Initialization code
    }
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var switchButton: UISwitch!
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        
        firstReminderDate = datePicker.date
        if sender.isOn{
            let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
            if notificationType == [] {
                print("notifications are NOT enabled")
                sender.setOn(false, animated: true)
                delegate?.setReminderValue(.notSet, firstDate: nil)
                delegate?.showNotificationNotPresentAlert()
                return
            } else {
                print("notifications are enabled")
            }
            datePickerHeightConstraint.constant=125
            segment.isUserInteractionEnabled=true
            segment.layer.opacity = 1.0
            switch segment.selectedSegmentIndex {
            case 0:
                delegate?.setReminderValue(.daily, firstDate: firstReminderDate)
            case 1:
                delegate?.setReminderValue(.weekly, firstDate: firstReminderDate)
            case 2:
                delegate?.setReminderValue(.monthly, firstDate: firstReminderDate)
            case 3:
                delegate?.setReminderValue(.yearly, firstDate: firstReminderDate)
            default:
                print("ERROR: unhandled index in addHabbitReminderValueTableViewCell")
            }
        }else{
            datePickerHeightConstraint.constant=0
            delegate?.setReminderValue(.notSet, firstDate: nil)
            segment.isUserInteractionEnabled=false
            segment.layer.opacity = 0.5
        }
        delegate?.updated(indexpath: index)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        firstReminderDate = datePicker.date
        switch sender.selectedSegmentIndex {
        case 0:
            delegate?.setReminderValue(.daily, firstDate: firstReminderDate)
        case 1:
            delegate?.setReminderValue(.weekly, firstDate: firstReminderDate)
        case 2:
            delegate?.setReminderValue(.monthly, firstDate: firstReminderDate)
        case 3:
            delegate?.setReminderValue(.yearly, firstDate: firstReminderDate)
        default:
            print("ERROR: unhandled index in addHabbitReminderValueTableViewCell")
        }
    }
    @IBAction func datePickerDidChange(_ sender: UIDatePicker) {
        firstReminderDate = datePicker.date
        switch segment.selectedSegmentIndex {
        case 0:
            delegate?.setReminderValue(.daily, firstDate: firstReminderDate)
        case 1:
            delegate?.setReminderValue(.weekly, firstDate: firstReminderDate)
        case 2:
            delegate?.setReminderValue(.monthly, firstDate: firstReminderDate)
        case 3:
            delegate?.setReminderValue(.yearly, firstDate: firstReminderDate)
        default:
            print("ERROR: unhandled index in addHabbitReminderValueTableViewCell")
        }
    }
    
}
