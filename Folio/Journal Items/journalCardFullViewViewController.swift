//
//  journalCardFullViewViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 09/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
protocol journalFullViewTableProtocol {
    func updated(inded: IndexPath)
    func updateTitle(title: String)
    func updateSubNotes(title: String)
}

class journalCardFullViewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, journalFullViewTableProtocol {
    
    var type: journalCardType?
    var card: noteJournalCard?
    var index = IndexPath(row: 0, section: 0)
    var delegate: addCardInJournalProtocol?
    @IBOutlet weak var table: UITableView!{
        didSet{
            table.delegate=self
            table.dataSource=self
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = table.dequeueReusableCell(withIdentifier: "headingCell") as! journalFullViewHeadingCell
            cell.delegate=self
            cell.index = indexPath
            cell.contentTextView.text=card?.notesText
            return cell
        case 1:
        let cell = table.dequeueReusableCell(withIdentifier: "subNotesCell") as! journalFullViewSubNotesCell
        cell.delegate=self
        cell.index = indexPath
        cell.contentTextView.text=card?.subNotesText
        return cell
        default:
            let cell = UITableViewCell()
            cell.backgroundColor = .red
            return cell
        }
    }
    @IBOutlet weak var navBar: UINavigationBar!{
        didSet{
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
        }
    }
    @IBAction func handleCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleDone(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            self.delegate?.updateJournalNotesCard(at: self.index, with: self.card!)
        }
    }
    
    func updated(inded: IndexPath) {
        UIView.setAnimationsEnabled(false)
        table.beginUpdates()
        table.endUpdates()
        UIView.setAnimationsEnabled(true)
        table.scrollToRow(at: inded, at: .bottom, animated: false)
    }
    
    func updateTitle(title: String) {
        print("in update title inside journalCardFullViewViewController wtih text: \(title) ")
        self.card?.notesText=title
//        delegate?.updateJournalNotesEntry(at: index, with: title)
    }
    
    func updateSubNotes(title: String) {
        self.card?.subNotesText=title
    }
}

class journalFullViewHeadingCell: UITableViewCell, UITextViewDelegate{
    var delegate: journalFullViewTableProtocol?
    var index = IndexPath()
    @IBOutlet weak var contentTextView: UITextView!{
        didSet{
            contentTextView.delegate=self
            contentTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        delegate?.updated(inded: index)
        delegate?.updateTitle(title: contentTextView.text)
    }
    @objc func tapDone(sender: Any) {
        self.endEditing(true)
    }
}

class journalFullViewSubNotesCell: UITableViewCell, UITextViewDelegate{
var delegate: journalFullViewTableProtocol?
var index = IndexPath()
    
    @IBOutlet weak var contentTextView: UITextView!{
        didSet{
            contentTextView.delegate=self
            contentTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        delegate?.updated(inded: index)
        delegate?.updateSubNotes(title: contentTextView.text)
    }
    @objc func tapDone(sender: Any) {
           self.endEditing(true)
       }
}
