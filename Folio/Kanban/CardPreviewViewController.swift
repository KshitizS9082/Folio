//
//  CardPreviewViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 12/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//
import UIKit
import ImagePicker
import SafariServices


protocol cardPreviewTableProtocol {
    func updateHeights()
    func updateTitle(to text: String)
    func updateNotes(to text: String)
    func updateReminder(to date: Date?)
    func updateScheduledDate(to date: Date?)
    func showFullChecklist(show: Bool)
    func toggleEdittingChecklistRows()
    func addChecklistItem(text: String)
    func updateChecklistItem(item: CheckListItem)
    func preseintViewController(vc: UIViewController)
    func updateMediaLinks(to links: [String])
    func updateURL(to newURL: String)
    func openURL(urlString: String)
    func updateTask(to taskVal: Bool?)
    func updateTagColor(to tagColor: Int)
    func deleteCard()
    func showNotificationNotPresentAlert()
}
class CardPreviewViewController: UIViewController {
    var delegate: cardPreviewProtocol?
    var card = KanbanCard()
    var showChecklist = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register for notifications when the keyboard appears:
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @IBOutlet weak var backgroundView: UIView!{
        didSet{
            backgroundView.layer.masksToBounds=true
            backgroundView.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemChromeMaterial)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = backgroundView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundView.addSubview(blurEffectView)
            backgroundView.sendSubviewToBack(blurEffectView)
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource=self
            tableView.delegate=self
            tableView.dragInteractionEnabled=true
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        delegate?.saveCard(to: card)
        self.dismiss(animated: true, completion: nil)
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
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.saveCard(to: card)
    }
    @objc func keyboardWillShow( note:NSNotification ){
        // read the CGRect from the notification (if any)
        if let newFrame = (note.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height, right: 0 )
            tableView.contentInset = insets
            tableView.scrollIndicatorInsets = insets
            UIView.animate(withDuration: 0.25) {
                self.tableView.layoutIfNeeded()
                self.tableView.layoutIfNeeded()
            }
        }
    }
    
    func setCardReminderNotif(){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == self.card.UniquIdentifier.uuidString {
                    identifiers.append(notification.identifier)
                }
            }
            print("removing notifs with identifiers \(identifiers)")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        
        if let date = card.reminderDate{
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = "Kanban: \(card.title)"
            content.body = card.notes ?? "Kanban Reminder"
            content.categoryIdentifier = "kanban"
            //                content.userInfo = ["customData": "fizzbuzz"]
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],from: date), repeats: false)
            
            let request = UNNotificationRequest(identifier: card.UniquIdentifier.uuidString, content: content, trigger: trigger)
            center.add(request)
        }
    }
    
}
extension CardPreviewViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var ret = 6+1+1+1+1
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
            cell.delegate=self
            cell.textView.text = card.title
            cell.initiateTextViewWithPlaceholder()
            return cell
        case 1:
            let cell=tableView.dequeueReusableCell(withIdentifier: "noteCell") as! notesCellCardPreview
            cell.delegate=self
            cell.textView.text = card.notes
            cell.initiateTextViewWithPlaceholder()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskType") as! taskTypeCardPreview
            cell.delegate=self
            cell.isTask=card.isTask
            cell.updateSegments()
            return cell
        case 3:
            let cell=tableView.dequeueReusableCell(withIdentifier: "dateCell") as! dateCellCardPreview
            cell.delegate=self
            cell.date=card.scheduledDate
            cell.updateLook()
            return cell
        case 4:
            let cell=tableView.dequeueReusableCell(withIdentifier: "reminderCell") as! reminderCellCardPreview
            cell.delegate=self
            cell.reminderDate=card.reminderDate
            cell.updateLook()
            return cell
        case 5:
            let cell=tableView.dequeueReusableCell(withIdentifier: "checkListCell") as! checkListCellCardPreview
            cell.delegate=self
            return cell
        default:
            print("xyz")
        }
        var postCheckListStartpoint=6
        if showChecklist{
            postCheckListStartpoint=6+(card.checkList.items.count)+1
            if indexPath.row < 6+(card.checkList.items.count){
//                let cell=UITableViewCell()
//                cell.backgroundColor = .green
                let cell=tableView.dequeueReusableCell(withIdentifier: "checkListItemCell") as! checkListItemCell
                cell.delegate=self
                cell.item=card.checkList.items[indexPath.row-6]
                cell.setupCell()
                return cell
            }
            if indexPath.row == 6+(card.checkList.items.count){
                let cell=tableView.dequeueReusableCell(withIdentifier: "addCheckListCell") as! addCheckListItemCell
                cell.delegate=self
                
                cell.initiateTextViewWithPlaceholder()
                return cell
            }
        }
        if indexPath.row==postCheckListStartpoint{
            let cell=tableView.dequeueReusableCell(withIdentifier: "addMediaKabanId") as! addMediaKabanCell
            cell.delegate=self
            cell.mediaLinks = card.mediaLinks
            return cell
        }
        if indexPath.row==postCheckListStartpoint+1{
            let cell=tableView.dequeueReusableCell(withIdentifier: "urlKanbanCell") as! addURLKabanCell
            cell.delegate=self
            cell.textField.text = card.linkURL
            return cell
        }
        if indexPath.row==postCheckListStartpoint+2{
            let cell=tableView.dequeueReusableCell(withIdentifier: "labelCell") as! labelKanbanCell
            cell.delegate=self
            cell.tagColor=card.tagColor
            cell.setupCell()
            return cell
        }
        if indexPath.row==postCheckListStartpoint+3{
            let cell=tableView.dequeueReusableCell(withIdentifier: "deleteCell") as! deleteKanbanCell
            cell.delegate=self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let ret = 6
        if (!showChecklist) || indexPath.row<ret || indexPath.row >= ret+(card.checkList.items.count){
            let configuration = UISwipeActionsConfiguration()
            return configuration
        }
        let action = UIContextualAction(style: .destructive, title: "Delete",
                                        handler: { (action, view, completionHandler) in
                                            self.card.checkList.items.remove(at: indexPath.row-6)
                                            self.tableView.beginUpdates()
                                            self.tableView.deleteRows(at: [indexPath], with: .automatic)
                                            self.tableView.endUpdates()
                                            completionHandler(true)
        })
        action.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    //Moving and reordering checklist items
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let ret = 6
        if (!showChecklist) || indexPath.row<ret || indexPath.row >= ret+(card.checkList.items.count){
            return false
        }else{
            return true
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let ret = 6
        if (!showChecklist) || indexPath.row<ret || indexPath.row >= ret+(card.checkList.items.count){
            return false
        }else{
            return true
        }
    }
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        var returnVal = proposedDestinationIndexPath
        var dest = proposedDestinationIndexPath.row-6
        if dest > (card.checkList.items.count)-1{
            dest = (card.checkList.items.count)-1
        }
        if dest < 0{
            dest = 0
        }
        returnVal = IndexPath(row: dest+6, section: 0)
        return returnVal
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let source = sourceIndexPath.row-6
        var dest = destinationIndexPath.row-6
        if dest > (card.checkList.items.count)-1{
            dest = (card.checkList.items.count)-1
        }
        if dest < 0{
            dest = 0
        }
        let data = self.card.checkList.items.remove(at: source)
        self.card.checkList.items.insert(data, at: dest)
    }
}
extension CardPreviewViewController: cardPreviewTableProtocol{
    func toggleEdittingChecklistRows() {
        self.tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    func updateTagColor(to tagColor: Int) {
        card.tagColor = tagColor
    }
    
    func updateTask(to taskVal: Bool?) {
        card.isTask = taskVal
    }
    
    func deleteCardFinal(){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == self.card.UniquIdentifier.uuidString {
                    identifiers.append(notification.identifier)
                }
            }
            print("removing notifs with identifiers \(identifiers)")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        let fileManager = FileManager.default
        for fileName in self.card.mediaLinks{
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(fileName){
                do{
                    try fileManager.removeItem(at: url)
                    print("deleted item \(url) succefully")
                } catch{
                    print("ERROR: item  at \(url) couldn't be deleted")
                    return
                }
            }
        }
        delegate?.deleteCard(newCard: self.card)
        self.dismiss(animated: true, completion: nil)
    }
    func deleteCard() {
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive){
            UIAlertAction in
            self.deleteCardFinal()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        let alert = UIAlertController(title: "Delete Card?", message: "Deleting this card will also delete it's data", preferredStyle: .actionSheet)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openURL(urlString: String) {
        guard let url = URL(string: urlString) else {
            // not a valid URL
            return
        }
        
        if ["http", "https"].contains(url.scheme?.lowercased() ?? "") {
            // Can open with SFSafariViewController
            print("opening with SFSafariViewController")
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
        } else {
            // Scheme is not supported or no scheme is given, use openURL
//            print("openeing other way")
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
            let urlStr = "http://"+urlString
            guard let urls = URL(string: urlStr) else {
                // not a valid URL
                return
            }
            let safariViewController = SFSafariViewController(url: urls)
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
    
    
    func updateURL(to newURL: String) {
        card.linkURL = newURL
    }
    
    func updateMediaLinks(to links: [String]) {
        card.mediaLinks = links
    }
    
    func preseintViewController(vc: UIViewController) {
        self.present(vc, animated: true, completion: nil)
    }
    
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
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 6+(card.checkList.items.count)-1, section: 0)], with: .automatic)
        tableView.endUpdates()
//        tableView.reloadData()
    }
    
    func showFullChecklist(show: Bool) {
        showChecklist=show
        tableView.beginUpdates()
        if show{
            var indexes = [IndexPath]()
            for ind in 6...(6+card.checkList.items.count){
                indexes.append(IndexPath(row: ind, section: 0))
            }
            tableView.insertRows(at: indexes, with: .automatic)
        }else{
            self.tableView.setEditing(false, animated: true)
            var indexes = [IndexPath]()
            for ind in 6...(6+card.checkList.items.count){
                indexes.append(IndexPath(row: ind, section: 0))
            }
            tableView.deleteRows(at: indexes, with: .automatic)
        }
        tableView.endUpdates()
    }

    
    func updateScheduledDate(to date: Date?) {
        self.card.scheduledDate=date
    }
    
    func updateReminder(to date: Date?){
        self.card.reminderDate=date
        self.setCardReminderNotif()
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
    //for placeholder
    func initiateTextViewWithPlaceholder(){
        if textView.text.isEmpty{
            textView.text = "Add Title..."
            textView.textColor = UIColor.systemGray
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        initiateTextViewWithPlaceholder()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
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
    //for placeholder
    func initiateTextViewWithPlaceholder(){
        if textView.text.isEmpty{
            textView.text = "Add Notes..."
            textView.textColor = UIColor.systemGray
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        initiateTextViewWithPlaceholder()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}
class taskTypeCardPreview: UITableViewCell {
    var delegate: cardPreviewTableProtocol?
    var isTask: Bool?
    @IBOutlet weak var segmentControl: UISegmentedControl!
    func updateSegments(){
        if let val = isTask{
            if val{
                segmentControl.selectedSegmentIndex = 2
            }else{
                segmentControl.selectedSegmentIndex = 1
            }
        }else{
            segmentControl.selectedSegmentIndex = 0
        }
    }
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            isTask=nil
        case 1:
            isTask=false
        case 2:
            isTask=true
        default:
            print("not possible to enter 363")
        }
        delegate?.updateTask(to: isTask)
    }
    
}

class reminderCellCardPreview: UITableViewCell{
    var delegate: cardPreviewTableProtocol?
    var reminderDate: Date?
    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBAction func switchChanged(_ sender: UISwitch) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
                DispatchQueue.main.sync {
                    if sender.isOn{
                        self.datePicker.isHidden=false
                        self.reminderDate=self.datePicker.date
                    }else{
                        self.datePicker.isHidden=true
                        self.reminderDate=nil
                    }
                    self.updateLook()
                    self.delegate?.updateReminder(to: self.reminderDate)
                }
            } else {
                DispatchQueue.main.sync {
                    self.reminderSwitch.setOn(false, animated: true)
                    self.delegate?.showNotificationNotPresentAlert()
                }
            }
        }
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
            datePickerHeightConstraint.constant=0
        }else{
            datePicker.setDate(reminderDate!, animated: true)
            reminderSwitch.setOn(true, animated: true)
            if #available(iOS 14, *){
                datePickerHeightConstraint.constant = 35
            }else{
                datePickerHeightConstraint.constant = 200
            }
            datePicker.isHidden=false
        }
        delegate?.updateHeights()
    }
    
}

