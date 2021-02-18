//
//  EditCommandViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 16/12/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
protocol EditCommandVCProtocol {
    func updateCommandName(to title: String)
    func addTrigger(newTrigger: Trigger)
    func addAction(newAction: Action)
}
class EditCommandViewController: UIViewController, EditCommandVCProtocol {
    
    var delegate: addAutomationVCProtocol?
    var command = Command()
    var kanbanFileName = "Inster File Name SKTTC"
    var kanban = Kanban()
    
    var backgroundImage: UIImage?
    @IBOutlet weak var backgroundImageView: UIImageView!{
        didSet{
            backgroundImageView.addBlurEffect(with: .systemUltraThinMaterialDark)
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource=self
            tableView.delegate=self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bgImage = backgroundImage{
            self.backgroundImageView.image=bgImage
        }
        // Do any additional setup after loading the view.
    }
    
    func updateCommandName(to title: String) {
        command.name=title
    }
    func addTrigger(newTrigger: Trigger) {
        print("addTrigger called in EditCommandVC")
        command.condition.append(newTrigger)
        tableView.reloadData()
    }
    
    func addAction(newAction: Action) {
        command.execution.append(newAction)
        tableView.reloadData()
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
    }
    override func viewWillLayoutSubviews() {
        print("Edditcommand gonna retrieve kanban with file: \(kanbanFileName)")
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent(kanbanFileName){
            if let jsonData = try? Data(contentsOf: url){
                if let x = Kanban(json: jsonData){
                    kanban = x
                }else{
                    print("WARNING: COULDN'T UNWRAP JSON DATA TO FIND kanbanData in EditCommand")
                }
            }
            self.tableView.reloadData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.editCommand(to: command)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTriggerSegue"{
            let vc = segue.destination as! AddTriggerViewController
            vc.delegate=self
            print("gonna set addtrigger vc to \(kanban.boards)")
            vc.kanban=self.kanban
        }else if segue.identifier == "AddActionSegue"{
            let vc = segue.destination as! AddActionViewController
            vc.delegate=self
            vc.kanban=self.kanban
        }
    }
}
extension EditCommandViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return command.condition.count+1
        case 2:
            return command.execution.count+1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section==0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "commandTitleID") as! EditCommandTitleTCV
            cell.delegate=self
            cell.textField.text = command.name
            return cell
        }else if indexPath.section==1{
            if indexPath.row==command.condition.count{
                let cell = tableView.dequeueReusableCell(withIdentifier: "addConditionIdentifier")!
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "commandTextCell")!
                cell.textLabel?.text = command.condition[indexPath.row].describingString
                return cell
            }
        }else if indexPath.section==2{
            if indexPath.row==command.execution.count{
                let cell = tableView.dequeueReusableCell(withIdentifier: "addActionIdentifier")!
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "commandTextCell")!
                cell.textLabel?.text = command.execution[indexPath.row].describingString
                return cell
            }
        }
        let cell = UITableViewCell()
        cell.backgroundColor = .systemPink
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor.clear
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemThickMaterial)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        let hvbounds = headerView.bounds
//        blurEffectView.frame = CGRect(x: hvbounds.minX+5, y: hvbounds.minY+5, width: hvbounds.width-10, height: hvbounds.height-10)
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.layer.cornerRadius=10
//        blurEffectView.layer.masksToBounds=true
//        headerView.addSubview(blurEffectView)
        
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 10, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        label.textColor = .white
        switch section {
        case 0:
            label.text = "Name:"
        case 1:
            label.text = "Condition:"
        case 2:
            label.text = "Action:"
        default:
            label.text = "Unknown section"
        }
        headerView.addSubview(label)
        
        return headerView
    }
    
}

class EditCommandTitleTCV: UITableViewCell, UITextFieldDelegate{
    var delegate: EditCommandVCProtocol?
    @IBOutlet weak var textField: UITextField!{
        didSet{
            textField.delegate=self
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.updateCommandName(to: textField.text ?? "")
    }
}
