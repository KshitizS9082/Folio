//
//  newSmallCardInfoViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 05/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
protocol newSmallCardInfoVCProtocol {
    func updated(indexpath: IndexPath)
    func updateCard(to newCardValue: SmallCard)
    func updateTitle(to text: String)
    func updateNotes(to text: String)
    func updateURL(to text: String)
    func updateDetailedNotes(to text: String)
    func updateReminderValue(to date: Date?)
}

class newSmallCardInfoViewController: UIViewController {
    var viewLinkedTo: SmallCardView?
    var sCard = SmallCard()

    @IBOutlet weak var table: UITableView!{
        didSet{
            table.dataSource=self
            table.delegate=self
            table.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var navBar: UINavigationBar!{
        didSet{
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
        }
    }
    @IBOutlet weak var deleteButton: UIImageView!{
        didSet{
            deleteButton.isUserInteractionEnabled=true
            let tap=UITapGestureRecognizer(target: self, action: #selector(deleteCard))
            deleteButton.addGestureRecognizer(tap)
        }
    }
    @objc func deleteCard(){
        print("yet to implement deleting card")
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive){
            UIAlertAction in
            print("in delete")
            self.unSetReminder()
            self.viewLinkedTo?.removeFromSuperview()
            self.dismiss(animated: true)
        }
        let deleteFromPageAction = UIAlertAction(title: "Remove From Page", style: .destructive){
            UIAlertAction in
            print("in Remove From Page")
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

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func cancelButtonTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonTap(_ sender: Any) {
        self.dismiss(animated: true) {
            self.viewLinkedTo?.card=self.sCard
            self.viewLinkedTo?.layoutSubviews()
        }
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
                content.title = "Folio Page Reminder" //self.sCard.title
                content.sound = .default
                content.body = "You have a scheduled reminder for " + self.sCard.title
                
                //                let targetDate = Date().addingTimeInterval(5)
                let targetDate = self.sCard.reminderDate!
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
}

extension newSmallCardInfoViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = table.dequeueReusableCell(withIdentifier: "expandTextInpCell") as! ExpandableTextSCardInfoTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.delegate=self
            cell.index=indexPath
            cell.titleLabel.text = "Title:"
            cell.inputTextView.text = self.sCard.title
            return cell
        case 1:
            let cell = table.dequeueReusableCell(withIdentifier: "expandTextInpCell") as! ExpandableTextSCardInfoTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.delegate=self
            cell.index=indexPath
            cell.titleLabel.text = "Notes:"
            cell.inputTextView.text = self.sCard.notes
            return cell
        case 2:
            let cell = table.dequeueReusableCell(withIdentifier: "expandTextInpCell") as! ExpandableTextSCardInfoTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.delegate=self
            cell.index=indexPath
            cell.titleLabel.text = "URL:"
            cell.inputTextView.text = self.sCard.url?.absoluteString
            return cell
        case 3:
            let cell = table.dequeueReusableCell(withIdentifier: "sCardEdVReminderCell") as! sCardReminderTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.delegate=self
            cell.index=indexPath
            cell.card=self.sCard
            cell.awakeFromNib()
            return cell
        case 4:
            let cell = table.dequeueReusableCell(withIdentifier: "expandTextInpCell") as! ExpandableTextSCardInfoTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.delegate=self
            cell.index=indexPath
            cell.titleLabel.text = "Extra Notes:"
            cell.inputTextView.text = self.sCard.extraNotes
            return cell
        default:
            let cell=UITableViewCell()
            cell.backgroundColor = .red
            return cell
        }
    }
    
    
}

extension newSmallCardInfoViewController: newSmallCardInfoVCProtocol{
    func updateTitle(to text: String) {
        self.sCard.title=text
    }
    
    func updateNotes(to text: String) {
        self.sCard.notes=text
    }
    
    func updateURL(to text: String) {
        print("yet to implement")
    }
    
    func updateDetailedNotes(to text: String) {
        print("yet to implement")
        self.sCard.extraNotes=text
    }
    
    func updateReminderValue(to date: Date?) {
        print("yet to implement")
        self.sCard.reminderDate=date
        if let date = date{
            self.setReminder(with: date)
        }else{
            unSetReminder()
        }
    }
    
    func updateCard(to newCardValue: SmallCard){
        self.sCard=newCardValue
    }
    func updated(indexpath: IndexPath) {
        print("updated at indexpath: \(indexpath)")
        // Disabling animations gives us our desired behaviour
        UIView.setAnimationsEnabled(false)
        /* These will causes table cell heights to be recaluclated,
         without reloading the entire cell */
        table.beginUpdates()
        table.endUpdates()
        // Re-enable animations
        UIView.setAnimationsEnabled(true)
        
        table.scrollToRow(at: indexpath, at: .bottom, animated: false)
        
    }
}
