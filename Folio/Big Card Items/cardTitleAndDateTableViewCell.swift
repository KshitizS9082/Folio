//
//  cardTitleAndDateTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 05/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class cardTitleAndDateTableViewCell: UITableViewCell {
    var card = Card()
    var index = IndexPath(row: 0, section: 0)
    var delegate: newEditCardViewControllerProtocol?
    @IBOutlet weak var headingTextView: UITextView!
    
    @IBOutlet weak var startTimeLabel: UITextField!
    @IBOutlet weak var startTimeSubLabel: UITextField!
    @IBOutlet weak var endTimeLabel: UITextField!
    @IBOutlet weak var endTimeSubLabel: UITextField!
    //    @IBOutlet weak var startTimeLabel: UILabel!
//    @IBOutlet weak var startTimeSubLabel: UILabel!
//    @IBOutlet weak var endTimeLabel: UILabel!
//    @IBOutlet weak var endTimeSubLabel: UILabel!
    var datePicker: UIDatePicker? = nil
    var endDatePicker: UIDatePicker? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        headingTextView.text=card.Heading
        headingTextView.delegate=self
        if let time = card.time{
            let myDateFormater = DateFormatter()
            myDateFormater.dateStyle = .full
            startTimeLabel.text = myDateFormater.string(from: time)
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            startTimeSubLabel.text = formatter.string(from: time)
        }else{
            startTimeLabel.text = "Event Start Time"
            startTimeSubLabel.text = ""
        }
        //        startTimeLabel.allowsEditingTextAttributes=false
        if let time = card.endTime{
            let myDateFormater = DateFormatter()
            myDateFormater.dateStyle = .medium
            endTimeLabel.text = myDateFormater.string(from: time)
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            endTimeSubLabel.text = formatter.string(from: time)
        }else{
            endTimeLabel.text = "Event Finish Time"
            endTimeSubLabel.text = ""
        }
        setDatePicker()
        setEndDatePicker()
    }
    
    private func setDatePicker(){
        datePicker = UIDatePicker()
        if let date =  card.time {
            datePicker?.date = date
        }
        datePicker?.datePickerMode = .dateAndTime
        startTimeLabel.inputView = datePicker
        startTimeSubLabel.inputView = datePicker
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.backgroundColor = myBavkgoundColor
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Set", style: .done, target: self, action: #selector(doneDateTimeChange));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(cancelDatePicker));
        let centerButton = UIBarButtonItem(title: "Event Start Time", style: .plain, target: nil, action: nil)
        toolbar.setItems([cancelButton,spaceButton,centerButton,spaceButton,doneButton], animated: false)
        // add toolbar to textField
        startTimeLabel.inputAccessoryView = toolbar
        startTimeSubLabel.inputAccessoryView = toolbar
        
        datePicker?.backgroundColor = myBavkgoundColor
        
    }
    @objc func doneDateTimeChange(){
        let myDateFormater = DateFormatter()
        myDateFormater.dateStyle = .full
        startTimeLabel.text = myDateFormater.string(from: datePicker!.date)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        startTimeSubLabel.text = timeFormatter.string(from: datePicker!.date)
        card.time = datePicker?.date
        delegate?.updateStartDate(to: card.time)
        self.endEditing(true)
    }
    @objc func cancelDatePicker(){
        delegate?.updateStartDate(to: nil)
        self.endEditing(true)
        card.time=nil
        awakeFromNib()
    }
    
    private func setEndDatePicker(){
        endDatePicker = UIDatePicker()
        if let date =  card.endTime {
            endDatePicker?.date = date
        }
        endDatePicker?.datePickerMode = .dateAndTime
        //        datePicker?.addTarget(self, action: #selector(doneDateTimeChange(datePicker:)), for: .valueChanged)
        endTimeLabel.inputView = endDatePicker
        endTimeSubLabel.inputView = endDatePicker
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.backgroundColor = myBavkgoundColor
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Set", style: .done, target: self, action: #selector(doneEndDateTimeChange));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(cancelEndDatePicker));
        let centerButton = UIBarButtonItem(title: "Event Finish Time", style: .plain, target: nil, action: nil)
        toolbar.setItems([cancelButton,spaceButton,centerButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        endTimeLabel.inputAccessoryView = toolbar
        endTimeSubLabel.inputAccessoryView = toolbar
        
        endDatePicker?.backgroundColor = myBavkgoundColor
    }
    @objc func doneEndDateTimeChange(){
        let myDateFormater = DateFormatter()
        myDateFormater.dateStyle = .medium
        endTimeLabel.text = myDateFormater.string(from: endDatePicker!.date)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        endTimeSubLabel.text = timeFormatter.string(from: endDatePicker!.date)
        card.endTime = endDatePicker?.date
        delegate?.updateEndDate(to: card.endTime)
        self.endEditing(true)
    }
    @objc func cancelEndDatePicker(){
        delegate?.updateEndDate(to: nil)
        self.endEditing(true)
        card.endTime=nil
        awakeFromNib()
    }
}
extension cardTitleAndDateTableViewCell{
    var myBavkgoundColor: UIColor{
        return UIColor(named: "myBackgroundColor") ?? #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
}
extension cardTitleAndDateTableViewCell: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        print("now update me")
        delegate?.updated(indexpath: self.index)
        delegate?.updateTitle(to: textView.text)
    }
}
