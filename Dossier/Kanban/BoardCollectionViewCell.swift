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
    func deleteCard(newCard: KanbanCard)
}
class BoardCollectionViewCell: UICollectionViewCell {
    var board: Board?
    var delegate: BoardCVCProtocol?
//    weak var parentVC: BoardCollectionViewController?
    
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBAction func titleTextFieldDidChange(_ sender: UITextField) {
        self.board?.title = self.titleTextField.text ?? ""
        if let b = board{
            delegate?.updateBoard(newBoard: b)
        }
    }
    @IBAction func textFieldDidEndEditting(_ sender: UITextField) {
        self.board?.title = self.titleTextField.text ?? ""
        if let b = board{
            delegate?.updateBoard(newBoard: b)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate=self
        tableView.dragInteractionEnabled = true
        
        // register for notifications when the keyboard appears:
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
    
    @IBAction func editBoardTapped(_ sender: UIButton) {
        self.delegate?.deleteBoard(board: self.board!)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive){
            UIAlertAction in
            print("in delete")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        let alert = UIAlertController(title: "Delete Board?", message: "Deleting this card will also delete it's data", preferredStyle: .actionSheet)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
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
}

extension BoardCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        //NOTE: make 2 to show addCard cell in last
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==1{
            return 1
        }
        return board?.items.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section==1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "addButtonCell", for: indexPath)
            return cell
        }
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
extension BoardCollectionViewCell: UITableViewDragDelegate, UITableViewDropDelegate{
//    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
//        var dropProposal = UITableViewDropProposal(operation: .cancel)
//
//        // Accept only one drag item.
//        guard session.items.count == 1 else { return dropProposal }
//
//        // The .move drag operation is available only for dragging within this app and while in edit mode.
//        if tableView.hasActiveDrag {
//            if tableView.isEditing {
//                dropProposal = UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
//            }
//        }
////        else {
////            // Drag is coming from outside the app.
////            dropProposal = UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
////        }
//
//        return dropProposal
//    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        coordinator.session.loadObjects(ofClass: NSAttributedString.self) { providers in
//            let dropPoint = session.location(in: self)
//            print("point= \(dropPoint)")
            let destinationIndexPath: IndexPath
            
            if let indexPath = coordinator.destinationIndexPath {
                destinationIndexPath = indexPath
            } else {
                // Get last index path of table view.
                let section = tableView.numberOfSections - 1
                let row = tableView.numberOfRows(inSection: section)
                destinationIndexPath = IndexPath(row: row, section: section)
            }
//            coordinator.session.loadObjects(ofClass: NSString.self) { items in
//                // Consume drag items.
//                let stringItems = items as! [String]
//                //only allow one item
//                if stringItems.count>1{
//                    return
//                }
//                var indexPaths = [IndexPath]()
//                for (index, item) in stringItems.enumerated() {
//                    let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
////                    self.model.addItem(item, at: indexPath.row)
//                    indexPaths.append(indexPath)
//                }
//
//                tableView.insertRows(at: indexPaths, with: .automatic)
//            }
            for attributedString in providers as? [NSAttributedString] ?? [] {
                print("trying to drop " + attributedString.string)
                self.delegate?.dragDropCard(sourceCardUID: attributedString.string, targetBoardID: self.board!.uid, targetIndex: destinationIndexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let board = board else {
               return []
           }
        let stringData = board.items[indexPath.row].UniquIdentifier.uuidString
        //           let itemProvider = NSItemProvider(item: stringData as NSData, typeIdentifier: String?)
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: stringData as NSString))
//        session.localContext = (board, indexPath, tableView)
        dragItem.localObject = board.items[indexPath.row].UniquIdentifier.uuidString
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = board?.items.remove(at: sourceIndexPath.row)
        board?.items.insert(mover!, at: destinationIndexPath.row)
        delegate?.updateBoard(newBoard: self.board!)
    }
}
extension BoardCollectionViewCell: tableCardDeletgate{
    func deleteCard(newCard: KanbanCard) {
        if let board = self.board{
            for ind in board.items.indices{
                if self.board?.items[ind].UniquIdentifier == newCard.UniquIdentifier{
                    self.board?.items.remove(at: ind)
                    self.tableView.deleteRows(at: [IndexPath(row: ind, section: 0)], with: .automatic)
                    delegate?.updateBoard(newBoard: self.board!)
                    break
                }
            }
        }
//        delegate?.deleteBoard(board: self.board!)
    }
    
    func updateCard(to newCard: KanbanCard){
        self.board?.items.indices.forEach({ (ind) in
            if self.board?.items[ind].UniquIdentifier == newCard.UniquIdentifier{
                self.board?.items[ind]=newCard
            }
        })
        delegate?.updateBoard(newBoard: board!)
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
