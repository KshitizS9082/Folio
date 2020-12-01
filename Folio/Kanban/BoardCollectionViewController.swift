//
//  BoardCollectionViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 12/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
protocol BoardCVCProtocol {
    func updateBoard(newBoard: Board)
    func deleteBoard(board: Board)
}

class BoardCollectionViewController: UICollectionViewController {
    var boardFileName = "empty.json"{
        didSet{
            self.viewWillAppear(false)
        }
    }
//    var wallpaperPath: String?{
//        didSet{
//            self.viewWillAppear(false)
//        }
//    }
    var kanban = Kanban()
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
        layout.itemSize = CGSize(width: 300, height: size.height * 0.8)
    }
    func deleteWallPaper(){
        if let oldPath = self.kanban.wallpaperPath{
            if let oldurl = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(oldPath){
                do{
                    try FileManager.default.removeItem(at: oldurl)
                    print("deleted item \(oldurl) succefully")
                } catch{
                    print("ERROR: item  at \(oldurl) couldn't be deleted")
                    return
                }
            }
        }
    }
    
    @IBAction func addList(_ sender: UIButton) {
        print("addList tapped")
        let alertController = UIAlertController(title: "Add List", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else {
                return
            }
            
            self.kanban.boards.append(Board(title: text, items: []))
            
            let addedIndexPath = IndexPath(item: self.kanban.boards.count - 1, section: 0)
            
            self.collectionView.insertItems(at: [addedIndexPath])
            self.collectionView.scrollToItem(at: addedIndexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    @IBOutlet weak var backgroundImageView: UIImageView!{
        didSet{
            backgroundImageView.addBlurEffect()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count = \(kanban.boards.count)")
        return kanban.boards.count+1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == kanban.boards.count{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addBoardCell", for: indexPath) as! addBoardCollectionViewCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kanbanCell", for: indexPath) as! BoardCollectionViewCell
//        cell.parentVC=self
        cell.delegate=self
        cell.setup(with: kanban.boards[indexPath.item])
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
    
    func save(){
        print("viewwilalal board cvc save")
        if let json = kanban.json {
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(boardFileName){
                do {
                    try json.write(to: url)
                    print ("saved successfully")
                } catch let error {
                    print ("couldn't save \(error)")
                }
            }
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewwilalal boardvcv: \(self)")
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
                }
            }
            viewDidLoad()
            collectionView.reloadData()
        }
//        print("wallp: \(self.kanban.wallpaperPath)")
        if let wallpath = self.kanban.wallpaperPath{
            DispatchQueue.global(qos: .background).async {
            print("got wall path")
                if let url = try? FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                ).appendingPathComponent(wallpath){
                    if let jsonData = try? Data(contentsOf: url){
                        if let extract = imageData(json: jsonData){
                            let x=extract.data
                            if let image = UIImage(data: x){
                                print("got the background image")
                                DispatchQueue.main.async {
//                                    self.previewImageView.image = image
                                    self.backgroundImageView.image = image
                                }
                            }
                        }else{
                            print("couldnt get json from URL")
                        }
                    }
                }
            }
        }
        print("ended wall")
    }
}

extension BoardCollectionViewController: BoardCVCProtocol{
    func updateBoard(newBoard: Board) {
//        print("updating board to \(newBoard.items)")
        for ind in kanban.boards.indices{
            if kanban.boards[ind].uid == newBoard.uid{
                kanban.boards[ind]=newBoard
//                print("updating at ind= \(ind)")
                break
            }
        }
    }
    
    func deleteBoard(board: Board) {
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive){
            UIAlertAction in
            for ind in self.kanban.boards.indices{
                if self.kanban.boards[ind].uid == board.uid{
                    self.kanban.boards.remove(at: ind)
                    self.collectionView.deleteItems(at: [IndexPath(row: ind, section: 0)])
                    break
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        let alert = UIAlertController(title: "Delete Board?", message: "Deleting this card will also delete it's data", preferredStyle: .actionSheet)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
