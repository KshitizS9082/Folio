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
    func setReminderValue(_ reminderValue: habitCardData.ReminderTime)
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleDoneButton(_ sender: Any) {
        print("in handle done")
        if card.title.count>0{
            delegate?.addHabitCard(card)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
    
    func setReminderValue(_ reminderValue: habitCardData.ReminderTime) {
        self.card.reminderValue = reminderValue
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
    
}
