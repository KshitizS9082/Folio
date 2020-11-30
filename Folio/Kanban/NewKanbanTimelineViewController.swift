//
//  NewKanbanTimelineViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 29/11/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
enum SortStyle {
    case scheduleDate
    case dateOfConstruction
    case board
}
class NewKanbanTimelineViewController: UIViewController {
    var kanban = Kanban()
    var allCards = [KanbanCard]()
    var sortStyle = SortStyle.scheduleDate
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
        if sortStyle == .board{
            kanban.boards.forEach { (board) in
                board.items.forEach { (card) in
                    allCards.append(card)
                }
            }
        }else if sortStyle == .scheduleDate{
            kanban.boards.forEach { (board) in
                board.items.forEach { (card) in
                    allCards.append(card)
                }
            }
            allCards.sort { (first, second) -> Bool in
                if let s=second.scheduledDate{
                    if let f=first.scheduledDate{
                            return f<s
                    }else{
                        return false
                    }
                }else{
                    return true
                }
            }
        }else if sortStyle == .dateOfConstruction{
            kanban.boards.forEach { (board) in
                board.items.forEach { (card) in
                    allCards.append(card)
                }
            }
            allCards.sort { (first, second) -> Bool in
                return first.dateOfConstruction<second.dateOfConstruction
            }
        }
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewwilalal newkanbantimelinevc")
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
            tableView.reloadData()
        }
    }
    
    func editTimelineTapped(){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newKanbanTimelineSegueID"{
            print("found segue")
            if let cardCell = sender as? CardTableViewCell, let vc = segue.destination as? CardPreviewViewController{
                print("found cell card = \(cardCell.card)")
                vc.card = cardCell.card
                vc.delegate = cardCell
            }
            
        }
    }
    func save(){
        print("viewwilalal newkanbantimeline save")
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
}
extension NewKanbanTimelineViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let tempcell = tableView.dequeueReusableCell(withIdentifier: "tempCell")!
//        return tempcell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kabanTableCell", for: indexPath) as! CardTableViewCell
        cell.delegate=self
//        cell.card = board!.items[indexPath.row]
        cell.card = self.allCards[indexPath.row]
        cell.titleTextView.isEditable=false
        cell.setupCard()
        return cell
    }
    
    
}
extension NewKanbanTimelineViewController: tableCardDeletgate{
    func updateCard(to newCard: KanbanCard) {
        print("do nothing")
        for ind in allCards.indices{
            if allCards[ind].UniquIdentifier==newCard.UniquIdentifier{
                allCards[ind]=newCard
                break
            }
        }
        for ind in kanban.boards.indices{
            for inind in kanban.boards[ind].items.indices{
                if kanban.boards[ind].items[inind].UniquIdentifier == newCard.UniquIdentifier{
                    kanban.boards[ind].items[inind] = newCard
                    return
                }
            }
        }
    }
    
    func deleteCard(newCard: KanbanCard) {
        print("do nothing to at 34890thnjkls")
        for ind in allCards.indices{
            if allCards[ind].UniquIdentifier==newCard.UniquIdentifier{
//                allCards[ind]=newCard
                allCards.remove(at: ind)
                self.tableView.deleteRows(at: [IndexPath(row: ind, section: 0)], with: .automatic)
                break
            }
        }
        for ind in kanban.boards.indices{
            for inind in kanban.boards[ind].items.indices{
                if kanban.boards[ind].items[inind].UniquIdentifier == newCard.UniquIdentifier{
//                    kanban.boards[ind].items[inind] = newCard
                    kanban.boards[ind].items.remove(at: inind)
                    return
                }
            }
        }
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