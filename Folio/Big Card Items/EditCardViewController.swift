//
//  EditCardViewController.swift
//  card2
//
//  Created by Kshitiz Sharma on 08/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

import SPStorkController
import SPFakeBar
import UserNotifications


class EditCardViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var card = Card(){
        didSet{
//            self.delegate?.nowUpdateCard(newCard: card, for: viewLinkedTo!)
            viewLinkedTo?.card=card
            viewLinkedTo?.layoutSubviews()
        }
    }
    var viewLinkedTo: cardView? = nil
//    var delegate: UpdateCardProtocol?
    
    let navBar = SPFakeBarView(style: .stork)
    
    var HeadingText = UITextView()
    
    var dateText = UITextField()
    var timeText = UITextField()
    var endDateText = UITextField()
    var endTimeText = UITextField()
    var datePicker: UIDatePicker? = nil
    var endDatePicker: UIDatePicker? = nil
    
    var cardTypeHeading = UITextField()
    var cardType = UITextField()
    var cardTypePicker: UIPickerView? = nil
    
    var reminderHeading = UITextField()
    var reminderValue = UITextField()
    var reminderDatePicker: UIDatePicker? = nil
    
    var deleteButton =  UIImageView(image: UIImage(systemName: "trash.circle.fill"))
    
    //Set Card Heading
    private func setHeadingText(){
        HeadingText = UITextView()
        self.view.addSubview(HeadingText)
        HeadingText.translatesAutoresizingMaskIntoConstraints = false
        HeadingText.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: cornerOffset).isActive=true
        HeadingText.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -cornerOffset).isActive=true
        HeadingText.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive=true
