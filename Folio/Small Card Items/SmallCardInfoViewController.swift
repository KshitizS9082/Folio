//
//  SmallCardInfoViewController.swift
//  card2
//
//  Created by Kshitiz Sharma on 15/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import SPFakeBar
import SPStorkController

protocol ExpandingCellDelegate {
    func updated(height: CGFloat, row: Int)
}

class SmallCardInfoViewController: UIViewController, UITableViewDataSource, SPStorkControllerDelegate, DatePickerTableViewCellDelegate {
    
//    var titleTextView = UITextView()
//    var notesTextView = UITextView()
//    var urlTextView = UITextView()
//    var titleHeight: CGFloat = 200
//    var smallcardDelegate: SCardProtocol?
    var viewLinkedTo: SmallCardView?
    var sCard = SmallCard()
    var table = UITableView()
    var navBar = SPFakeBarView(style: .stork)
    var cellHeights: [CGFloat] = [40, 40, 40, 40, 40, 40, 40, 100, 40 ,40]
    var datePickerVisible: Bool = false
    var extraNoteCellRow = 7
//    var notesHeight:CGFloat = 200
//    let TitleIndexRow = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10//to be increased as functionalities increase
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let x=UITableViewCell()
            x.isHidden=true
            return x
        case 1:
            return setTitleCell(tableView, cellForRowAt: indexPath)
        case 2:
             return setNotesCell(tableView, cellForRowAt: indexPath)
        case 3:
             return setURLCell(tableView, cellForRowAt: indexPath)
        case 4:
            let x=UITableViewCell()
            x.isHidden=true
            return x
        case 5:
            return setDateValueCell(tableView, cellForRowAt: indexPath)
        case 6:
            return setDatePickerCell(tableView, cellForRowAt: indexPath)
        case extraNoteCellRow:
            return setExtraNotesCell(tableView, cellForRowAt: indexPath)
        case 8:
            let x=UITableViewCell()
            x.isHidden=true
            return x
        case 9:
            return setDeleteCardCell(tableView, cellForRowAt: indexPath)
        default:
            print("inside default case")
        }
        return UITableViewCell()
    }
    func setTitleCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleTextCell", for: indexPath) as! smallCardTitleTableViewCell
        cell.rowValue = 1
        cell.placheHolderText = "Text"
        cell.titleText.text = sCard.title
        if cell.titleText.text.count==0{
            cell.titleText.textColor = UIColor.gray
            cell.titleText.text = cell.placheHolderText
        }
        cell.titleText.isScrollEnabled = false
        cell.delegate = self
        cell.setHeight()
        return cell
    }
    func setNotesCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleTextCell", for: indexPath) as! smallCardTitleTableViewCell
        cell.rowValue = 2
        cell.placheHolderText = "Notes"
        cell.titleText.text = sCard.notes
        if cell.titleText.text.count==0{
            cell.titleText.textColor = UIColor.gray
            cell.titleText.text = cell.placheHolderText
        }
        cell.titleText.isScrollEnabled = false
        cell.delegate = self
        cell.setHeight()
        return cell
    }
    func setURLCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleTextCell", for: indexPath) as! smallCardTitleTableViewCell
        cell.rowValue = 3
        cell.placheHolderText = "URL"
        cell.titleText.text = sCard.url?.absoluteString
        if cell.titleText.text.count==0{
            cell.titleText.textColor = UIColor.gray
            cell.titleText.text = cell.placheHolderText
        }
        cell.titleText.isScrollEnabled = false
        cell.delegate = self
        cell.setHeight()
        return cell
    }
    func setDateValueCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.isUserInteractionEnabled=true
        cell.textLabel?.textAlignment = .right
        if let time=sCard.reminderDate{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, dd/MM/yy, hh:mm a"
            cell.textLabel?.text = formatter.string(from: time)
            cell.imageView?.image = UIImage(systemName: "alarm.fill")
        }else{
            cell.textLabel?.text = "None"
            cell.imageView?.image = UIImage(systemName: "alarm")
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleDatePickerCell))
        cell.textLabel?.addGestureRecognizer(tap)
        cell.addGestureRecognizer(tap)
        return cell
    }
    @objc func toggleDatePickerCell(){
        datePickerVisible = !datePickerVisible
        cellHeights[6]=40
        let setDatateindexPath = IndexPath(row: 5, section: 0)
        let datePickerIndexPath = IndexPath(row: 6, section: 0)
        table.reloadRows(at: [setDatateindexPath, datePickerIndexPath], with: .fade)
    }
    func setDatePickerCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if datePickerVisible{
            let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerCell", for: indexPath) as! SmallCardDatePickerTableViewCell
            cell.delegate = self
            cell.rowValue=6
            cell.updateHeightDelegate=self
            cell.configureWithCard(scard: sCard, currentDate: sCard.reminderDate)
            return cell
        }
        let x=UITableViewCell()
        x.isHidden=true
        return x
    }
    func dateChangedTo(toDate date: Date) {
        sCard.reminderDate = date
        let setDatateindexPath = IndexPath(row: 5, section: 0)
        table.reloadRows(at: [setDatateindexPath], with: .automatic)
    }
    func setExtraNotesCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleTextCell", for: indexPath) as! smallCardTitleTableViewCell
        cell.rowValue = extraNoteCellRow
        cell.placheHolderText = "Detailed Notes"
        cell.titleText.text = sCard.extraNotes
        if cell.titleText.text.count==0{
            cell.titleText.textColor = UIColor.gray
            cell.titleText.text = cell.placheHolderText
        }
        cell.baseHeight=100
        cell.titleText.isScrollEnabled = false
        cell.delegate = self
        cell.setHeight()
        return cell
    }
    func setDeleteCardCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = "Delete"
        cell.textLabel?.textColor = UIColor.systemRed
        let tap=UITapGestureRecognizer(target: self, action: #selector(deleteCard))
        cell.addGestureRecognizer(tap)
        return cell
    }
    @objc func deleteCard(){
        print("yet to implement deleting card")
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive){
            UIAlertAction in
            print("in delete")
            self.viewLinkedTo?.removeFromSuperview()
            self.dismiss(animated: true)
        }
        let deleteFromPageAction = UIAlertAction(title: "Remove From Page", style: .destructive){
            UIAlertAction in
            print("in Remove From Page")
//            self.viewLinkedTo?.removeFromSuperview()
//            self.viewLinkedTo?.frame = CGRect.zero
            self.viewLinkedTo?.isHidden=true
            self.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        let alert = UIAlertController(title: "Delete Card?", message: "Deleting this card will also delete it's data", preferredStyle: .actionSheet)
        alert.addAction(deleteFromPageAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    func setNavBar(){
        self.navBar.titleLabel.text = ""
        navBar.titleLabel.text = "Details"
        navBar.backgroundColor = navBarBackgroundColor
        self.view.addSubview(self.navBar)
    }
    func setTable(){
        table.dataSource=self
        table.delegate=self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(UINib(nibName: "smallCardTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "titleTextCell")
        table.register(UINib(nibName: "SmallCardDatePickerTableViewCell", bundle: nil), forCellReuseIdentifier: "datePickerCell")
        table.backgroundColor = tableBackgroundColor
        if(view.subviews.contains(table)==false){
            view.addSubview(table)
        }
        table.translatesAutoresizingMaskIntoConstraints = false
        [
            table.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            table.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            ].forEach { (constraints) in
                constraints.isActive = true
        }
    }
    func saveCellsVisibleRightNow(){
        var indexPath = IndexPath(row: 1, section: 0)
        if let cell = table.cellForRow(at: indexPath) {
            let x = cell as! smallCardTitleTableViewCell
            if x.titleText.textColor != UIColor.gray{
                sCard.title = x.titleText.text
            }
        }
        indexPath = IndexPath(row: 2, section: 0)
        if let cell = table.cellForRow(at: indexPath) {
            let x = cell as! smallCardTitleTableViewCell
            if x.titleText.textColor != UIColor.gray{
                sCard.notes = x.titleText.text
            }
        }
        indexPath = IndexPath(row: 3, section: 0)
        if let cell = table.cellForRow(at: indexPath) {
            let x = cell as! smallCardTitleTableViewCell
            if x.titleText.textColor != UIColor.gray{
                //TODO: make it work, for now only works if a single line given as input
                sCard.url = URL(string: x.titleText.text)
            }
        }
        indexPath = IndexPath(row: extraNoteCellRow, section: 0)
        if let cell = table.cellForRow(at: indexPath) {
            let x = cell as! smallCardTitleTableViewCell
            if x.titleText.textColor != UIColor.gray{
                sCard.extraNotes = x.titleText.text
            }
        }
        viewLinkedTo!.card=sCard
        viewLinkedTo!.layoutSubviews()
//        smallcardDelegate!.updateSCard(for: sCard, at: viewLinkedTo!)
    }
    func didDismissStorkByTap() {
        print("dismissed by tap")
        //TODO: get title, notes etc. and update and properly show in cardview
        saveCellsVisibleRightNow()
    }
    func didDismissStorkBySwipe() {
        didDismissStorkByTap()
        print("dismissed by swipe")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setTable()
        //to dismiss keyboard
        let tap=UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        // register for notifications when the keyboard appears:
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @objc func keyboardWillShow( note:NSNotification )
    {
        // read the CGRect from the notification (if any)
        if let newFrame = (note.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height, right: 0 )
            table.contentInset = insets
            table.scrollIndicatorInsets = insets
        }
    }
}

extension SmallCardInfoViewController{
    var tableBackgroundColor: UIColor{
        return #colorLiteral(red: 0.9214739799, green: 0.9253779054, blue: 0.942587316, alpha: 1)
    }
    var cellBackgroundColor: UIColor{
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    var navBarBackgroundColor: UIColor{
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}

extension SmallCardInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        print("height for row \(indexPath.row) = cellHeights[indexPath.row]")
        return cellHeights[indexPath.row]
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row==5{
            return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        print("now will update \(indexPath.row)")
        switch indexPath.row {
        case 1:
            let cell = cell as! smallCardTitleTableViewCell
            if cell.titleText.textColor != UIColor.gray{
                sCard.title = cell.titleText.text
            }
        case 2:
            let cell = cell as! smallCardTitleTableViewCell
            if cell.titleText.textColor != UIColor.gray{
                sCard.notes = cell.titleText.text
            }
        case 3:
            let cell = cell as! smallCardTitleTableViewCell
            if cell.titleText.textColor != UIColor.gray{
                sCard.url = URL(string: cell.titleText.text)
            }
        case extraNoteCellRow:
            let cell = cell as! smallCardTitleTableViewCell
            if cell.titleText.textColor != UIColor.gray{
                sCard.extraNotes = cell.titleText.text
            }
        default:
            print("couldn't save dequed cell as indexpath not saved properly")
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            sCard.reminderDate = nil
            datePickerVisible = false
            table.reloadRows(at: [IndexPath(row: 5, section: 0), IndexPath(row: 6, section: 0)], with: .automatic)
        }
    }
}
extension SmallCardInfoViewController: ExpandingCellDelegate {
    
    func updated(height: CGFloat, row: Int) {
//        titleHeight = height
        cellHeights[row] = height
        
        // Disabling animations gives us our desired behaviour
        UIView.setAnimationsEnabled(false)
        /* These will causes table cell heights to be recaluclated,
         without reloading the entire cell */
        table.beginUpdates()
        table.endUpdates()
        // Re-enable animations
        UIView.setAnimationsEnabled(true)
        
        let indexPath = IndexPath(row: row, section: 0)
        
        table.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
}
