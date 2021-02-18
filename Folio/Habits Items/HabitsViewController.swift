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
    //used for archive tab
    var completedCardList = [habitCardData]()
    var deletedCardList = [habitCardData]()
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
//    var archivedHabits = HabitsData()
    var archivedHabits: HabitsData?
    var currentlyShowingType = 0 //0 for curetn habits, 1 for archived
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!{
        didSet{
            backgroundImageView.addBlurEffect()
        }
    }
    
    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    @IBAction func switchArchive(_ sender: UIBarButtonItem) {
        switch currentlyShowingType {
        case 0:
            currentlyShowingType=1
            sender.image=UIImage(systemName: "rectangle.grid.1x2")
        case 1:
            currentlyShowingType=0
            sender.image=UIImage(systemName: "archivebox")
        default:
            print("unknown case")
        }
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {
//            self.tableTopConstraint.isActive=true
//            NSLayoutConstraint.activate([self.tableTopConstraint])
            self.tableTopConstraint.priority = .defaultLow
            self.view.layoutIfNeeded()
        }, completion:{ (something) in
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
//                self.tableTopConstraint.isActive=false
//                NSLayoutConstraint.deactivate([self.tableTopConstraint])
                self.tableTopConstraint.priority = .required
                self.view.layoutIfNeeded()
            }, completion: nil)
        })
        table.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource=self
        table.delegate=self
        table.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //setting darkmode/lightmode/automode
        let interfaceStyle = UserDefaults.standard.integer(forKey: "prefs_is_dark_mode_on")
        if interfaceStyle==0{
            overrideUserInterfaceStyle = .unspecified
        }else if interfaceStyle==1{
            overrideUserInterfaceStyle = .light
        }else if interfaceStyle==2{
            overrideUserInterfaceStyle = .dark
        }
        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.systemTeal ,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 30)!
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
        //TODO: make this happen not in view will appear if causes lags
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("ArchivedHabitCardsData.json"){
            if let jsonData = try? Data(contentsOf: url){
                if let extract = HabitsData(json: jsonData){
                    print("did set self.habits to \(extract)")
                    self.archivedHabits = extract
                }else{
                    print("ERROR: found HabitsData(json: jsonData) to be nil so didn't set it")
                }
            }else{
                print("error no file named habitCardsData.json found")
                self.archivedHabits = HabitsData()
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
        if let archivedHabits = self.archivedHabits{
            jcl=archivedHabits
            if let json = jcl.json {
                if let url = try? FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                ).appendingPathComponent("ArchivedHabitCardsData.json"){
                    do {
                        try json.write(to: url)
                        print ("saved successfully")
                    } catch let error {
                        print ("couldn't save \(error)")
                    }
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
//        habits.cardList[index.row].goalCount=count
        var date = Date()
        if count==0.0{
            habits.cardList[index.row].allEntries.removeValue(forKey: date.startOfDay)
        }else{
            habits.cardList[index.row].allEntries[date.startOfDay]=count
            //Used for debugging
//            var x = Calendar.current.date(byAdding: .day, value:  -(1), to: Date())!.startOfDay
//            habits.cardList[index.row].allEntries[x.startOfDay]=count*2
//            x = Calendar.current.date(byAdding: .day, value:  -(5), to: Date())!.startOfDay
//            habits.cardList[index.row].allEntries[x.startOfDay]=count+6
//            x = Calendar.current.date(byAdding: .day, value:  -(3), to: Date())!.startOfDay
//            habits.cardList[index.row].allEntries[x.startOfDay]=count-3
//            x = Calendar.current.date(byAdding: .day, value:  -(7), to: Date())!.startOfDay
//            habits.cardList[index.row].allEntries[x.startOfDay]=count-4
//            x = Calendar.current.date(byAdding: .day, value:  -(8), to: Date())!.startOfDay
//            habits.cardList[index.row].allEntries[x.startOfDay]=count-4
//            x = Calendar.current.date(byAdding: .day, value:  -(12), to: Date())!.startOfDay
//            habits.cardList[index.row].allEntries[x.startOfDay]=count*2
        }
        
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
//        var startCount=0
//        for entry in habits.cardList[index.row].allEntries{
//            switch habits.cardList[index.row].habitGoalPeriod {
//            case .daily:
//                if date==entry.key.startOfDay{
//                    startCount+=Int(entry.value)
//                }
//            case .weekly:
//                if date==entry.key.startOfWeek{
//                    startCount+=Int(entry.value)
//                }
//            case .monthly:
//                if date==entry.key.startOfMonth{
//                    startCount+=Int(entry.value)
//                }
//            case .yearly:
//                if date==entry.key.startOfYear{
//                    startCount+=Int(entry.value)
//                }
//            }
//        }
//        if startCount==0{
//            habits.cardList[index.row].entriesList.removeValue(forKey: date)
//        }else{
//            habits.cardList[index.row].entriesList[date]=Double(startCount)
//        }
        
        //TODO: check if needed to remove if not very efficient and implement above commented version: recalculates all entriesList
        habits.cardList[index.row].entriesList.removeAll()
        for entry in habits.cardList[index.row].allEntries{
            switch habits.cardList[index.row].habitGoalPeriod {
            case .daily:
                if habits.cardList[index.row].entriesList[entry.key.startOfDay]==nil{
                    habits.cardList[index.row].entriesList[entry.key.startOfDay]=entry.value
                }else{
                    habits.cardList[index.row].entriesList[entry.key.startOfDay]!+=entry.value
                }
            case .weekly:
                if habits.cardList[index.row].entriesList[entry.key.startOfWeek]==nil{
                    habits.cardList[index.row].entriesList[entry.key.startOfWeek]=entry.value
                }else{
                    habits.cardList[index.row].entriesList[entry.key.startOfWeek]!+=entry.value
                }
            case .monthly:
                if habits.cardList[index.row].entriesList[entry.key.startOfMonth]==nil{
                    habits.cardList[index.row].entriesList[entry.key.startOfMonth]=entry.value
                }else{
                    habits.cardList[index.row].entriesList[entry.key.startOfMonth]!+=entry.value
                }
            case .yearly:
                if habits.cardList[index.row].entriesList[entry.key.startOfYear]==nil{
                    habits.cardList[index.row].entriesList[entry.key.startOfYear]=entry.value
                }else{
                    habits.cardList[index.row].entriesList[entry.key.startOfYear]!+=entry.value
                }
            }
        }
        
        //MARK: next lines to be removed used for debugging
        //TODO: next lines to be removed used for debginnh
//        var x = Calendar.current.date(byAdding: .day, value:  -(1), to: Date())!.startOfDay
//        habits.cardList[index.row].entriesList[x]=count.advanced(by: -3.0)
//        x = Calendar.current.date(byAdding: .day, value:  -(2), to: Date())!.startOfDay
//        habits.cardList[index.row].entriesList[x]=count.advanced(by: -1.0)
//        x = Calendar.current.date(byAdding: .day, value:  -(3), to: Date())!.startOfDay
//        habits.cardList[index.row].entriesList[x]=count.advanced(by: -4.0)
//        x = Calendar.current.date(byAdding: .day, value:  -(4), to: Date())!.startOfDay
//        habits.cardList[index.row].entriesList[x]=count.advanced(by: 9.0)
//        x = Calendar.current.date(byAdding: .day, value:  -(5), to: Date())!.startOfDay
//        habits.cardList[index.row].entriesList[x]=count.advanced(by: -1.0)
//        habits.cardList[index.row].constructionDate = x
        
//        table.reloadRows(at: [index], with: .automatic)
//        cell.habitData = habits.cardList[indexPath.row]
        if let cell = table.cellForRow(at: index) as? habitTableViewCell{
            cell.habitData = habits.cardList[index.row]
            print("setting habitData to \(String(describing: cell.habitData))")
            cell.awakeFromNib()
        }
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
        switch currentlyShowingType {
        case 0:
            return habits.cardList.count
        case 1:
            return archivedHabits?.deletedCardList.count ?? 0 //+ archivedHabits.completedCardList.count
        default:
            print("unknown case")
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "habitsCellIdentifier") as! habitTableViewCell
        cell.selectionStyle = .none
        cell.delegate=self
        cell.index=indexPath
        switch currentlyShowingType {
        case 0:
            cell.habitData = habits.cardList[indexPath.row]
        case 1:
            cell.habitData = archivedHabits!.deletedCardList[indexPath.row]
            cell.stepper.isUserInteractionEnabled=false
        default:
            print("unknown case")
        }
        if let lastDate = cell.habitData?.targetDate{
            if Date()>lastDate{
                UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                    var identifiers: [String] = []
                    for notification:UNNotificationRequest in notificationRequests {
                        if notification.identifier == String(describing: (cell.habitData?.UniquIdentifier)) {
                            identifiers.append(notification.identifier)
                        }
                        for i in 0...9{
                            if notification.identifier == String(describing: (cell.habitData?.UniquIdentifier))+String(i) {
                                identifiers.append(notification.identifier)
                            }
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
        switch currentlyShowingType {
        case 0:
            print("just paste below code")
            let action = UIContextualAction(style: .destructive, title: "Archive",
                                            handler: { (action, view, completionHandler) in
                                                print("handle delete")
                                                UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                                                    var identifiers: [String] = []
                                                    for notification:UNNotificationRequest in notificationRequests {
                                                        if notification.identifier == String(describing: (self.habits.cardList[indexPath.row].UniquIdentifier)) {
                                                            identifiers.append(notification.identifier)
                                                        }
                                                        for i in 0...9{
                                                            if notification.identifier == String(describing: (self.habits.cardList[indexPath.row].UniquIdentifier))+String(i) {
                                                                identifiers.append(notification.identifier)
                                                            }
                                                        }
                                                    }
                                                    print("indrow = \(indexPath.row), adn id = \(self.habits.cardList[indexPath.row].UniquIdentifier)")
                                                    print("removing notifs with identifiers \(identifiers)")
                                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:   identifiers)
                                                    DispatchQueue.main.async {
                                                        if self.archivedHabits==nil{
                                                            self.archivedHabits = HabitsData()
                                                        }
                                                        self.archivedHabits!.deletedCardList.append(self.habits.cardList[indexPath.row])
                                                        self.habits.cardList.remove(at: indexPath.row)
                                                        self.table.deleteRows(at: [indexPath], with: .right)
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
                                                            self.habits.cardList[indexPath.row].reminderValue = self.habits.cardList[indexPath.row].reminderValueBeforePausing
                                                            self.setReminder(with: self.habits.cardList[indexPath.row])
                                                        default:
                                                            UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                                                                var identifiers: [String] = []
                                                                for notification:UNNotificationRequest in notificationRequests {
                                                                    if notification.identifier == String(describing: (self.habits.cardList[indexPath.row].UniquIdentifier)) {
                                                                        identifiers.append(notification.identifier)
                                                                    }
                                                                    for i in 0...9{
                                                                        if notification.identifier == String(describing: (self.habits.cardList[indexPath.row].UniquIdentifier))+String(i) {
                                                                            identifiers.append(notification.identifier)
                                                                        }
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
        case 1:
            print("todo: remove from archive put back and set it's reminder")
            let action = UIContextualAction(style: .normal, title: "Unarchive",
                                            handler: { (action, view, completionHandler) in
                                                print("handle Unarchive")
                                                if self.archivedHabits!.deletedCardList[indexPath.row].reminderValue != .notSet,
                                                    self.archivedHabits!.deletedCardList[indexPath.row].firstReminder != nil{
                                                    self.setReminder(with: self.archivedHabits!.deletedCardList[indexPath.row])
                                                }
                                                DispatchQueue.main.async {
                                                    self.habits.cardList.append( self.archivedHabits!.deletedCardList[indexPath.row])
                                                    self.archivedHabits!.deletedCardList.remove(at: indexPath.row)
                                                    self.table.deleteRows(at: [indexPath], with: .left)
                                                }
                                                completionHandler(true)
            })
            action.backgroundColor = .systemTeal
            let delete = UIContextualAction(style: .destructive, title: "Delete",
                                            handler: { (action, view, completionHandler) in
                                                print("handle delete")
                                                DispatchQueue.main.async {
                                                    self.archivedHabits!.deletedCardList.remove(at: indexPath.row)
                                                    self.table.deleteRows(at: [indexPath], with: .automatic)
                                                }
                                                completionHandler(true)
            })
            delete.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [delete, action])
            return configuration
        default:
            print("unknown case")
        }
        return nil
    }

    func setReminder(with card: habitCardData){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == String(describing: (card.UniquIdentifier)) {
                    identifiers.append(notification.identifier)
                }
                for i in 0...9{
                    if notification.identifier == String(describing: (card.UniquIdentifier))+String(i) {
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
                content.title = "Habit Reminder "
                content.sound = .default
                content.body = "You have a reminder for " + card.title
                switch card.habitGoalPeriod {
                case .daily:
                    content.body += "Today"
                case .weekly:
                    content.body += "this week"
                case .monthly:
                    content.body += "this month"
                case .yearly:
                    content.body += "this year"
                }
                
                //                let targetDate = Date().addingTimeInterval(5)
                //TODO: Change according to recurrence
                let targetDate = card.firstReminder!
                print("setting reminder to \(targetDate)")
                var trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],from: targetDate), repeats: false)
                switch card.reminderValue {
                case .daily:
                    print("daily")
                    trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute, .second],from: targetDate), repeats: true)
                    for ind in 0..<7{
                        let tempDate = Calendar.current.date(byAdding: .day, value:  ind, to: targetDate)!
                        let weekDay = Calendar.current.component(.weekday, from: tempDate)
                        print("weekday = \(weekDay)")
                        if card.weekDayArray[weekDay-1]{
                            print("adding reminders with weekday= \(weekDay)")
                            trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.weekday , .hour, .minute, .second],from: tempDate), repeats: true)
                            let request = UNNotificationRequest(identifier: String(describing: (card.UniquIdentifier))+String(ind), content: content, trigger: trigger)
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
                if card.reminderValue != .daily{
                    let request = UNNotificationRequest(identifier: String(describing: (card.UniquIdentifier)), content: content, trigger: trigger)
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
}
