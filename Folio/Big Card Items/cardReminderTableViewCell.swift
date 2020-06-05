//
//  cardReminderTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 05/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class cardReminderTableViewCell: UITableViewCell {
    var card = Card()
    var index = IndexPath(row: 0, section: 0)
    var delegate: newEditCardViewControllerProtocol?
    
    var reminderDatePicker: UIDatePicker?
    
    @IBOutlet weak var reminderValueLabel: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setReminderHeaderAndText()
        setReminderDatePicker()
    }
    private func setReminderHeaderAndText(){
        if let time = card.reminder{
          let myDateFormater = DateFormatter()
              myDateFormater.dateStyle = .long
          let myTimeFormater = DateFormatter()
              myTimeFormater.dateFormat = "hh:mm a"
          reminderValueLabel.text =  myTimeFormater.string(from: time) + ", " + myDateFormater.string(from: time)
//          print("didset remider time to: "+reminderValueLabel.text!)
        }else{
            reminderValueLabel.text = "Date not set"
        }
    }
    private func setReminderDatePicker(){
        reminderDatePicker = UIDatePicker()
        if let date =  card.reminder {
            reminderDatePicker?.date = date
        }else{
            reminderValueLabel.text = "Date not set"
        }
        reminderDatePicker?.datePickerMode = .dateAndTime
        reminderValueLabel.inputView = reminderDatePicker
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.backgroundColor = myBavkgoundColor
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Set", style: .done, target: self, action: #selector(doneReminderDateChange));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelReminderDatePicker));
        let deleteButton = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteReminderDatePicker));
        let centerButton = UIBarButtonItem(title: "Reminder", style: .plain, target: nil, action: nil)
        toolbar.setItems([cancelButton,deleteButton,spaceButton,centerButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        reminderValueLabel.inputAccessoryView = toolbar
        
        reminderDatePicker?.backgroundColor = myBavkgoundColor
    }
    @objc func doneReminderDateChange(){
        let myDateFormater = DateFormatter()
        myDateFormater.dateStyle = .long
        let myTimeFormater = DateFormatter()
        myTimeFormater.dateFormat = "hh:mm a"
        reminderValueLabel.text =  myTimeFormater.string(from: reminderDatePicker!.date) + ", " + myDateFormater.string(from: reminderDatePicker!.date)
        card.reminder = reminderDatePicker?.date
        //TODO: setReminder(with: card.reminder!)
        delegate?.updateReminder(to: card.reminder!)
        self.endEditing(true)
    }
    @objc func cancelReminderDatePicker(){
        self.endEditing(true)
    }
    @objc func deleteReminderDatePicker(){
        self.endEditing(true)
        card.reminder = nil
        reminderValueLabel.text = "Date not set"
        //TODO: unSetReminder()
        delegate?.updateReminder(to: nil)
    }
}
extension cardReminderTableViewCell{
    var myBavkgoundColor: UIColor{
        return UIColor(named: "myBackgroundColor") ?? #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
}
