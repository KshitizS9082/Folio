//
//  HabitsViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import UserNotifications

protocol habitsVCProtocol {
    func addHabitCard(_ newCard: habitCardData)
    func changeHabitCurentCount(at index: IndexPath, to count: Double)
    func updated(indexpath: IndexPath)
}
struct HabitsData: Codable{
    var cardList = [habitCardData]()
    init(){
    }
    init?(json: Data){
        if let newValue = try? JSONDecoder().decode(HabitsData.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}
class HabitsViewController: UIViewController {
    var habits = HabitsData()
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource=self
        table.delegate=self
        table.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.systemTeal ,
            NSAttributedString.Key.font: UIFont(name: "SnellRoundhand-Black", size: 30)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("habitCardsData.json"){
            if let jsonData = try? Data(contentsOf: url){
                if let extract = HabitsData(json: jsonData){
                    print("did set self.habits to \(extract)")
                    self.habits = extract
                }else{
                    print("ERROR: found HabitsData(json: jsonData) to be nil so didn't set it")
                }
            }else{
                print("error no file named habitCardsData.json found")
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        save()
    }
    func save() {
           var jcl = HabitsData()
           jcl=self.habits
           if let json = jcl.json {
               if let url = try? FileManager.default.url(
                   for: .documentDirectory,
                   in: .userDomainMask,
                   appropriateFor: nil,
                   create: true
               ).appendingPathComponent("habitCardsData.json"){
                   do {
                       try json.write(to: url)
                       print ("saved successfully")
                   } catch let error {
                       print ("couldn't save \(error)")
                   }
               }
           }
       }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc =  segue.destination as? AddHabbitViewController{
            vc.delegate=self
        }
    }

}
extension HabitsViewController: habitsVCProtocol{
    func changeHabitCurentCount(at index: IndexPath, to count: Double) {
        //MARK: currently not working
        //TODO: do somethign to update this
//        habits.cardList[index.row].goalCount=count
        
        var date = Date()
        switch habits.cardList[index.row].habitGoalPeriod {
        case .daily:
            date=date.startOfDay
        case .weekly:
            date=date.startOfWeek
        case .monthly:
            date=date.startOfMonth
        case .yearly:
            date=date.startOfYear
        }
        if count==0.0{
            habits.cardList[index.row].entriesList.removeValue(forKey: date)
        }else{
            habits.cardList[index.row].entriesList[date]=count
        }
        //MARK: next lines to be removed used for debginnh
        //TODO: next lines to be removed used for debginnh
        habits.cardList[index.row].constructionDate =  Calendar.current.date(byAdding: .day, value:  -(20), to: Date())!.startOfDay
        var x = Calendar.current.date(byAdding: .day, value:  -(1), to: Date())!.startOfDay
        habits.cardList[index.row].entriesList[x]=count.advanced(by: -3.0)
        x = Calendar.current.date(byAdding: .day, value:  -(2), to: Date())!.startOfDay
        habits.cardList[index.row].entriesList[x]=count.advanced(by: -1.0)
        x = Calendar.current.date(byAdding: .day, value:  -(3), to: Date())!.startOfDay
        habits.cardList[index.row].entriesList[x]=count.advanced(by: -4.0)
        x = Calendar.current.date(byAdding: .day, value:  -(5), to: Date())!.startOfDay
        habits.cardList[index.row].entriesList[x]=count.advanced(by: -1.0)
        
        table.reloadRows(at: [index], with: .automatic)
//        print("dict = \( habits.cardList[index.row].entriesList)")
    }
    
    func addHabitCard(_ newCard: habitCardData) {
        print("add new card \(newCard)")
        habits.cardList.append(newCard)
        table.reloadData()
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
}
extension HabitsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.cardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "habitsCellIdentifier") as! habitTableViewCell
        cell.selectionStyle = .none
        cell.delegate=self
        cell.index=indexPath
        cell.habitData = habits.cardList[indexPath.row]
        if let lastDate = cell.habitData?.targetDate{
            if Date()>lastDate{
                UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                    var identifiers: [String] = []
                    for notification:UNNotificationRequest in notificationRequests {
                        if notification.identifier == String(describing: (cell.habitData?.UniquIdentifier)) {
                            identifiers.append(notification.identifier)
                        }
                    }
                    print("removing notifs with identifiers \(identifiers)")
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                }
            }
        }
        cell.backgroundColor = .clear
        cell.awakeFromNib()
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete",
                                        handler: { (action, view, completionHandler) in
                                            print("handle delete")
                                            UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                                                var identifiers: [String] = []
                                                for notification:UNNotificationRequest in notificationRequests {
                                                    if notification.identifier == String(describing: (self.habits.cardList[indexPath.row].UniquIdentifier)) {
                                                        identifiers.append(notification.identifier)
                                                    }
                                                }
                                                print("indrow = \(indexPath.row), adn id = \(self.habits.cardList[indexPath.row].UniquIdentifier)")
                                                print("removing notifs with identifiers \(identifiers)")
                                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                                                DispatchQueue.main.async {
                                                    self.habits.cardList.remove(at: indexPath.row)
                                                    self.table.deleteRows(at: [indexPath], with: .automatic)
                                                }
                                            }
                                            completionHandler(true)
        })
        action.backgroundColor = .systemRed

        if self.habits.cardList[indexPath.row].firstReminder != nil{
            var title="Unset"
            switch self.habits.cardList[indexPath.row].reminderValue {
            case .notSet:
                title="Unpause Alarms"
            default:
                title="Pause Alarms"
            }
            let changeAlarm = UIContextualAction(style: .normal, title: title,
                                                 handler: { (action, view, completionHandler) in
                                                    print("handle \(title) alarm")
                                                    switch self.habits.cardList[indexPath.row].reminderValue {
                                                    case .notSet:
                                                        self.setReminder(with: self.habits.cardList[indexPath.row])
                                                        self.habits.cardList[indexPath.row].reminderValue = self.habits.cardList[indexPath.row].reminderValueBeforePausing
                                                    default:
                                                        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                                                            var identifiers: [String] = []
                                                            for notification:UNNotificationRequest in notificationRequests {
                                                                if notification.identifier == String(describing: (self.habits.cardList[indexPath.row].UniquIdentifier)) {
                                                                    identifiers.append(notification.identifier)
                                                                }
                                                            }
                                                            print("removing notifs with identifiers \(identifiers)")
                                                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                                                        }
                                                        self.habits.cardList[indexPath.row].reminderValueBeforePausing = self.habits.cardList[indexPath.row].reminderValue
                                                        self.habits.cardList[indexPath.row].reminderValue = .notSet
                                                    }
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                        // your code here
                                                        self.table.reloadRows(at: [indexPath], with: .none)
                                                    }
                                                    completionHandler(true)
            })
            switch self.habits.cardList[indexPath.row].reminderValue {
            case .notSet:
                changeAlarm.backgroundColor = .systemGray
            default:
                changeAlarm.backgroundColor = .systemYellow
            }
            
            let configuration = UISwipeActionsConfiguration(actions: [action, changeAlarm])
            return configuration
        }

        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    func setReminder(with card: habitCardData){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == String(describing: (card.UniquIdentifier)) {
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
                content.title = "Habit: " + card.title
                content.sound = .default
                content.body = "Habit: " + card.title
                
                //                let targetDate = Date().addingTimeInterval(5)
                //TODO: Change according to recurrence
                let targetDate = card.firstReminder!
                print("setting reminder to \(targetDate)")
                var trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],from: targetDate), repeats: false)
                switch card.reminderValue {
                case .daily:
                    print("daily")
                    trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute, .second],from: targetDate), repeats: true)
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
                
                let request = UNNotificationRequest(identifier: String(describing: (card.UniquIdentifier)), content: content, trigger: trigger)
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
}
