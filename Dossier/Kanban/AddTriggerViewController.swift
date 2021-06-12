//
//  AddTriggerViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 17/12/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
protocol AddTriggerViewControllerProtocol {
    func addTrigger(newTrigger: Trigger)
}

class AddTriggerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddTriggerViewControllerProtocol {
    
    var delegate: EditCommandVCProtocol?
    var kanban = Kanban(){
        didSet{
            print("addtrigger kanban: \(kanban.boards)")
        }
    }

    @IBOutlet var backgroundView: UIView!{
        didSet{
            backgroundView.addBlurEffect(with: .systemChromeMaterial)
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
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "beforeScheduleID") as! BeforeScheduledDate
            cell.delegate=self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ifFromBoardID") as! IfFromBoardTVC
            cell.delegate=self
            cell.kanban=self.kanban
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ifTaskTypeID") as! IfTaskTypeTVC
            cell.delegate=self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "isContatinsIntTitleID") as! isContainsInTitleTVC
            cell.delegate=self
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "hasChecklistItemsID") as! hasChecklistWithAllItemsTVC
            cell.delegate=self
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "hasTagTVCID") as! HasTagTableViewCell
            cell.delegate=self
            return cell
//        case 6:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HasURLTVCID") as! HasURLTableViewCell
//            cell.delegate=self
//            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func addTrigger(newTrigger: Trigger) {
        delegate?.addTrigger(newTrigger: newTrigger)
        self.dismiss(animated: true, completion: nil)
    }
}

class BeforeScheduledDate: UITableViewCell {
    var delegate: AddTriggerViewControllerProtocol?
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    
    @IBOutlet weak var daysStepper: UIStepper!
    @IBAction func daysChanged(_ sender: UIStepper) {
        daysLabel.text = "\(Int(sender.value)) Days"
    }
    @IBOutlet weak var hoursStepper: UIStepper!
    @IBAction func hoursChanged(_ sender: UIStepper) {
        hoursLabel.text = "\(Int(sender.value)) Hours"
    }
    
    @IBOutlet weak var plusButtonIV: UIImageView!{
        didSet{
            plusButtonIV.isUserInteractionEnabled=true
            plusButtonIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped)))
        }
    }
    
    @objc func plusButtonTapped(){
        var trigger = Trigger(triggerType: .xBeforeSchedule)
        trigger.daysBeforeSchedule=Int(daysStepper.value)
        trigger.hoursBeforeSchedule=Int(hoursStepper.value)
        delegate?.addTrigger(newTrigger: trigger)
    }
}

class IfFromBoardTVC: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1+kanban.boards.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0{
            return "Not Selected"
        }else{
            return kanban.boards[row-1].title
        }
    }
    var delegate: AddTriggerViewControllerProtocol?
    var kanban = Kanban()
    @IBOutlet weak var pickerView: UIPickerView!{
        didSet{
            pickerView.dataSource=self
            pickerView.delegate=self
        }
    }
    @IBOutlet weak var plusButtonIV: UIImageView!{
        didSet{
            plusButtonIV.isUserInteractionEnabled=true
            plusButtonIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped)))
        }
    }
    
    @objc func plusButtonTapped(){
        if pickerView.selectedRow(inComponent: 0)>0{
            var trigger = Trigger(triggerType: .ifFromBoard)
            trigger.fromBoard = kanban.boards[pickerView.selectedRow(inComponent: 0)-1].title
            delegate?.addTrigger(newTrigger: trigger)
        }
    }
}

class IfTaskTypeTVC: UITableViewCell {
    var delegate: AddTriggerViewControllerProtocol?
    @IBOutlet weak var plusButtonIV: UIImageView!{
        didSet{
            plusButtonIV.isUserInteractionEnabled=true
            plusButtonIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped)))
        }
    }
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @objc func plusButtonTapped(){
        var trigger = Trigger(triggerType: .ifTaskType)
        if segmentControl.selectedSegmentIndex==0{
            trigger.taskType = nil
        }else if segmentControl.selectedSegmentIndex==1{
            trigger.taskType = false
        }else{
            trigger.taskType = true
        }
        delegate?.addTrigger(newTrigger: trigger)
    }
}