//        HeadingText.heightAnchor.constraint(equalToConstant: 100).isActive = true

        if let text = card.Heading{
            HeadingText.text = text
        }else{
            HeadingText.text = "This is the heading of your Card"
        }
        HeadingText.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont (name: "HelveticaNeue-Bold", size: headingFontSize)!)
        HeadingText.adjustsFontForContentSizeCategory = true
        HeadingText.layer.cornerRadius = 10
        HeadingText.backgroundColor = viewsBackgroundColor
    }
    
    
    //Set Card Date and Text
    private func setDateText(){
        //       print("Date = \(card.time?.description(with: Locale(identifier: "en_US")))")
        let dtf = UITextField()
        self.view.addSubview(dtf)
        dtf.translatesAutoresizingMaskIntoConstraints = false
        dtf.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: cornerOffset).isActive=true
        dtf.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: -cornerOffset).isActive=true
        //TODO: check if possible this way
        //       dtf.topAnchor.constraint(equalTo: HeadingText.bottomAnchor).isActive=true
        if let time = card.time{
        let myDateFormater = DateFormatter()
        myDateFormater.dateStyle = .full
        dtf.text = myDateFormater.string(from: time)
        }else{
        dtf.text = "Event Start Time"
        }
        dtf.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont (name: "Avenir-Medium", size: dateTimeFontSize)!)
        dtf.adjustsFontForContentSizeCategory = true
        dtf.layer.cornerRadius = 10
        dtf.backgroundColor = viewsBackgroundColor
        dtf.textColor = dateTextColor
        dateText = dtf
    }
    private func resetDateTextTopAchor(){
        //TODO: check if possible in anchor constraing way
        dateText.frame.origin.y = HeadingText.frame.origin.y + HeadingText.frame.height
        dateText.sizeToFit()
    }
    private func setTimeText(){
           let dtf = UITextField()
           self.view.addSubview(dtf)
           dtf.translatesAutoresizingMaskIntoConstraints = false
           dtf.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: cornerOffset).isActive=true
           dtf.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: -cornerOffset).isActive=true
            //TODO: check if possible this way
           dtf.topAnchor.constraint(equalTo: dateText.bottomAnchor).isActive=true
           if let time = card.time{
                let formatter = DateFormatter()
                formatter.dateFormat = "hh:mm a"
                dtf.text = formatter.string(from: time)
           }else{
               dtf.text = ""
           }
           dtf.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont (name: "Avenir-Medium", size: dateTimeFontSize)!)
           dtf.adjustsFontForContentSizeCategory = true
           dtf.layer.cornerRadius = 10
           dtf.backgroundColor = viewsBackgroundColor
            dtf.textColor = timeTextColor
           timeText = dtf
        }
    private func resetTimeTextTopAchor(){
        //TODO: check if possible in anchor constraing way
        timeText.frame.origin.y = dateText.frame.origin.y + dateText.frame.height
        timeText.sizeToFit()
    }
    
    private func setEndDateText(){
    //       print("Date = \(card.time?.description(with: Locale(identifier: "en_US")))")
           let dtf = UITextField()
           self.view.addSubview(dtf)
           dtf.translatesAutoresizingMaskIntoConstraints = false
           dtf.leftAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor, constant: cornerOffset).isActive=true
           dtf.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -cornerOffset).isActive=true
            //TODO: check if possible this way
    //       dtf.topAnchor.constraint(equalTo: HeadingText.bottomAnchor).isActive=true
           if let time = card.time{
               let myDateFormater = DateFormatter()
            myDateFormater.dateStyle = .medium
               dtf.text = myDateFormater.string(from: time)
           }else{
               dtf.text = "Event Finish Time"
           }
           dtf.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont (name: "Avenir-Medium", size: dateTimeFontSize)!)
           dtf.adjustsFontForContentSizeCategory = true
           dtf.layer.cornerRadius = 10
           dtf.backgroundColor = viewsBackgroundColor
            dtf.textColor = dateTextColor
           endDateText = dtf
        }
    private func resetEndDateTextTopAchor(){
        //TODO: check if possible in anchor constraing way
        endDateText.frame.origin.y = HeadingText.frame.origin.y + HeadingText.frame.height
        endDateText.sizeToFit()
    }
    private func setEndTimeText(){
       let dtf = UITextField()
       self.view.addSubview(dtf)
       dtf.translatesAutoresizingMaskIntoConstraints = false
       dtf.leftAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor, constant: cornerOffset).isActive=true
       dtf.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -cornerOffset).isActive=true
        //TODO: check if possible this way
       dtf.topAnchor.constraint(equalTo: dateText.bottomAnchor).isActive=true
       if let time = card.endTime{
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            dtf.text = formatter.string(from: time)
       }else{
           dtf.text = ""
       }
       dtf.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont (name: "Avenir-Medium", size: dateTimeFontSize)!)
       dtf.adjustsFontForContentSizeCategory = true
       dtf.layer.cornerRadius = 10
       dtf.backgroundColor = viewsBackgroundColor
        dtf.textColor = timeTextColor
       endTimeText = dtf
    }
    private func resetEndTimeTextTopAchor(){
        //TODO: check if possible in anchor constraing way
        endTimeText.frame.origin.y = dateText.frame.origin.y + dateText.frame.height
        endTimeText.sizeToFit()
    }
    private func setDatePicker(){
            datePicker = UIDatePicker()
            if let date =  card.time {
                datePicker?.date = date
            }
            datePicker?.datePickerMode = .dateAndTime
    //        datePicker?.addTarget(self, action: #selector(doneDateTimeChange(datePicker:)), for: .valueChanged)
            dateText.inputView = datePicker
            timeText.inputView = datePicker
            
            //ToolBar
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            toolbar.backgroundColor = datePickerToolbarColor
            //done button & cancel button
            let doneButton = UIBarButtonItem(title: "Set", style: .done, target: self, action: #selector(doneDateTimeChange));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelDatePicker));
            let centerButton = UIBarButtonItem(title: "Event Start Time", style: .plain, target: nil, action: nil)
            toolbar.setItems([cancelButton,spaceButton,centerButton,spaceButton,doneButton], animated: false)

            // add toolbar to textField
            dateText.inputAccessoryView = toolbar
            timeText.inputAccessoryView = toolbar
            
            datePicker?.backgroundColor = datePickerColor
        }
    private func setEndDatePicker(){
        endDatePicker = UIDatePicker()
        if let date =  card.endTime {
            endDatePicker?.date = date
        }
        endDatePicker?.datePickerMode = .dateAndTime
//        datePicker?.addTarget(self, action: #selector(doneDateTimeChange(datePicker:)), for: .valueChanged)
        endDateText.inputView = endDatePicker
        endTimeText.inputView = endDatePicker
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.backgroundColor = datePickerToolbarColor
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Set", style: .done, target: self, action: #selector(doneEndDateTimeChange));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelEndDatePicker));
        let centerButton = UIBarButtonItem(title: "Event Finish Time", style: .plain, target: nil, action: nil)
        toolbar.setItems([cancelButton,spaceButton,centerButton,spaceButton,doneButton], animated: false)

        // add toolbar to textField
        endDateText.inputAccessoryView = toolbar
        endTimeText.inputAccessoryView = toolbar
        
        endDatePicker?.backgroundColor = datePickerColor
    }

    @objc func doneDateTimeChange(){
        let myDateFormater = DateFormatter()
            myDateFormater.dateStyle = .full
        dateText.text = myDateFormater.string(from: datePicker!.date)
        let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
        timeText.text = timeFormatter.string(from: datePicker!.date)
        card.time = datePicker?.date
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
       self.view.endEditing(true)
     }
    @objc func doneEndDateTimeChange(){
        let myDateFormater = DateFormatter()
            myDateFormater.dateStyle = .medium
        endDateText.text = myDateFormater.string(from: endDatePicker!.date)
        let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
        endTimeText.text = timeFormatter.string(from: endDatePicker!.date)
        card.endTime = endDatePicker?.date
        self.view.endEditing(true)
    }
    @objc func cancelEndDatePicker(){
       self.view.endEditing(true)
     }
    
    //Set Card type
    private func setCardTypeAndItsHeader(){
        //Set card type heading
       var dtf = UITextField()
       self.view.addSubview(dtf)
       dtf.translatesAutoresizingMaskIntoConstraints = false
       dtf.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: cornerOffset).isActive=true
       dtf.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: -cornerOffset).isActive=true
        //TODO: check if possible this way
       dtf.topAnchor.constraint(equalTo: timeText.bottomAnchor, constant: timeTextToCardTypeDistance).isActive=true
        dtf.text = "Card Type"
       dtf.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont (name: "Avenir-Medium", size: typeHeadingFontSize)!)
       dtf.adjustsFontForContentSizeCategory = true
       dtf.layer.cornerRadius = 10
       dtf.backgroundColor = viewsBackgroundColor
       dtf.textColor = typeHeadingColor
       cardTypeHeading = dtf
        
        //Set card type
        dtf = UITextField()
        self.view.addSubview(dtf)
        dtf.translatesAutoresizingMaskIntoConstraints = false
        dtf.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: cornerOffset).isActive=true
        dtf.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: -cornerOffset).isActive=true
         //TODO: check if possible this way
        dtf.topAnchor.constraint(equalTo: cardTypeHeading.bottomAnchor).isActive=true
         switch card.type {
             case .Notes:
                 dtf.text = "Notes"
             case .Drawing:
                 dtf.text = "Drawing"
             case .CheckList:
                 dtf.text = "Checklist"
         }
        dtf.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont (name: "Avenir-Medium", size: typeFontSize)!)
        dtf.adjustsFontForContentSizeCategory = true
        dtf.layer.cornerRadius = 10
        dtf.backgroundColor = viewsBackgroundColor
        dtf.textColor = typeHeadingColor
        cardType = dtf
    }
    private func resetCardTypeAndItsHeaderTopAchor(){
        //TODO: check if possible in anchor constraing way
        cardTypeHeading.frame.origin.y = timeText.frame.origin.y + timeText.frame.height + timeTextToCardTypeDistance
        cardTypeHeading.sizeToFit()
        cardType.frame.origin.y = cardTypeHeading.frame.origin.y + cardTypeHeading.frame.height
        cardType.sizeToFit()
    }
    private func setCardTypePickerView(){
        cardTypePicker = UIPickerView()
        cardTypePickerData = ["Notes", "Drawing", "CheckList"]
        self.cardTypePicker?.delegate = self
        self.cardTypePicker?.dataSource = self
        
        cardType.inputView = cardTypePicker
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.backgroundColor = datePickerToolbarColor
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Set", style: .done, target: self, action: #selector(doneCardTypeChange));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelDatePicker));
        let centerButton = UIBarButtonItem(title: "Card Type", style: .plain, target: nil, action: nil)
        toolbar.setItems([cancelButton,spaceButton,centerButton,spaceButton,doneButton], animated: false)
//        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)

        // add toolbar to textField
        cardType.inputAccessoryView = toolbar
        cardTypePicker?.backgroundColor = datePickerColor
    }
    @objc func doneCardTypeChange(){
        card.type = Card.cardType(rawValue: cardTypePickerData[(cardTypePicker?.selectedRow(inComponent: 0))!])!
        cardType.text = cardTypePickerData[(cardTypePicker?.selectedRow(inComponent: 0))!]
        self.view.endEditing(true)
    }
    @objc func cancleCardTypeChange(){
       self.view.endEditing(true)
     }
    
    var cardTypePickerData: [String] = [String]()
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cardTypePickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cardTypePickerData[row]
    }
    
    //Set Reminder
    private func setReminderHeaderAndText(){
        var dtf = UITextField()
        self.view.addSubview(dtf)
        dtf.translatesAutoresizingMaskIntoConstraints = false
        dtf.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: cornerOffset).isActive=true
        dtf.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: -cornerOffset).isActive=true
        //TODO: check if possible this way
        //       dtf.topAnchor.constraint(equalTo: HeadingText.bottomAnchor).isActive=true
        dtf.text = "Reminder"
        dtf.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont (name: "Avenir-Medium", size: typeHeadingFontSize)!)
        dtf.adjustsFontForContentSizeCategory = true
        dtf.layer.cornerRadius = 10
        dtf.backgroundColor = viewsBackgroundColor
        dtf.textColor = dateTextColor
        reminderHeading = dtf
        
        dtf = UITextField()
          self.view.addSubview(dtf)
          dtf.translatesAutoresizingMaskIntoConstraints = false
          dtf.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: cornerOffset).isActive=true
          dtf.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: -cornerOffset).isActive=true
          //TODO: check if possible this way
          //       dtf.topAnchor.constraint(equalTo: HeadingText.bottomAnchor).isActive=true
          if let time = card.reminder{
            let myDateFormater = DateFormatter()
                myDateFormater.dateStyle = .long
            let myTimeFormater = DateFormatter()
                myTimeFormater.dateFormat = "hh:mm a"
            dtf.text =  myTimeFormater.string(from: time) + ", " + myDateFormater.string(from: time)
            print("didset remider time to: "+dtf.text!)
          }else{
              dtf.text = "Date not set"
          }
          dtf.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont (name: "Avenir-Medium", size: reminderFontSize)!)
          dtf.adjustsFontForContentSizeCategory = true
          dtf.layer.cornerRadius = 10
          dtf.backgroundColor = viewsBackgroundColor
          dtf.textColor = dateTextColor
          reminderValue = dtf
    }
    private func resetReminderHeaderAndTextTopAnchor(){
        //TODO: check if possible in anchor constraing way
        reminderHeading.frame.origin.y = cardType.frame.origin.y + cardType.frame.height + timeTextToCardTypeDistance
        reminderHeading.sizeToFit()
        reminderValue.frame.origin.y = reminderHeading.frame.origin.y + reminderHeading.frame.height
        reminderValue.sizeToFit()
    }
    private func setReminderDatePicker(){
        reminderDatePicker = UIDatePicker()
        if let date =  card.reminder {
            reminderDatePicker?.date = date
        }else{
            reminderValue.text = "Date not set"
        }
        reminderDatePicker?.datePickerMode = .dateAndTime
        reminderValue.inputView = reminderDatePicker
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.backgroundColor = datePickerToolbarColor
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Set", style: .done, target: self, action: #selector(doneReminderDateChange));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelReminderDatePicker));
        let deleteButton = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteReminderDatePicker));
        let centerButton = UIBarButtonItem(title: "Reminder", style: .plain, target: nil, action: nil)
        toolbar.setItems([cancelButton,deleteButton,spaceButton,centerButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        reminderValue.inputAccessoryView = toolbar
        
        reminderDatePicker?.backgroundColor = datePickerColor
    }
    @objc func doneReminderDateChange(){
        let myDateFormater = DateFormatter()
        myDateFormater.dateStyle = .long
        let myTimeFormater = DateFormatter()
        myTimeFormater.dateFormat = "hh:mm a"
        reminderValue.text =  myTimeFormater.string(from: reminderDatePicker!.date) + ", " + myDateFormater.string(from: reminderDatePicker!.date)
        card.reminder = reminderDatePicker?.date
        setReminder(with: card.reminder!)
        self.view.endEditing(true)
    }
    @objc func cancelReminderDatePicker(){
        self.view.endEditing(true)
    }
    @objc func deleteReminderDatePicker(){
        self.view.endEditing(true)
        card.reminder = nil
        reminderValue.text = "Date not set"
        unSetReminder()
    }
    func setReminder(with reminderTime: Date){
            UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                var identifiers: [String] = []
                for notification:UNNotificationRequest in notificationRequests {
                    if notification.identifier == String(describing: (self.viewLinkedTo?.card.UniquIdentifier)!) {
                        identifiers.append(notification.identifier)
                    }
                }
                print("removing notifs with identifiers \(identifiers)")
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            }
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
                if success {
                    // schedule test
                    print("scheduling a test")
                    let content = UNMutableNotificationContent()
                    content.title = self.card.Heading ?? "Folio Reminder"
                    content.sound = .default
                    content.body = "You have a scheduled reminder"
                    
    //                let targetDate = Date().addingTimeInterval(5)
                    let targetDate = self.card.reminder!
                    print("setting reminder to \(targetDate)")
                    let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],from: targetDate), repeats: false)
                    
                    let request = UNNotificationRequest(identifier: String(describing: (self.viewLinkedTo?.card.UniquIdentifier)!), content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                        if error != nil {
                            print("something went wrong")
                        }
                    })
                }
                else if error != nil {
                    print("error occurred")
                }
            })
        }
        func unSetReminder(){
            UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                var identifiers: [String] = []
                for notification:UNNotificationRequest in notificationRequests {
                    if notification.identifier == String(describing: (self.viewLinkedTo?.card.UniquIdentifier)!) {
                        identifiers.append(notification.identifier)
                    }
                }
                print("removing notifs with identifiers \(identifiers)")
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            }
        }
    
    //set Delete button
    private func setDeleteButton(){
        view.addSubview(deleteButton)
        deleteButton.isUserInteractionEnabled = true
        deleteButton.translatesAutoresizingMaskIntoConstraints=false
        deleteButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: cornerOffset).isActive=true
        deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive=true
        deleteButton.heightAnchor.constraint(equalToConstant: deleteButtomDimmensions).isActive=true
        deleteButton.widthAnchor.constraint(equalToConstant: deleteButtomDimmensions).isActive=true
