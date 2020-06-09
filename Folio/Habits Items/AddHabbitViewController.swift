//
//  AddHabbitViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
protocol addHabiitVCProtocol {
    func setTitle(_ title: String)
    func setHabitStyle(_ style: habitCardData.HabitStyle)
    func setHabitGoalPeriod(_ period: habitCardData.recurencePeriod)
    func setHabitGoalCount(_ count: Double)
    func setReminderValue(_ reminderValue: habitCardData.ReminderTime, firstDate: Date?, weekDays: [Bool])
    func showNotificationNotPresentAlert()
    func setHabitTargetDate(_ targetDate: Date?)
    func updated(indexpath: IndexPath)
}

class AddHabbitViewController: UIViewController {

    var card = habitCardData()
    var delegate: habitsVCProtocol?
//    var recurdate = Date(
    @IBOutlet weak var navBar: UINavigationBar!{
        didSet{
            //TODO: make it transparent
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
        }
    }
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource=self
        table.delegate=self
        table.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    @IBAction func handleCancelButton(_ sender: Any) {
        print("in handle cancel")
        unSetReminder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleDoneButton(_ sender: Any) {
        print("in handle done")
        if card.title.count>0{
            delegate?.addHabitCard(card)
        }else{
            unSetReminder()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func setDailyWithBreakDaysReminder(with reminderTime: Date, weekDays: [Bool]){
        
    }
    func setReminder(with reminderTime: Date){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == String(describing: (self.card.UniquIdentifier)) {
                    identifiers.append(notification.identifier)
                }
                for i in 0...9{
                    if notification.identifier == String(describing: (self.card.UniquIdentifier))+String(i) {
                        identifiers.append(notification.identifier)
                    }
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
                content.title = "Habit: " + self.card.title
                content.sound = .default
                content.body = "Habit: " + self.card.title
                
                //                let targetDate = Date().addingTimeInterval(5)
                //TODO: Change according to recurrence
                let targetDate = self.card.firstReminder!
                print("setting reminder to \(targetDate)")
                var trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],from: targetDate), repeats: false)
                switch self.card.reminderValue {
                case .daily:
                    print("daily")
                    for ind in 0..<7{
                        let tempDate = Calendar.current.date(byAdding: .day, value:  ind, to: targetDate)!
                        let weekDay = Calendar.current.component(.weekday, from: tempDate)
                        print("weekday = \(weekDay)")
                        if self.card.weekDayArray[weekDay-1]{
                            print("adding reminders with weekday= \(weekDay)")
                            trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.weekday , .hour, .minute, .second],from: targetDate), repeats: true)
                            let request = UNNotificationRequest(identifier: String(describing: (self.card.UniquIdentifier))+String(ind), content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                                if error != nil {
                                    print("something went wrong")
                                }
                            })
                        }
                    }
                case .weekly:
                    print("weekly")
                    trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.weekday ,.hour, .minute, .second],from: targetDate), repeats: true)
                case .monthly:
                    print("monthly")
                    trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.day ,.hour, .minute, .second],from: targetDate), repeats: true)
                case .yearly:
                    print("yearly")
                    trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.month ,.day ,.hour, .minute, .second],from: targetDate), repeats: true)
                case .nonRepeating:
                    print("non repeating")
                    trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],from: targetDate), repeats: false)
                case .notSet:
                    print("not setting")
                    return
                }
                if self.card.reminderValue != .daily{
                    let request = UNNotificationRequest(identifier: String(describing: (self.card.UniquIdentifier)), content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                        if error != nil {
                            print("something went wrong")
                        }
                    })
                }
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
                if notification.identifier == String(describing: (self.card.UniquIdentifier)) {
                    identifiers.append(notification.identifier)
                }
                for i in 0...9{
                    if notification.identifier == String(describing: (self.card.UniquIdentifier))+String(i) {
                        identifiers.append(notification.identifier)
                    }
                }
            }
            print("removing notifs with identifiers \(identifiers)")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
}

extension AddHabbitViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCellIdentifier") as! addHabbitTitleTableViewCell
            cell.delegate=self
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "myBackgroundColor")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "habitStyleCellIdentifier") as! addHabbitStyleTableViewCell
            cell.delegate=self
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "myBackgroundColor")
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "goalPeriodCellIdentifier") as! addHabbitGoalPeriodTableViewCell
            cell.delegate=self
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "myBackgroundColor")
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "goalCountCellIdentifier") as! addHabbitGoalCountTableViewCell
            cell.delegate=self
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "myBackgroundColor")
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "reminderValuesCellIdentifier") as! addHabbitReminderValueTableViewCell
            cell.delegate=self
            cell.index = indexPath
            cell.selectionStyle = .none
            cell.reminderValue = card.reminderValue
            cell.backgroundColor = UIColor(named: "myBackgroundColor")
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "targetDateCellIdentifier") as! addHabbitTargetDateTableViewCell
            cell.delegate=self
            cell.selectionStyle = .none
            cell.targetDate=card.targetDate
            cell.index=indexPath
            cell.backgroundColor = UIColor(named: "myBackgroundColor")
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension AddHabbitViewController: addHabiitVCProtocol{
    
    func setHabitGoalCount(_ count: Double) {
        self.card.goalCount = count
    }
    
    func setTitle(_ title: String) {
        self.card.title = title
    }
    
    func setHabitStyle(_ style: habitCardData.HabitStyle) {
        self.card.habitStyle = style
    }
    
    func setHabitGoalPeriod(_ period: habitCardData.recurencePeriod) {
        self.card.habitGoalPeriod = period
    }
    //TODO: make reminder recurring
    func setReminderValue(_ reminderValue: habitCardData.ReminderTime, firstDate: Date?, weekDays: [Bool]) {
        self.card.reminderValue = reminderValue
        self.card.firstReminder = firstDate
        self.card.weekDayArray = weekDays
        print("new card value = \(self.card)")
        if let date = firstDate{
            setReminder(with: date)
        }else{
            unSetReminder()
        }
    }
    
    func setHabitTargetDate(_ targetDate: Date?) {
        self.card.targetDate = targetDate
    }
    func updated(indexpath: IndexPath) {
        //TODO: maybe use this stord height method, but not required
        
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
    func showNotificationNotPresentAlert(){
        let alert = UIAlertController(title: "We Don't have permision to notify you :(", message: "Please enable them from settings>App>Notfication ;)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok Sure :)", style: .default, handler: { (action) in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (succes, error) in
                print("autho \(succes)")
            }
        }))
        self.present(alert, animated: true)
    }
}
