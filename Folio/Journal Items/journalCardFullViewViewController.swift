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
    var mediaCard: mediaJournalCard?
    var index = IndexPath(row: 0, section: 0)
    var delegate: addCardInJournalProtocol?
    @IBOutlet weak var table: UITableView!{
        didSet{
            table.delegate=self
            table.dataSource=self
        }
    }
    
    override func viewDidLoad() {
        // register for notifications when the keyboard appears:
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
    @objc func keyboardWillShow( note:NSNotification ){
        // read the CGRect from the notification (if any)
        if let newFrame = (note.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height, right: 0 )
            table.contentInset = insets
            table.scrollIndicatorInsets = insets
            UIView.animate(withDuration: 0.25) {
                self.table.layoutIfNeeded()
                self.table.layoutIfNeeded()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.type == journalCardType.notes{
            return 2
        }else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.type == journalCardType.notes{
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
        }else{
            switch indexPath.row {
            case 0:
                let cell = table.dequeueReusableCell(withIdentifier: "headingCell") as! journalFullViewHeadingCell
                cell.delegate=self
                cell.index = indexPath
                cell.contentTextView.text=mediaCard?.notesText
                return cell
            case 1:
                let cell = table.dequeueReusableCell(withIdentifier: "journalImageCell") as! journalFullViewImageCell
                cell.delegate=self
                cell.index = indexPath
//                cell.journalImage.image=mediaCard?.imageData
                if mediaCard!.imageFileName.count>0 {
                    let fileName = mediaCard!.imageFileName[0]
                    DispatchQueue.global(qos: .background).async {
                        if let url = try? FileManager.default.url(
                            for: .documentDirectory,
                            in: .userDomainMask,
                            appropriateFor: nil,
                            create: true
                        ).appendingPathComponent(fileName){
                            if let jsonData = try? Data(contentsOf: url){
                                if let extract = imageData(json: jsonData){
                                    if let image = UIImage(data: extract.data){
                                        DispatchQueue.main.async {
                                            cell.journalImage.image=image
                                            cell.journalImage.setupImageViewer(images: [image])
                                            cell.awakeFromNib()
                                        }
                                    }else{
                                        print("couldn't get UIImage from extrated data, check if sure this file doesn't exist and if so delete it from array")
                                    }
                                }else{
                                    print("couldnt get json from URL")
                                }
                            }
                        }
                    }
                }
                return cell
            case 2:
                let cell = table.dequeueReusableCell(withIdentifier: "subNotesCell") as! journalFullViewSubNotesCell
                cell.delegate=self
                cell.index = indexPath
                cell.contentTextView.text=mediaCard?.subNotesText
                return cell
            default:
                let cell = UITableViewCell()
                cell.backgroundColor = .red
                return cell
            }
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
            if self.type == journalCardType.notes{
            self.delegate?.updateJournalNotesCard(at: self.index, with: self.card!)
            }else{
                self.delegate?.updateJournalMediaCard(at: self.index, with: self.mediaCard!)
            }
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
        if self.type == journalCardType.notes{
        self.card?.notesText=title
        }else{
            self.mediaCard?.notesText=title
        }
//        delegate?.updateJournalNotesEntry(at: index, with: title)
    }
    
    func updateSubNotes(title: String) {
        if self.type == journalCardType.notes{
            self.card?.subNotesText=title
        }else{
            self.mediaCard?.subNotesText=title
        }
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
class journalFullViewImageCell: UITableViewCell{
    var delegate: journalFullViewTableProtocol?
    var index = IndexPath()
    @IBOutlet weak var journalImage: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        if journalImage.image==nil{
            self.heightConstraint.constant=0
        }else{
            self.heightConstraint.constant=250
        }
        delegate?.updated(inded: index)
    }
    
}
