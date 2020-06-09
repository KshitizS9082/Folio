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
    var weekDayArray = [true, true, true, true, true, true, true]
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
            stackViewHeightConstraint.constant=0
            stackViewVertSpaceToDateConstraint.constant=0
        default:
            switchButton.setOn(true, animated: false)
            segment.isUserInteractionEnabled=true
            segment.layer.opacity = 1.0
            datePickerHeightConstraint.constant=125
            switch segment.selectedSegmentIndex {
            case 0:
                stackViewHeightConstraint.constant=33
                stackViewVertSpaceToDateConstraint.constant=20
            default:
                stackViewHeightConstraint.constant=0
                stackViewVertSpaceToDateConstraint.constant=0
            }
        }
        delegate?.updated(indexpath: index)
        datePicker.minimumDate = Date()
        datePicker.date=firstReminderDate
        // Initialization code
    }
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var switchButton: UISwitch!
    
    @IBOutlet var weekdayButtons: [UIImageView]!{
        didSet{
            weekdayButtons.forEach { (iv) in
                iv.isUserInteractionEnabled=true
                iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleWeekDayButtonViewTap)))
            }
        }
    }
    
    @IBOutlet weak var stackViewVertSpaceToDateConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        
        firstReminderDate = datePicker.date
        if sender.isOn{
            let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
            if notificationType == [] {
                print("notifications are NOT enabled")
                sender.setOn(false, animated: true)
                delegate?.setReminderValue(.notSet, firstDate: nil, weekDays: weekDayArray)
                delegate?.showNotificationNotPresentAlert()
                return
            } else {
                print("notifications are enabled")
            }
            datePickerHeightConstraint.constant=125
            segment.isUserInteractionEnabled=true
            segment.layer.opacity = 1.0
            stackViewHeightConstraint.constant=0
            stackViewVertSpaceToDateConstraint.constant=0
            switch segment.selectedSegmentIndex {
            case 0:
                delegate?.setReminderValue(.daily, firstDate: firstReminderDate, weekDays: weekDayArray)
                stackViewHeightConstraint.constant=33
                stackViewVertSpaceToDateConstraint.constant=20
            case 1:
                delegate?.setReminderValue(.weekly, firstDate: firstReminderDate, weekDays: weekDayArray)
            case 2:
                delegate?.setReminderValue(.monthly, firstDate: firstReminderDate, weekDays: weekDayArray)
            case 3:
                delegate?.setReminderValue(.yearly, firstDate: firstReminderDate, weekDays: weekDayArray)
            case 4:
                delegate?.setReminderValue(.nonRepeating, firstDate: firstReminderDate, weekDays: weekDayArray)
            default:
                print("ERROR: unhandled index in addHabbitReminderValueTableViewCell")
            }
        }else{
            datePickerHeightConstraint.constant=0
            stackViewHeightConstraint.constant=0
            stackViewVertSpaceToDateConstraint.constant=0
            delegate?.setReminderValue(.notSet, firstDate: nil, weekDays: weekDayArray)
            segment.isUserInteractionEnabled=false
            segment.layer.opacity = 0.5
        }
        delegate?.updated(indexpath: index)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        firstReminderDate = datePicker.date
        datePicker.datePickerMode = .dateAndTime
        stackViewHeightConstraint.constant=0
        stackViewVertSpaceToDateConstraint.constant=0
        switch sender.selectedSegmentIndex {
        case 0:
            datePicker.datePickerMode = .time
            delegate?.setReminderValue(.daily, firstDate: firstReminderDate, weekDays: weekDayArray)
            stackViewHeightConstraint.constant=33
            stackViewVertSpaceToDateConstraint.constant=20
        case 1:
            delegate?.setReminderValue(.weekly, firstDate: firstReminderDate, weekDays: weekDayArray)
        case 2:
            delegate?.setReminderValue(.monthly, firstDate: firstReminderDate, weekDays: weekDayArray)
        case 3:
            delegate?.setReminderValue(.yearly, firstDate: firstReminderDate, weekDays: weekDayArray)
        case 4:
            delegate?.setReminderValue(.nonRepeating, firstDate: firstReminderDate, weekDays: weekDayArray)
        default:
            print("ERROR: unhandled index in addHabbitReminderValueTableViewCell")
        }
        delegate?.updated(indexpath: index)
    }
    @IBAction func datePickerDidChange(_ sender: UIDatePicker) {
        firstReminderDate = datePicker.date
        switch segment.selectedSegmentIndex {
        case 0:
            delegate?.setReminderValue(.daily, firstDate: firstReminderDate, weekDays: weekDayArray)
        case 1:
            delegate?.setReminderValue(.weekly, firstDate: firstReminderDate, weekDays: weekDayArray)
        case 2:
            delegate?.setReminderValue(.monthly, firstDate: firstReminderDate, weekDays: weekDayArray)
        case 3:
            delegate?.setReminderValue(.yearly, firstDate: firstReminderDate, weekDays: weekDayArray)
        case 4:
            delegate?.setReminderValue(.nonRepeating, firstDate: firstReminderDate, weekDays: weekDayArray)
        default:
            print("ERROR: unhandled index in addHabbitReminderValueTableViewCell")
        }
    }
    
    @objc func handleWeekDayButtonViewTap(_ sender: UITapGestureRecognizer){
        if let iv = sender.view as? UIImageView{
            if let ind = weekdayButtons.firstIndex(of: iv){
                weekDayArray[ind] = !weekDayArray[ind]
            }
        }
        for ind in weekDayArray.indices{
            if weekDayArray[ind]{
                weekdayButtons[ind].tintColor = .systemTeal
            }else{
                weekdayButtons[ind].tintColor = .systemGray5
            }
        }
        switch segment.selectedSegmentIndex {
        case 0:
            delegate?.setReminderValue(.daily, firstDate: firstReminderDate, weekDays: weekDayArray)
            stackViewHeightConstraint.constant=33
            stackViewVertSpaceToDateConstraint.constant=20
        case 1:
            delegate?.setReminderValue(.weekly, firstDate: firstReminderDate, weekDays: weekDayArray)
        case 2:
            delegate?.setReminderValue(.monthly, firstDate: firstReminderDate, weekDays: weekDayArray)
        case 3:
            delegate?.setReminderValue(.yearly, firstDate: firstReminderDate, weekDays: weekDayArray)
        case 4:
            delegate?.setReminderValue(.nonRepeating, firstDate: firstReminderDate, weekDays: weekDayArray)
        default:
            print("ERROR: unhandled index in addHabbitReminderValueTableViewCell")
        }
    }
}