class isContainsInTitleTVC: UITableViewCell {
    var delegate: AddTriggerViewControllerProtocol?
    @IBOutlet weak var plusButtonIV: UIImageView!{
        didSet{
            plusButtonIV.isUserInteractionEnabled=true
            plusButtonIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped)))
        }
    }
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var textField: UITextField!
    
    @objc func plusButtonTapped(){
        if let str = textField.text, str.count>0{
            var trigger = Trigger(triggerType: .ifTilteIs)
            if segmentControl.selectedSegmentIndex==1{
                trigger.triggerType = .ifTitleContains
            }
            trigger.titleString = str
            delegate?.addTrigger(newTrigger: trigger)
        }
    }
}

class hasChecklistWithAllItemsTVC: UITableViewCell {
    var delegate: AddTriggerViewControllerProtocol?
    @IBOutlet weak var plusButtonIV: UIImageView!{
        didSet{
            plusButtonIV.isUserInteractionEnabled=true
            plusButtonIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped)))
        }
    }
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @objc func plusButtonTapped(){
        var trigger = Trigger(triggerType: .ifChecklistHasAllComplete)
        if segmentControl.selectedSegmentIndex==1{
            trigger.triggerType = .ifChecklistHasAllIncomplete
        }
        delegate?.addTrigger(newTrigger: trigger)
    }
}
class HasTagTableViewCell: UITableViewCell {
    var delegate: AddTriggerViewControllerProtocol?
    @IBOutlet weak var plusButtonIV: UIImageView!{
        didSet{
            plusButtonIV.isUserInteractionEnabled=true
            plusButtonIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped)))
        }
    }
    @objc func plusButtonTapped(){
        var trigger = Trigger(triggerType: .ifHasTag)
        trigger.tagColor = self.tagColor
        delegate?.addTrigger(newTrigger: trigger)
    }
    @IBOutlet weak var stackView: UIStackView!
    var tagColor: Int=0{
        didSet{
            for ind in 0...9{
                if ind==tagColor{
                    labelButtons[ind].backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.219396682)
                }else{
                    labelButtons[ind].backgroundColor = .clear
                }
            }
        }
    }
    @IBOutlet var labelButtons: [UIButton]!
    
    @IBAction func but0(_ sender: Any) {
        tagColor=0
    }
    @IBAction func but1(_ sender: Any) {
        tagColor=1
    }
    @IBAction func but2(_ sender: Any) {
        tagColor=2
    }
    @IBAction func but3(_ sender: Any) {
        tagColor=3
    }
    @IBAction func but4(_ sender: Any) {
        tagColor=4
    }
    @IBAction func but5(_ sender: Any) {
        tagColor=5
    }
    @IBAction func but6(_ sender: Any) {
        tagColor=6
    }
    @IBAction func but7(_ sender: Any) {
        tagColor=7
    }
    @IBAction func but8(_ sender: Any) {
        tagColor=8
    }
    @IBAction func but9(_ sender: Any) {
        tagColor=9
    }
}

class HasURLTableViewCell: UITableViewCell {
    var delegate: AddTriggerViewControllerProtocol?
    @IBOutlet weak var plusButtonIV: UIImageView!{
        didSet{
            plusButtonIV.isUserInteractionEnabled=true
            plusButtonIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped)))
        }
    }
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @objc func plusButtonTapped(){
        var trigger = Trigger(triggerType: .ifHasURLSetTo)
        if segmentControl.selectedSegmentIndex==0{
            trigger.hasURL=false
        }else{
            trigger.hasURL=true
        }
        delegate?.addTrigger(newTrigger: trigger)
    }
}

class AnotherTableViewCell: UITableViewCell {
    var delegate: AddTriggerViewControllerProtocol?
    @IBOutlet weak var plusButtonIV: UIImageView!{
        didSet{
            plusButtonIV.isUserInteractionEnabled=true
            plusButtonIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped)))
        }
    }
    @objc func plusButtonTapped(){
        
    }
}
