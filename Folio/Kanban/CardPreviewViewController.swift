//
//  CardPreviewViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 12/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//
import UIKit
protocol cardPreviewProtocol {
    func saveCard(to newCard: KanbanCard)
}
protocol cardPreviewTableProtocol {
    func updateHeights()
    func updateTitle(to text: String)
    func updateNotes(to text: String)
    func updateReminder(to date: Date?)
    func updateScheduledDate(to date: Date?)
    func showFullChecklist(show: Bool)
    func addChecklistItem(text: String)
    func updateChecklistItem(item: CheckListItem)
}
class CardPreviewViewController: UIViewController {
    var delegate: cardPreviewProtocol?
    var card = KanbanCard()
    var showChecklist = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource=self
            tableView.delegate=self
        }
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func donePressed(_ sender: Any) {
        delegate?.saveCard(to: card)
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension CardPreviewViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var ret = 5
        if showChecklist{
            ret += (card.checkList.items.count)
            ret+=1
        }
        return ret
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell=tableView.dequeueReusableCell(withIdentifier: "titleCell") as! titleCellCardPreview
            cell.textView.text = card.title
            cell.delegate=self
            return cell
        case 1:
            let cell=tableView.dequeueReusableCell(withIdentifier: "noteCell") as! notesCellCardPreview
            cell.textView.text = card.notes
            cell.delegate=self
            return cell
        case 2:
            let cell=tableView.dequeueReusableCell(withIdentifier: "dateCell") as! dateCellCardPreview
            cell.delegate=self
            cell.date=card.scheduledDate
            cell.updateLook()
            return cell
        case 3:
            let cell=tableView.dequeueReusableCell(withIdentifier: "reminderCell") as! reminderCellCardPreview
            cell.delegate=self
            cell.reminderDate=card.reminderDate
            cell.updateLook()
            return cell
        case 4:
            let cell=tableView.dequeueReusableCell(withIdentifier: "checkListCell") as! checkListCellCardPreview
            cell.delegate=self
            return cell
        default:
            print("xyz")
        }
        if showChecklist{
            if indexPath.row < 5+(card.checkList.items.count){
//                let cell=UITableViewCell()
//                cell.backgroundColor = .green
                let cell=tableView.dequeueReusableCell(withIdentifier: "checkListItemCell") as! checkListItemCell
                cell.delegate=self
                cell.item=card.checkList.items[indexPath.row-5]
                cell.setupCell()
                return cell
            }
            if indexPath.row == 5+(card.checkList.items.count){
                let cell=tableView.dequeueReusableCell(withIdentifier: "addCheckListCell") as! addCheckListItemCell
                cell.delegate=self
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
extension CardPreviewViewController: cardPreviewTableProtocol{
    func updateChecklistItem(item: CheckListItem) {
        for ind in card.checkList.items.indices{
            if card.checkList.items[ind].uid == item.uid{
                card.checkList.items[ind]=item
                break
            }
        }
    }
    
    
    func addChecklistItem(text: String) {
        let x = CheckListItem(item: text, done: false)
        card.checkList.items.append(x)
        
        tableView.reloadData()
    }
    
    func showFullChecklist(show: Bool) {
        showChecklist=show
        tableView.reloadData()
    }

    
    func updateScheduledDate(to date: Date?) {
        self.card.scheduledDate=date
    }
    
    func updateReminder(to date: Date?){
        self.card.reminderDate=date
    }
    
    func updateNotes(to text: String) {
        self.card.notes=text
    }
    
    func updateTitle(to text: String) {
        self.card.title=text
    }
    
    func updateHeights() {
        // Disabling animations gives us our desired behaviour
        UIView.setAnimationsEnabled(false)
        /* These will causes table cell heights to be recaluclated,
         without reloading the entire cell */
        tableView.beginUpdates()
        tableView.endUpdates()
        // Re-enable animations
        UIView.setAnimationsEnabled(true)
    }
}
class titleCellCardPreview: UITableViewCell, UITextViewDelegate{
    var delegate: cardPreviewTableProtocol?
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.delegate=self
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        delegate?.updateHeights()
        delegate?.updateTitle(to: textView.text)
    }
}
class notesCellCardPreview: UITableViewCell, UITextViewDelegate{
    var delegate: cardPreviewTableProtocol?
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.delegate=self
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        delegate?.updateHeights()
        delegate?.updateNotes(to: textView.text)
    }
}
class reminderCellCardPreview: UITableViewCell{
    var delegate: cardPreviewTableProtocol?
    var reminderDate: Date?
    
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn{
            datePicker.isHidden=false
            reminderDate=datePicker.date
        }else{
            datePicker.isHidden=true
            reminderDate=nil
        }
        delegate?.updateHeights()
        delegate?.updateReminder(to: reminderDate)
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        if reminderSwitch.isOn{
            reminderDate = datePicker.date
        }else{
            reminderDate=nil
        }
        delegate?.updateReminder(to: reminderDate)
    }
    func updateLook(){
        if reminderDate==nil{
            reminderSwitch.setOn(false, animated: true)
            datePicker.isHidden=true
        }else{
            datePicker.setDate(reminderDate!, animated: true)
            reminderSwitch.setOn(true, animated: true)
            datePicker.isHidden=false
        }
        delegate?.updateHeights()
    }
    
}

