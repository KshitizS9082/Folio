//
//  newNotesFullViewController.swift
//  Folio
//
//  Created by Kshitiz Developer on 26/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
protocol cardNotesFullViewTableProtocol {
    func updated(inded: IndexPath)
    func updateTitle(title: String)
    func updateSubNotes(title: String)
}

class newNotesFullViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, cardNotesFullViewTableProtocol{
    
    
    var viewLinkedTo: cardView?
    var card: Card = Card()
    @IBOutlet weak var table: UITableView!{
        didSet{
            table.dataSource=self
            table.delegate=self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("nwftsa vdl")
        // Do any additional setup after loading the view.
        // register for notifications when the keyboard appears:
               NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @objc func keyboardWillShow( note:NSNotification ){
           // read the CGRect from the notification (if any)
           if let newFrame = (note.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
               let insets = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height, right: 0 )
               table.contentInset = insets
               table.scrollIndicatorInsets = insets
           }
       }
    @IBAction func handleCancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func handleDoneButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            self.viewLinkedTo?.card=self.card
            self.viewLinkedTo?.layoutSubviews()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = table.dequeueReusableCell(withIdentifier: "headingCell") as! cardNotesFullViewHeadingCell
            cell.delegate=self
            cell.index = indexPath
            print("sth \(card.Heading)")
            cell.contentTextView.text=card.Heading
            return cell
        case 1:
            let cell = table.dequeueReusableCell(withIdentifier: "subNotesCell") as! cardNotesFullViewSubNotesCell
            cell.delegate=self
            cell.index = indexPath
            cell.contentTextView.text=card.notes
            return cell
        default:
            let cell = UITableViewCell()
            cell.backgroundColor = .red
            return cell
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
        self.card.Heading=title
    }
    
    func updateSubNotes(title: String) {
        self.card.notes=title
    }
}


class cardNotesFullViewHeadingCell: UITableViewCell, UITextViewDelegate{
    var delegate: cardNotesFullViewTableProtocol?
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
class cardNotesFullViewSubNotesCell: UITableViewCell, UITextViewDelegate{
    var delegate: cardNotesFullViewTableProtocol?
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