//        deleteButton.height.constraint(equalToConstant: deleteButtomDimmensions)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapDelete))
        deleteButton.addGestureRecognizer(tap)
    }
    @objc func handleTapDelete(){
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive){
            UIAlertAction in
            print("in delete")
//            self.delegate?.deleteCard(for: self.card, at: self.viewLinkedTo!)
            self.viewLinkedTo?.removeFromSuperview()
            self.dismiss(animated: true)
        }
        let deleteFromPageAction = UIAlertAction(title: "Remove From Page", style: .destructive){
            UIAlertAction in
            print("in Remove From Page")
//            self.viewLinkedTo?.removeFromSuperview()
//            self.viewLinkedTo?.frame = CGRect.zero
            self.viewLinkedTo?.isHidden=true
            self.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        let alert = UIAlertController(title: "Delete Card?", message: "Deleting this card will also delete it's data", preferredStyle: .actionSheet)
        alert.addAction(deleteFromPageAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.titleLabel.text = "Title"
        self.view.addSubview(self.navBar)
        self.view.backgroundColor = cardBackgroundColor
        // Do any additional setup after loading the view.
        setHeadingText()
        self.HeadingText.delegate = self
        setDateText(); setTimeText(); setDatePicker()
        setEndDateText(); setEndTimeText(); setEndDatePicker()
        setCardTypeAndItsHeader(); setCardTypePickerView()
        setReminderHeaderAndText(); setReminderDatePicker()
        
    }
    
    override func viewDidLayoutSubviews() {
        HeadingText.sizeToFit()
//        setHeadingText()
        resetDateTextTopAchor();resetTimeTextTopAchor()
        resetEndDateTextTopAchor();resetEndTimeTextTopAchor()
        resetCardTypeAndItsHeaderTopAchor()
        resetReminderHeaderAndTextTopAnchor()
        setDeleteButton()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //dismiss headingText editing keyboard when return pressed and save changes to card
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //TODO: set headingtextiview's width properly as need to add text sometims
//        textView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor, constant: -cornerOffset).isActive = true
        if text == "\n" {
            textView.resignFirstResponder()
            card.Heading = HeadingText.text
            return false
        }
        return true
    }

}