class dateCellCardPreview: UITableViewCell{
    var delegate: cardPreviewTableProtocol?
    var date: Date?
    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var scheduleDateSwitch: UISwitch!
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn{
            datePicker.isHidden=false
            date=datePicker.date
        }else{
            datePicker.isHidden=true
            date=nil
        }
//        delegate?.updateHeights()
        updateLook()
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
            datePickerHeightConstraint.constant = 0
            datePicker.isHidden=true
        }else{
            datePicker.setDate(date!, animated: true)
            scheduleDateSwitch.setOn(true, animated: true)
            if #available(iOS 14, *){
                datePickerHeightConstraint.constant = 35
            }else{
                datePickerHeightConstraint.constant = 200
            }
            datePicker.isHidden=false
        }
        delegate?.updateHeights()
    }
    
}
class checkListCellCardPreview: UITableViewCell{
    var delegate: cardPreviewTableProtocol?
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
    @IBOutlet weak var expandCheckList: UIImageView!{
        didSet{
            expandCheckList.isUserInteractionEnabled=true
            expandCheckList.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleCheckList)))
        }
    }
    @IBOutlet weak var checkLIstPref: UIImageView!{
        didSet{
            checkLIstPref.isUserInteractionEnabled=true
            checkLIstPref.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setEditting)))
        }
    }
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
    @objc func setEditting(){
        delegate?.toggleEdittingChecklistRows()
    }
}
class checkListItemCell: UITableViewCell, UITextViewDelegate{
    var delegate: cardPreviewTableProtocol?
    var item = CheckListItem()
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
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
            doneButton.image = UIImage(systemName: "largecircle.fill.circle", withConfiguration: largeConfig)
        }else{
            doneButton.image = UIImage(systemName: "circle", withConfiguration: largeConfig)
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
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)

    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.delegate=self
        }
    }
    
    @IBOutlet weak var addCLImage: UIImageView!
    func initiateTextViewWithPlaceholder(){
        addCLImage.image = UIImage(systemName: "plus.circle", withConfiguration: largeConfig)
        textView.text = "Add item..."
        textView.textColor = UIColor.systemBlue
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
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.systemBlue
        }
        textView.text=nil
        initiateTextViewWithPlaceholder()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemBlue {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}

