//
//  KanbanTimelineViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 23/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class KanbanTimelineViewController: UIViewController {
    var kanban = Kanban()
    var allCards = [KanbanCard]()
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
    func setAllCards(){
        allCards.removeAll()
        kanban.boards.forEach { (board) in
            board.items.forEach { (card) in
                allCards.append(card)
            }
        }
        allCards.sort { (first, second) -> Bool in
            return first.dateOfConstruction<second.dateOfConstruction
        }
        tableView.reloadData()
    }
    
    func save(){
        if let json = kanban.json {
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("kanbanData.json"){
                do {
                    try json.write(to: url)
                    print ("saved successfully")
                } catch let error {
                    print ("couldn't save \(error)")
                }
            }
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        save()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("kanbanData.json"){
//            print("trying to extract contents of kanbanData")
            if let jsonData = try? Data(contentsOf: url){
                //                pageList = pageInfo(json: jsonData)
                if let x = Kanban(json: jsonData){
                    kanban = x
                }else{
                    print("WARNING: COULDN'T UNWRAP JSON DATA TO FIND kanbanData")
                }
                setAllCards()
            }
            viewDidLoad()
        }
    }

   

}
extension KanbanTimelineViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=UITableViewCell()
        cell.backgroundColor=UIColor.blue
        return cell
    }
    
    
}
