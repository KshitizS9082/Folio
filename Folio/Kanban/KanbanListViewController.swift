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
    }
}
protocol KanbanListProtcol {
    func editName(for boardFileName: String, to newName: String)
//    func deleteBoard
}
class KanbanListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, KanbanListProtcol {
    
    
    var kanbanList = KanbanListInfo()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                vc.boardFileName = sourceTVC.fileName!
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
    
    func editName(for boardFileName: String, to newName: String) {
        for ind in kanbanList.boardFileNames.indices{
            if kanbanList.boardFileNames[ind]==boardFileName{
                kanbanList.boardNames[ind]=newName
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
}