class addMediaKabanCell: UITableViewCell{
    var mediaLinks = [String]()
    var delegate: cardPreviewTableProtocol?
    @IBOutlet weak var addImageButton: UIImageView!{
        didSet{
            addImageButton.isUserInteractionEnabled=true
            addImageButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addImage)))
        }
    }
    @objc func addImage(){
        print("add image")
        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 1
        imagePickerController.delegate = self
        delegate?.preseintViewController(vc: imagePickerController)
    }
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.dataSource=self
            collectionView.delegate=self
        }
    }
    override func awakeFromNib() {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        if collectionView != nil{
//            self.collectionView.collectionViewLayout = layout
//            self.collectionView!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:0, right: 0)
//            self.collectionView.isPagingEnabled=true
//            if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//                layout.minimumInteritemSpacing = spacings
//                layout.minimumLineSpacing = spacings
//                layout.itemSize = CGSize(width: self.collectionView.frame.size.height-spacings, height: self.collectionView.frame.size.height-spacings)
//                layout.invalidateLayout()
//            }
//            collectionView.reloadData()
//        }
    }
    var spacings: CGFloat{
        return 10.0
    }
}
class mediaKabanPreviewCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
    func setImageLink(fileName: String){
        DispatchQueue.global(qos: .background).async {
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(fileName){
                if let jsonData = try? Data(contentsOf: url){
                    if let extract = imageData(json: jsonData){
                        let x=extract.data
                        if let image = UIImage(data: x){
                            DispatchQueue.main.async {
                                self.imageView.image = image
                            }
                        }
                    }else{
                        print("couldnt get json from URL")
                    }
                }
            }
        }
    }
}
extension addMediaKabanCell: UICollectionViewDataSource, ImagePickerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCVC", for: indexPath) as! mediaKabanPreviewCollectionViewCell
        
        cell.layer.cornerRadius=imageCornerRadius
        cell.layer.masksToBounds=true
        cell.setImageLink(fileName: mediaLinks[indexPath.row])
        cell.imageView.setupImageViewer()
