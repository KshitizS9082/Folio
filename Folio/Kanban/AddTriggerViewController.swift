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
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
            trigger.fromBoard = kanban.boards[pickerView.selectedRow(inComponent: 0)-1].uid
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
