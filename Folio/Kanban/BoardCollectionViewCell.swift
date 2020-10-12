//
//  BoardCollectionViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 12/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

protocol tableCardDeletgate {
    func updateHeights()
    func updateCard(to newCard: KanbanCard)
}
class BoardCollectionViewCell: UICollectionViewCell {
    var board: Board?
    weak var parentVC: BoardCollectionViewController?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        /*
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
         */
    }
    func setup(with board: Board) {
        self.board = board
        self.titleTextField.text = board.title
        tableView.reloadData()
    }
    @IBAction func addTapped(_ sender: UIButton) {
        print("Yet to add item")
        self.board?.items.append(KanbanCard())
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: (board?.items.count)!-1, section: 0), at: .bottom, animated: true)
        if let cell = self.tableView.cellForRow(at: IndexPath(row: (board?.items.count)!-1, section: 0)) as? CardTableViewCell{
            cell.titleTextView.becomeFirstResponder()
        }
    }
    
    
}

extension BoardCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return board?.items.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kabanTableCell", for: indexPath) as! CardTableViewCell
        cell.delegate=self
        cell.card = board!.items[indexPath.row]
        cell.setupCard()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("yet to handle selecting a tableViewCell")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension BoardCollectionViewCell: tableCardDeletgate{
    func updateCard(to newCard: KanbanCard){
        self.board?.items.indices.forEach({ (ind) in
            if self.board?.items[ind].UniquIdentifier == newCard.UniquIdentifier{
                self.board?.items[ind]=newCard
            }
        })
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