//        cell.imageView.setupImageViewer(images: allImages, initialIndex: indexPath.item)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 75)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.expandGalleryView()
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("done")
        let fileName=String.uniqueFilename(withPrefix: "kabanCardImageData")+".json"
        if images.count>0{
            let image = images[0]
            if let json = imageData(instData: (image.resizedTo1MB()!).pngData()!).json {
                if let url = try? FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                ).appendingPathComponent(fileName){
                    do {
                        try json.write(to: url)
                        print ("saved successfully")
                        //MARK: is a data leak to be corrected
                        //TODO: sometimes fileName added but not deleted
                        self.mediaLinks.append(fileName)
                        self.delegate?.updateMediaLinks(to: self.mediaLinks)
                        self.collectionView.reloadData()
                    } catch let error {
                        print ("couldn't save \(error)")
                    }
                }
            }
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("delete")
    }
    
    var imageCornerRadius: CGFloat{
        return 6.0
    }
}

class addURLKabanCell: UITableViewCell{
    var delegate: cardPreviewTableProtocol?
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var linkImageView: UIImageView!{
        didSet{
            linkImageView.isUserInteractionEnabled=true
            linkImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openLink)))
        }
    }
    @IBAction func textFieldEdittingEnded(_ sender: Any) {
        if let text = textField.text{
            delegate?.updateURL(to: text)
        }
    }
    @objc func openLink(){
        if let text = textField.text{
            delegate?.openURL(urlString: text)
        }
    }
}
class labelKanbanCell: UITableViewCell {
    @IBOutlet weak var stackView: UIStackView!
    var delegate: cardPreviewTableProtocol?
    var tagColor: Int=0
    @IBOutlet var labelButtons: [UIButton]!
    @IBAction func but0(_ sender: Any) {
        tagColor=0
        updateTag()
    }
    @IBAction func but1(_ sender: Any) {
        tagColor=1
        updateTag()
    }
    @IBAction func but2(_ sender: Any) {
        tagColor=2
        updateTag()
    }
    @IBAction func but3(_ sender: Any) {
        tagColor=3
        updateTag()
    }
    @IBAction func but4(_ sender: Any) {
        tagColor=4
        updateTag()
    }
    @IBAction func but5(_ sender: Any) {
        tagColor=5
        updateTag()
    }
    @IBAction func but6(_ sender: Any) {
        tagColor=6
        updateTag()
    }
    @IBAction func but7(_ sender: Any) {
        tagColor=7
        updateTag()
    }
    @IBAction func but8(_ sender: Any) {
        tagColor=8
        updateTag()
    }
    @IBAction func but9(_ sender: Any) {
        tagColor=9
        updateTag()
    }
    
    func setupCell(){
        for ind in 0...9{
            if ind==tagColor{
//                labelButtons[ind].imageView?.contentMode = .scaleAspectFit
                labelButtons[ind].backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.219396682)
            }else{
//                labelButtons[ind].imageView?.contentMode = .center
                labelButtons[ind].backgroundColor = .clear
            }
        }
    }
    func updateTag() {
        delegate?.updateTagColor(to: tagColor)
        setupCell()
    }
}

class deleteKanbanCell: UITableViewCell{
    var delegate: cardPreviewTableProtocol?
    @IBAction func deletePressed(_ sender: Any) {
        self.delegate?.deleteCard()
    }
}
