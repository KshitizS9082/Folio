//
//  KanbanListViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 30/11/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
struct KanbanListInfo: Codable {
    var boardNames = [String]()
    var boardFileNames = [String]()
    init(){
    }
    init?(json: Data){
        if let newValue = try? JSONDecoder().decode(KanbanListInfo.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    var json: Data? {
        return try? JSONEncoder().encode(self)
    } }
protocol KanbanListProtcol {
    func editName(for boardFileName: String, to newName: String)
    func updateBoardDeleteInfo(for boardFileName: String)
}
class KanbanListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, KanbanListProtcol {
    func updateBoardDeleteInfo(for boardFileName: String) {
        for ind in kanbanList.boardFileNames.indices{
            if kanbanList.boardFileNames[ind]==boardFileName{
                kanbanList.boardFileNames.remove(at: ind)
                kanbanList.boardNames.remove(at: ind)
                print("FOUND IND=\(ind) where to remove board from list")
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [IndexPath(row: ind, section: 0)], with: .automatic)
                self.tableView.endUpdates()
                break
            }
        }
    }
    
    
    var kanbanList = KanbanListInfo()

    override func viewDidLoad() {
        super.viewDidLoad()
        // register for notifications when the keyboard appears:
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @IBOutlet weak var backgroundImageView: UIImageView!{
        didSet{
            backgroundImageView.addBlurEffect()
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource=self
            tableView.delegate=self
        }
    }
    @IBAction func addBoard(_ sender: UIBarButtonItem) {
        kanbanList.boardNames.append("")
        kanbanList.boardFileNames.append("\(UUID())+.json")
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: kanbanList.boardFileNames.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
        tableView.scrollToRow(at: IndexPath(row: kanbanList.boardFileNames.count-1, section: 0), at: .middle, animated: true)
    }
    
    func save() {
        print("attempting to save pages")
        if let json = kanbanList.json {
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("KanbanList.json"){
                do {
                    try json.write(to: url)
                    print ("saved successfully")
                } catch let error {
                    print ("couldn't save \(error)")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        showBoardSegueID
        if segue.identifier == "showBoardSegueID"{
            if let vc = segue.destination as? switchKanbanTimelineTabBarController, let sourceTVC = sender as? KanbanListTableViewCell{
                vc.kanbanDelegate=self
                vc.kanbanFileName = sourceTVC.fileName!
                vc.title=sourceTVC.boardName!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kanbanList.boardFileNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KanbanListCell") as! KanbanListTableViewCell
        cell.boardName=kanbanList.boardNames[indexPath.row]
        cell.titleTextField.text=kanbanList.boardNames[indexPath.row]
        cell.fileName=kanbanList.boardFileNames[indexPath.row]
        cell.delegate=self
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete",
                                        handler: { (action, view, completionHandler) in
                                            self.deleteBoard(at: indexPath.row)
//                                            self.tableView.beginUpdates()
//                                            self.tableView.deleteRows(at: [indexPath], with: .automatic)
//                                            self.tableView.endUpdates()
                                            completionHandler(true)
        })
        action.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    func editName(for boardFileName: String, to newName: String) {
        for ind in kanbanList.boardFileNames.indices{
            if kanbanList.boardFileNames[ind]==boardFileName{
                kanbanList.boardNames[ind]=newName
            }
        }
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
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.systemGray,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 30)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("KanbanList.json"){
            print("trying to extract contents of jsonData")
            if let jsonData = try? Data(contentsOf: url){
                //                pageList = pageInfo(json: jsonData)
                if let x = KanbanListInfo(json: jsonData){
                    kanbanList = x
                }else{
                    print("WARNING: COULDN'T UNWRAP JSON DATA TO FIND PAGELIST")
                }
            }
            tableView.reloadData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        save()
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
//    var identifiers: [String] = []
    var identifiers: Set = [""]
    func deleteBoard(at index: Int){
        let boardFileName = self.kanbanList.boardFileNames[index]
        var kanban = Kanban()
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent(boardFileName){
//            print("trying to extract contents of kanbanData")
            if let jsonData = try? Data(contentsOf: url){
                //                pageList = pageInfo(json: jsonData)
                if let x = Kanban(json: jsonData){
                    kanban = x
                }else{
                    print("WARNING: COULDN'T UNWRAP JSON DATA TO FIND kanbanData")
                    return
                }
                do{
                    try FileManager.default.removeItem(at: url)
                    print("deleted kanban at \(url) succefully")
                } catch{
                    print("ERROR: kanban  at \(url) couldn't be deleted. Causes dataleak")
                    return
                }
            }
        }
        for board in kanban.boards{
            for item in board.items{
                for imagePath in item.mediaLinks{
                    if let imageUrl = try? FileManager.default.url(
                        for: .documentDirectory,
                        in: .userDomainMask,
                        appropriateFor: nil,
                        create: true
                    ).appendingPathComponent(imagePath){
                        do{
                            try FileManager.default.removeItem(at: imageUrl)
                            print("deleted item \(imageUrl) succefully")
                        } catch{
                            print("ERROR: item  at \(imageUrl) couldn't be deleted. Causes datalink")
                            return
                        }
                    }
                }
                if item.reminderDate != nil{
                    self.identifiers.insert(item.UniquIdentifier.uuidString)
                }
            }
        }
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifToDelete: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if self.identifiers.contains(notification.identifier){
                    identifToDelete.append(notification.identifier)
                }
            }
            print("removing notifs with identifiers \(self.identifiers)")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifToDelete)
        }
        self.updateBoardDeleteInfo(for: boardFileName)
        self.tableView.reloadData()
    }
}
