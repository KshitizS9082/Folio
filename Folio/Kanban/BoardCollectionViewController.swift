//
//  BoardCollectionViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 12/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import UserNotifications
protocol BoardCVCProtocol {
    func updateBoard(newBoard: Board)
    func deleteBoard(board: Board)
    func dragDropCard(sourceCardUID: String, targetBoardID: UUID, targetIndex: Int)
}

class BoardCollectionViewController: UICollectionViewController {
    var kanbanFileName = "empty.json"{
        didSet{
            self.viewWillAppear(false)
        }
    }
    
    let magnButton = UIButton()
    
    var cellWidth = CGFloat(300.0)
    
    var kanban = Kanban()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongGestureForReorder)))
//        setupAddButtonItem()
        updateCollectionViewItem(with: view.bounds.size)

        if view.subviews.contains(magnButton)==false{
            view.addSubview(magnButton)
            view.bringSubviewToFront(magnButton)
            magnButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(magnButtonClickHandle)))
            magnButton.backgroundColor = (UIColor.systemGray6).withAlphaComponent(0.8)
            magnButton.layer.cornerRadius = 8
            magnButton.setImage(UIImage(systemName: "minus.magnifyingglass"), for: .normal)
            magnButton.translatesAutoresizingMaskIntoConstraints=false
            [
                magnButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
                magnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                magnButton.widthAnchor.constraint(equalToConstant: 50),
                magnButton.heightAnchor.constraint(equalTo: magnButton.widthAnchor)
            ].forEach { (cst) in
                cst.isActive=true
            }
        }
    }
    
    @objc func handleLongGestureForReorder(gesture: UILongPressGestureRecognizer){
        switch(gesture.state){
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.collectionView!.indexPathForItem(at: gesture.location(in: self.collectionView)) else{
                    break
                }
            collectionView!.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            collectionView!.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            collectionView!.endInteractiveMovement()
        default:
            collectionView!.cancelInteractiveMovement()
        }
    }
    
    @objc func magnButtonClickHandle(){
        print("magnButton clicked")
//        UIView.animate(withDuration: 1, animations: {
//            self.collectionView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
//        }) { (finished) in
////            UIView.animate(withDuration: 1, animations: {
////                self.view.transform = CGAffineTransform.identity
////            })
//        }
        if cellWidth==CGFloat(300.0){
            cellWidth=CGFloat(200.0)
            magnButton.setImage(UIImage(systemName: "plus.magnifyingglass"), for: .normal)
        }else{
            cellWidth=CGFloat(300.0)
            magnButton.setImage(UIImage(systemName: "minus.magnifyingglass"), for: .normal)
        }
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
//        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            layout.itemSize = CGSize(width: self.cellWidth, height: self.view.bounds.size.height * 0.8)
//        }, completion: nil)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateCollectionViewItem(with: size)
    }
  
    private func updateCollectionViewItem(with size: CGSize) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.itemSize = CGSize(width: cellWidth, height: size.height * 0.8)
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
//        let alertController = UIAlertController(title: "Add List", message: nil, preferredStyle: .alert)
//        alertController.addTextField(configurationHandler: nil)
//        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
//            guard let text = alertController.textFields?.first?.text, !text.isEmpty else {
//                return
//            }
//
//            self.kanban.boards.append(Board(title: text, items: []))
//
//            let addedIndexPath = IndexPath(item: self.kanban.boards.count - 1, section: 0)
//
//            self.collectionView.insertItems(at: [addedIndexPath])
//            self.collectionView.scrollToItem(at: addedIndexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
//        }))
//
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(alertController, animated: true)
        
        self.kanban.boards.append(Board(title: "", items: []))
        
        let addedIndexPath = IndexPath(item: self.kanban.boards.count - 1, section: 0)
        self.collectionView.insertItems(at: [addedIndexPath])
        self.collectionView.scrollToItem(at: addedIndexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        if let cell = collectionView.cellForItem(at: addedIndexPath) as? BoardCollectionViewCell{
            cell.titleTextField.becomeFirstResponder()
        }
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
            ).appendingPathComponent(kanbanFileName){
                do {
                    try json.write(to: url)
                    print ("saved successfully")
                } catch let error {
                    print ("couldn't save \(error)")
                }
            }
        }

    }
    func checkTrigger(trigger: Trigger, card: KanbanCard, boardInd: Int) -> Bool{
        switch trigger.triggerType {
        case .xBeforeSchedule:
            var dateComponent = DateComponents()
            dateComponent.day = trigger.daysBeforeSchedule
            dateComponent.hour = trigger.hoursBeforeSchedule
            let addedDate = Calendar.current.date(byAdding: dateComponent, to: Date())!
            if let scheduledDate = card.scheduledDate, scheduledDate <= addedDate{
                return true
            }else{
                return false
            }
        case .ifFromBoard:
            return kanban.boards[boardInd].title == trigger.fromBoard
        case .ifTaskType:
            return card.isTask == trigger.taskType
        case .ifTilteIs:
            return card.title == trigger.titleString
        case .ifTitleContains:
            return card.title.contains(trigger.titleString!)
        case .ifChecklistHasAllIncomplete:
            if card.checkList.items.count==0{
                return false
            }
            for item in card.checkList.items{
                if item.done==true{
                    return false
                }
            }
            return true
        case .ifChecklistHasAllComplete:
            if card.checkList.items.count==0{
                return false
            }
            for item in card.checkList.items{
                if item.done==false{
                    return false
                }
            }
            return true
        case .ifHasTag:
            return card.tagColor == trigger.tagColor
        case .ifHasURLSetTo:
            if trigger.hasURL{
                return card.linkURL.count>0
            }else{
                return card.linkURL.count==0
            }
        default:
            print("ERROR: yet to handle triggerType: \(trigger.triggerType)")
            return false
        }
    }
    func checkCommandCondition(condition: [Trigger], card: KanbanCard, boardInd: Int) -> Bool{
        for trigger in condition{
            if checkTrigger(trigger: trigger, card: card, boardInd: boardInd) == false{
                return false
            }
        }
        return true
    }
    func executeAction(action: Action, boardInd: Int, cardInd: Int){
        if !(boardInd<kanban.boards.count && cardInd<kanban.boards[boardInd].items.count){
            return
        }
        switch action.actionType {
        case .setTitleTo:
            kanban.boards[boardInd].items[cardInd].title = action.newTitleString
        case .advanceDueDateByX:
            if let sd = kanban.boards[boardInd].items[cardInd].scheduledDate{
                var dateComponent = DateComponents()
                dateComponent.day = action.xDays
                dateComponent.hour = action.xHours
                let addedDate = Calendar.current.date(byAdding: dateComponent, to: sd)!
                kanban.boards[boardInd].items[cardInd].scheduledDate = addedDate
            }
        case .setTaskTo:
            kanban.boards[boardInd].items[cardInd].isTask = action.taskType
        case .setChecklistItemsTo:
            if action.checkListValue==true{
                for clind in kanban.boards[boardInd].items[cardInd].checkList.items.indices{
                    kanban.boards[boardInd].items[cardInd].checkList.items[clind].done=true
                }
            }else if action.checkListValue==false{
                for clind in kanban.boards[boardInd].items[cardInd].checkList.items.indices{
                    kanban.boards[boardInd].items[cardInd].checkList.items[clind].done=false
                }
            }else{
                print("ERROR: found unexpected value in action.checkListValue when accesed in executeAction")
            }
        case .deleteChecklistItemsWhichAre:
            if let ccvalue = action.checkListValue{
                if ccvalue{
                    kanban.boards[boardInd].items[cardInd].checkList.items = kanban.boards[boardInd].items[cardInd].checkList.items.filter({ (item) -> Bool in
                        item.done ==  false
                    })
                }else{
                    kanban.boards[boardInd].items[cardInd].checkList.items = kanban.boards[boardInd].items[cardInd].checkList.items.filter({ (item) -> Bool in
                        item.done ==  true
                    })
                }
            }else{
                kanban.boards[boardInd].items[cardInd].checkList.items.removeAll()
            }
        case .setDueDateToNone:
            kanban.boards[boardInd].items[cardInd].scheduledDate = nil
        case .setTagTo:
            kanban.boards[boardInd].items[cardInd].tagColor = action.tagColor
//        case .deleteCard:
//            //Warning: not working somehow
//            kanban.boards[boardInd].items.remove(at: cardInd)
        default:
            print("ERROR: yet to handle actionType: \(action.actionType)")
        }
    }
    func executeCommandExuction(execution: [Action], boardInd: Int, cardInd: Int){
        for action in execution{
            executeAction(action: action, boardInd: boardInd, cardInd: cardInd)
        }
    }
    func implementAutomationCommands(){
        for command in kanban.commands{
            print("trying to execute command: \(command.enabled)")
            if !command.enabled{
                continue
            }
            print("will to execute command: \(command.enabled)")
            for boardInd in kanban.boards.indices{
                for cardInd in kanban.boards[boardInd].items.indices{
                    if boardInd < kanban.boards.count && cardInd < kanban.boards[boardInd].items.count{
                        if checkCommandCondition(condition: command.condition, card: kanban.boards[boardInd].items[cardInd], boardInd: boardInd){
                            executeCommandExuction(execution: command.execution, boardInd: boardInd, cardInd: cardInd)
                        }
                    }
                }
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
        print("viewwilalal boardvcv: \(self)")
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent(kanbanFileName){
//            print("trying to extract contents of kanbanData")
            if let jsonData = try? Data(contentsOf: url){
                //                pageList = pageInfo(json: jsonData)
                if let x = Kanban(json: jsonData){
                    kanban = x
                }else{
                    print("WARNING: COULDN'T UNWRAP JSON DATA TO FIND kanbanData")
                }
            }
            self.implementAutomationCommands()
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
//        print("ended wall")
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.kanban.boards.swapAt(sourceIndexPath.row, destinationIndexPath.row)
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
            for card in board.items{
                UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                    var identifiers: [String] = []
                    for notification:UNNotificationRequest in notificationRequests {
                        if notification.identifier == card.UniquIdentifier.uuidString {
                            identifiers.append(notification.identifier)
                        }
                    }
                    print("removing notifs with identifiers \(identifiers)")
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                }
            }
            for ind in self.kanban.boards.indices{
                if self.kanban.boards[ind].uid == board.uid{
                    for item in self.kanban.boards[ind].items{
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
                                    print("ERROR: item  at \(imageUrl) couldn't be deleted")
                                    return
                                }
                            }
                        }
                    }
                    self.kanban.boards.remove(at: ind)
                    self.collectionView.deleteItems(at: [IndexPath(row: ind, section: 0)])
                    break
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        let alert = UIAlertController(title: "Delete Board?", message: "Deleting this board will also delete it's data", preferredStyle: .actionSheet)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func dragDropCard(sourceCardUID: String, targetBoardID: UUID, targetIndex: Int){
        var sourceBoardInd = -1
        var sourcCardInd = -1
        var targBoardInd = -1
        for ind in kanban.boards.indices{
            let board=kanban.boards[ind]
            for innerind in board.items.indices{
                let card = board.items[innerind]
                if card.UniquIdentifier.uuidString == sourceCardUID{
                    sourceBoardInd=ind
                    sourcCardInd=innerind
                }
            }
            if board.uid==targetBoardID{
                targBoardInd=ind
            }
        }
        if sourceBoardInd<0{
            return
        }
        moveCell(sourceBoard: sourceBoardInd, sourceCard: sourcCardInd, targetBoard: targBoardInd, targetCard: targetIndex)
    }
    func moveCell(sourceBoard: Int, sourceCard: Int, targetBoard: Int, targetCard: Int ){
        let source = kanban.boards[sourceBoard].items[sourceCard]
        kanban.boards[sourceBoard].items.remove(at: sourceCard)
        kanban.boards[targetBoard].items.insert(source, at: targetCard)
        if let boardCell = collectionView.cellForItem(at: IndexPath(row: sourceBoard, section: 0)) as? BoardCollectionViewCell{
            boardCell.tableView.beginUpdates()
            boardCell.tableView.deleteRows(at: [IndexPath(row: sourceCard, section: 0)], with: .automatic)
            boardCell.tableView.endUpdates()
        }
        if let boardCell = collectionView.cellForItem(at: IndexPath(row: targetBoard, section: 0)) as? BoardCollectionViewCell{
            //TODO: change it to tableview.insertRowAt
            boardCell.setup(with: kanban.boards[targetBoard])
//            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}
