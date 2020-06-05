//
//  newEditCardViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 05/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import UserNotifications
//TODO: add showNotificationNotPresentAlert
protocol newEditCardViewControllerProtocol {
    func updateTitle(to title: String?)
    func updateStartDate(to date: Date?)
    func updateEndDate(to date: Date?)
    func updateCardType(to cardType: Card.cardType)
    func updateReminder(to date: Date?)
    func updated(indexpath: IndexPath)
}

class newEditCardViewController: UIViewController {
    
    var viewLinkedTo: cardView? = nil
    var card = Card(){
        didSet{
            print("card n neweditview= \(self.card)")
//            viewLinkedTo?.card=card
//            viewLinkedTo?.layoutSubviews()
        }
    }
    @IBOutlet weak var table: UITableView!{
        didSet{
            table.dataSource=self
            table.delegate=self
            table.separatorStyle = .none
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        setDeleteButton()
        // Do any additional setup after loading the view.
    }
    //set Delete button
    @IBOutlet weak var deleteButton: UIImageView!{
        didSet{
             let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapDelete))
            deleteButton.addGestureRecognizer(tap)
        }
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
    
    
    @IBOutlet weak var navBar: UINavigationBar!{
        didSet{
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
        }
    }
    @IBAction func cancelButtonTap(_ sender: Any) {
        self.unSetReminder()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonTap(_ sender: Any) {
        self.dismiss(animated: true) {
            self.viewLinkedTo!.card=self.card
            self.viewLinkedTo!.layoutSubviews()
        }
    }
    

}
extension newEditCardViewController{
    var cornerOffset: CGFloat{
        return view.bounds.width*0.03
    }
    var deleteButtomDimmensions: CGFloat{return 50}
}

extension newEditCardViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = table.dequeueReusableCell(withIdentifier: "bigCardEdVTitleCell") as! cardTitleAndDateTableViewCell
            cell.backgroundColor = .clear
            cell.index=indexPath
            cell.delegate=self
            cell.selectionStyle = .none
            cell.card=self.card
            cell.awakeFromNib()
            return cell
        case 1:
            let cell = table.dequeueReusableCell(withIdentifier: "bigCardEdVTypeCell") as! cardTypeTableViewCell
            cell.backgroundColor = .clear
            cell.index=indexPath
            cell.delegate=self
            cell.selectionStyle = .none
            cell.card=self.card
            cell.awakeFromNib()
            return cell
        case 2:
            let cell = table.dequeueReusableCell(withIdentifier: "bigCardEdVReminderCell") as! cardReminderTableViewCell
            cell.backgroundColor = .clear
            cell.index=indexPath
            cell.delegate=self
            cell.selectionStyle = .none
            cell.card=self.card
            cell.awakeFromNib()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}
extension newEditCardViewController: newEditCardViewControllerProtocol{
    func updateTitle(to title: String?) {
        print("to implemente")
        self.card.Heading=title
    }
    
    func updateStartDate(to date: Date?) {
        print("to implemente")
        self.card.time=date
    }
    
    func updateEndDate(to date: Date?) {
        print("to implemente")
        self.card.endTime=date
    }
    
    func updateCardType(to cardType: Card.cardType) {
        print("to implemente")
        self.card.type = cardType
    }
    
    func updateReminder(to date: Date?) {
        print("to implemente")
        self.card.reminder = date
        if let date = date{
            setReminder(with: date)
        }else{
            unSetReminder()
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


