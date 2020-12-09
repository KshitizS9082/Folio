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
            datePicker.isHidden=true
            datePickerHeightConstraint.constant=0
            stackViewHeightConstraint.constant=0
            stackViewVertSpaceToDateConstraint.constant=0
        default:
            switchButton.setOn(true, animated: false)
            segment.isUserInteractionEnabled=true
            segment.layer.opacity = 1.0
            datePicker.isHidden=false
            if #available(iOS 14, *){
                datePickerHeightConstraint.constant = 35
            }else{
                datePickerHeightConstraint.constant = 200
            }
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
//            let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
//            if notificationType == [] {
//                print("notifications are NOT enabled")
//                sender.setOn(false, animated: true)
//                delegate?.setReminderValue(.notSet, firstDate: nil, weekDays: weekDayArray)
//                delegate?.showNotificationNotPresentAlert()
//                return
//            } else {
//                print("notifications are enabled")
//            }
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
              if settings.authorizationStatus == .authorized {
                // Notifications are allowed
                print("notifications are enabled")
                DispatchQueue.main.async {
                    self.datePicker.isHidden=false
                    if #available(iOS 14, *){
                        self.datePickerHeightConstraint.constant = 35
                    }else{
                        self.datePickerHeightConstraint.constant = 200
                    }
                    self.segment.isUserInteractionEnabled=true
                    self.segment.layer.opacity = 1.0
                    self.stackViewHeightConstraint.constant=0
                    self.stackViewVertSpaceToDateConstraint.constant=0
                    switch self.segment.selectedSegmentIndex {
                    case 0:
                        self.delegate?.setReminderValue(.daily, firstDate: self.firstReminderDate, weekDays: self.weekDayArray)
                        self.stackViewHeightConstraint.constant=33
                        self.stackViewVertSpaceToDateConstraint.constant=20
                    case 1:
                        self.delegate?.setReminderValue(.weekly, firstDate: self.firstReminderDate, weekDays: self.weekDayArray)
                    case 2:
                        self.delegate?.setReminderValue(.monthly, firstDate: self.firstReminderDate, weekDays: self.weekDayArray)
                    case 3:
                        self.delegate?.setReminderValue(.yearly, firstDate: self.firstReminderDate, weekDays: self.weekDayArray)
                    case 4:
                        self.delegate?.setReminderValue(.nonRepeating, firstDate: self.firstReminderDate, weekDays: self.weekDayArray)
                    default:
                        print("ERROR: unhandled index in addHabbitReminderValueTableViewCell")
                    }
                    //MARK: required to
                    self.delegate?.updated(indexpath: IndexPath(row: 4, section: 0))
                }
              }
              else {
                // Either denied or notDetermined
                DispatchQueue.main.async {
                    print("notifications are NOT enabled")
                    sender.setOn(false, animated: true)
                    self.delegate?.setReminderValue(.notSet, firstDate: nil, weekDays:self.weekDayArray)
                    self.delegate?.showNotificationNotPresentAlert()
                    self.delegate?.updated(indexpath: IndexPath(row: 4, section: 0))
                }
              }
            }
//            datePicker.isHidden=false
//            if #available(iOS 14, *){
//                datePickerHeightConstraint.constant = 35
//            }else{
//                datePickerHeightConstraint.constant = 200
//            }
//            segment.isUserInteractionEnabled=true
//            segment.layer.opacity = 1.0
//            stackViewHeightConstraint.constant=0
//            stackViewVertSpaceToDateConstraint.constant=0
//            switch segment.selectedSegmentIndex {
//            case 0:
//                delegate?.setReminderValue(.daily, firstDate: firstReminderDate, weekDays: weekDayArray)
//                stackViewHeightConstraint.constant=33
//                stackViewVertSpaceToDateConstraint.constant=20
//            case 1:
//                delegate?.setReminderValue(.weekly, firstDate: firstReminderDate, weekDays: weekDayArray)
//            case 2:
//                delegate?.setReminderValue(.monthly, firstDate: firstReminderDate, weekDays: weekDayArray)
//            case 3:
//                delegate?.setReminderValue(.yearly, firstDate: firstReminderDate, weekDays: weekDayArray)
//            case 4:
//                delegate?.setReminderValue(.nonRepeating, firstDate: firstReminderDate, weekDays: weekDayArray)
//            default:
//                print("ERROR: unhandled index in addHabbitReminderValueTableViewCell")
//            }
        }else{
            datePicker.isHidden=true
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
