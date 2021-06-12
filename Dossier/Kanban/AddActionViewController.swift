//
//  AddActionViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 18/12/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
protocol AddActionViewControllerProtocol {
    func addAction(newAction: Action)
}
class AddActionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddActionViewControllerProtocol {
    

    var delegate: EditCommandVCProtocol?
    var kanban = Kanban()
    
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
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "setTitleID") as! SetTitleToTVC
            cell.delegate=self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "advanceScheduleID") as! AdvanceScheduledDateTVC
            cell.delegate=self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "setTaskTypeActionID") as! setTaskTypeActionTVC
            cell.delegate=self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "setChecklistItemsID") as! setChecklistItemsToActionTVC
            cell.delegate=self
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "deleteChecklistID") as! DeleteChecklistItemsTVC
            cell.delegate=self
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "removeDudeDateActionID") as! RmoveDueDateTVC
            cell.delegate=self
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "setTagTVCID") as! SetTagActionTableViewCell
            cell.delegate=self
            return cell
//        case 6:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "DeleteCardActionID") as! DeleteCardAutomationTVC
//            cell.delegate=self
//            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func addAction(newAction: Action) {
        delegate?.addAction(newAction: newAction)
        self.dismiss(animated: true, completion: nil)
    }

}

class SetTitleToTVC: UITableViewCell {
    var delegate: AddActionViewControllerProtocol?
    
    @IBOutlet weak var nwTitleTextField: UITextField!
    @IBOutlet weak var plusButtonIV: UIImageView!{
        didSet{
            plusButtonIV.isUserInteractionEnabled=true
            plusButtonIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped)))
        }
    }
    @objc func plusButtonTapped(){
        var newAction = Action(actionType: .setTitleTo)
        if let str = nwTitleTextField.text, str.count>0{
            newAction.newTitleString=str
            delegate?.addAction(newAction: newAction)
        }
    }
}

class AdvanceScheduledDateTVC: UITableViewCell {
    var delegate: AddActionViewControllerProtocol?
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
        var action = Action(actionType: .advanceDueDateByX)
        action.xDays = Int(daysStepper.value)
        action.xHours = Int(hoursStepper.value)
        delegate?.addAction(newAction: action)
    }
}

class setTaskTypeActionTVC: UITableViewCell {
    var delegate: AddActionViewControllerProtocol?
    @IBOutlet weak var plusButtonIV: UIImageView!{
        didSet{
            plusButtonIV.isUserInteractionEnabled=true
            plusButtonIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped)))
        }
    }
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @objc func plusButtonTapped(){
        var newAction = Action(actionType: .setTaskTo)
        switch segmentControl.selectedSegmentIndex {
        case 0:
            newAction.taskType = nil
        case 1:
            newAction.taskType = false
        case 2:
            newAction.taskType = true
        default:
            print("Unknown segment in setTaskTypeActionTVC= \(segmentControl.selectedSegmentIndex)")
        }
        delegate?.addAction(newAction: newAction)
    }
}

class setChecklistItemsToActionTVC: UITableViewCell {
    var delegate: AddActionViewControllerProtocol?
    
    @IBOutlet weak var plusButtonIV: UIImageView!{
        didSet{
            plusButtonIV.isUserInteractionEnabled=true
            plusButtonIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped)))
        }
    }
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @objc func plusButtonTapped(){
        var newAction = Action(actionType: .setChecklistItemsTo)
        if segmentControl.selectedSegmentIndex==0{
            newAction.checkListValue = true
        }else{
            newAction.checkListValue = false
        }
        delegate?.addAction(newAction: newAction)
    }
}

class DeleteChecklistItemsTVC: UITableViewCell {
    var delegate: AddActionViewControllerProtocol?
    
    @IBOutlet weak var plusButtonIV: UIImageView!{
        didSet{
            plusButtonIV.isUserInteractionEnabled=true
            plusButtonIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped)))
        }
    }
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @objc func plusButtonTapped(){
        var newAction = Action(actionType: .deleteChecklistItemsWhichAre)
        if segmentControl.selectedSegmentIndex==0{
            newAction.checkListValue = true
        }else if segmentControl.selectedSegmentIndex==1{
            newAction.checkListValue = false
        }else{
            newAction.checkListValue = nil
        }
        delegate?.addAction(newAction: newAction)
    }
}
class RmoveDueDateTVC: UITableViewCell {
    var delegate: AddActionViewControllerProtocol?
    
    @IBOutlet weak var plusButtonIV: UIImageView!{
        didSet{
            plusButtonIV.isUserInteractionEnabled=true
            plusButtonIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped)))
        }
    }
    @objc func plusButtonTapped(){
        let newAction = Action(actionType: .setDueDateToNone)
        delegate?.addAction(newAction: newAction)
    }
}

class DeleteCardAutomationTVC: UITableViewCell {
    var delegate: AddActionViewControllerProtocol?
    
    @IBOutlet weak var plusButtonIV: UIImageView!{
        didSet{
            plusButtonIV.isUserInteractionEnabled=true
            plusButtonIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped)))
        }
    }
    @objc func plusButtonTapped(){
        let newAction = Action(actionType: .deleteCard)
        delegate?.addAction(newAction: newAction)
    }
}

class SetTagActionTableViewCell: UITableViewCell {
    var delegate: AddActionViewControllerProtocol?
   
    @IBOutlet weak var plusButtonIV: UIImageView!{
        didSet{
            plusButtonIV.isUserInteractionEnabled=true
            plusButtonIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped)))
        }
    }
    @objc func plusButtonTapped(){
        var newAction = Action(actionType: .setTagTo)
        newAction.tagColor=tagColor
        delegate?.addAction(newAction: newAction)
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
    override func awakeFromNib() {
        tagColor=0
    }
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