extension EditCardViewController{
    var cornerOffset: CGFloat{
        return view.bounds.width*0.03
    }
    var cardBackgroundColor: UIColor{
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    var datePickerColor: UIColor{
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    var dateTextColor: UIColor{
        return #colorLiteral(red: 0.313691169, green: 0.3137494922, blue: 0.31368348, alpha: 1)
    }
    var timeTextColor: UIColor{
        return #colorLiteral(red: 0.4391697049, green: 0.4392479062, blue: 0.4391593933, alpha: 1)
    }
    var typeHeadingColor: UIColor{
        return #colorLiteral(red: 0.4391697049, green: 0.4392479062, blue: 0.4391593933, alpha: 1)
    }
    var typeColor: UIColor{
        return #colorLiteral(red: 0.4391697049, green: 0.4392479062, blue: 0.4391593933, alpha: 1)
    }
    var datePickerToolbarColor: UIColor{
        return #colorLiteral(red: 0.8732018588, green: 0.8732018588, blue: 0.8732018588, alpha: 0.9013556338)
    }
    var timeTextToCardTypeDistance: CGFloat{
        return view.bounds.size.height * 0.01
    }
    var bottomBorderColor: UIColor{
        return UIColor.systemGray
        }
    var viewsBackgroundColor: UIColor{
        return  #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 0)
    }
    var headingFontSize: CGFloat{ return 30}
    var dateTimeFontSize: CGFloat{ return 20}
    var typeHeadingFontSize: CGFloat{ return 15}
    var typeFontSize: CGFloat{ return 25}
    var reminderFontSize: CGFloat{ return 20}
    var deleteButtomDimmensions: CGFloat{return 50}
}

