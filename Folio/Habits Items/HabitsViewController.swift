//
//  HabitsViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
protocol habitsVCProtocol {
    func addHabitCard(_ newCard: habitCardData)
    func changeHabitCurentCount(at index: IndexPath, to count: Double)
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
            NSAttributedString.Key.foregroundColor: UIColor(named: "mainTextColor") ,
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
        
//        var x = Calendar.current.date(byAdding: .month, value:  -(1), to: Date())!.startOfMonth
//        habits.cardList[index.row].entriesList[x]=count.advanced(by: -3.0)
//        x = Calendar.current.date(byAdding: .month, value:  -(2), to: Date())!.startOfMonth
//        habits.cardList[index.row].entriesList[x]=count.advanced(by: -1.0)
//        x = Calendar.current.date(byAdding: .month, value:  -(3), to: Date())!.startOfMonth
//        habits.cardList[index.row].entriesList[x]=count.advanced(by: -4.0)
//        x = Calendar.current.date(byAdding: .month, value:  -(5), to: Date())!.startOfMonth
//        habits.cardList[index.row].entriesList[x]=count.advanced(by: -1.0)
        
        table.reloadRows(at: [index], with: .automatic)
        print("dict = \( habits.cardList[index.row].entriesList)")
    }
    
    func addHabitCard(_ newCard: habitCardData) {
        print("add new card \(newCard)")
        habits.cardList.append(newCard)
        table.reloadData()
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
        cell.backgroundColor = .clear
        cell.awakeFromNib()
        return cell
    }
    
    
}
