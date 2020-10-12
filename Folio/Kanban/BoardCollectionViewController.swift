//
//  BoardCollectionViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 12/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit


class BoardCollectionViewController: UICollectionViewController {
    var boards = [
        Board(title: "first", items: [KanbanCard(title: "Database Migration"),KanbanCard(title: "Schema Design"),KanbanCard(title: "Storage Management"),KanbanCard(title: "Model Abstraction")]),
        Board(title: "second", items: [KanbanCard(title: "Database Migration"),KanbanCard(title: "Schema Design"),KanbanCard(title: "Storage Management"),KanbanCard(title: "Model Abstraction")]),
        Board(title: "third", items: []),
        Board(title: "fourth", items: [KanbanCard(title: "Database Migration"),KanbanCard(title: "Schema Design"),KanbanCard(title: "Storage Management"),KanbanCard(title: "Model Abstraction")])
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupAddButtonItem()
        updateCollectionViewItem(with: view.bounds.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateCollectionViewItem(with: size)
    }
  
    private func updateCollectionViewItem(with size: CGSize) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.itemSize = CGSize(width: 300, height: size.height * 0.7)
    }
    
    @IBAction func addList(_ sender: UIButton) {
        print("addList tapped")
        let alertController = UIAlertController(title: "Add List", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else {
                return
            }
            
            self.boards.append(Board(title: text, items: []))
            
            let addedIndexPath = IndexPath(item: self.boards.count - 1, section: 0)
            
            self.collectionView.insertItems(at: [addedIndexPath])
            self.collectionView.scrollToItem(at: addedIndexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count = \(boards.count)")
        return boards.count+1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == boards.count{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addBoardCell", for: indexPath) as! addBoardCollectionViewCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kanbanCell", for: indexPath) as! BoardCollectionViewCell
        cell.parentVC=self
        cell.setup(with: boards[indexPath.item])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "previewCardSegueIndetifire"{
            print("found segue")
            if let cardCell = sender as? CardTableViewCell, let vc = segue.destination as? CardPreviewViewController{
                print("found cell card = \(cardCell.card)")
                vc.card = cardCell.card
                vc.delegate = cardCell
            }
            
        }
    }
}