class dateCellCardPreview: UITableViewCell{
    var delegate: cardPreviewTableProtocol?
    var date: Date?
    
    
    @IBOutlet weak var scheduleDateSwitch: UISwitch!
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn{
            datePicker.isHidden=false
            date=datePicker.date
        }else{
            datePicker.isHidden=true
            date=nil
        }
        delegate?.updateHeights()
        delegate?.updateScheduledDate(to: date)
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        if scheduleDateSwitch.isOn{
            date = datePicker.date
        }else{
            date=nil
        }
        delegate?.updateScheduledDate(to: date)
    }
    func updateLook(){
        if date==nil{
            scheduleDateSwitch.setOn(false, animated: true)
            datePicker.isHidden=true
        }else{
            datePicker.setDate(date!, animated: true)
            scheduleDateSwitch.setOn(true, animated: true)
            datePicker.isHidden=false
        }
        delegate?.updateHeights()
    }
    
}
class checkListCellCardPreview: UITableViewCell{
    var delegate: cardPreviewTableProtocol?
    @IBOutlet weak var expandCheckList: UIImageView!{
        didSet{
            expandCheckList.isUserInteractionEnabled=true
            expandCheckList.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleCheckList)))
        }
    }
    @IBOutlet weak var checkLIstPref: UIImageView!
    var checList: CheckListData?
    @objc func toggleCheckList(){
        if expandCheckList.image == UIImage(systemName: "chevron.down.circle"){
            expandCheckList.image = UIImage(systemName: "chevron.up.circle")
            delegate?.showFullChecklist(show: true)
        }else{
            expandCheckList.image = UIImage(systemName: "chevron.down.circle")
            delegate?.showFullChecklist(show: false)
        }
        delegate?.updateHeights()
    }
}
class checkListItemCell: UITableViewCell, UITextViewDelegate{
    var delegate: cardPreviewTableProtocol?
    var item = CheckListItem()
    @IBOutlet weak var doneButton: UIImageView!{
        didSet{
            doneButton.isUserInteractionEnabled=true
            doneButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doneButtonTapped)))
        }
    }
    @IBOutlet weak var textview: UITextView!{
        didSet{
            textview.delegate=self
        }
    }
    @objc func doneButtonTapped(){
        item.done = !item.done
        delegate?.updateChecklistItem(item: item)
        setupCell()
    }
    func setupCell(){
        textview.text = item.item
        if item.done{
            doneButton.image = UIImage(systemName: "largecircle.fill.circle")
        }else{
            doneButton.image = UIImage(systemName: "circle")
        }
        delegate?.updateHeights()
    }
    func textViewDidChange(_ textView: UITextView) {
        item.item=textview.text
        delegate?.updateHeights()
        delegate?.updateChecklistItem(item: item)
    }
}
class addCheckListItemCell: UITableViewCell, UITextViewDelegate{
    var delegate: cardPreviewTableProtocol?
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.delegate=self
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        print("update heightys")
        delegate?.updateHeights()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("add the cell")
        if textView.text.count>0{
            delegate?.addChecklistItem(text: textView.text)
        }
        textView.text=""
    }
}

