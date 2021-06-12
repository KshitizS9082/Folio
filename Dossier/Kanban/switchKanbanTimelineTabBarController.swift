//
//  switchKanbanTimelineTabBarController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 29/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import ImagePicker

class switchKanbanTimelineTabBarController: UITabBarController, UITabBarControllerDelegate {
    var kanbanDelegate: KanbanListProtcol?
    var kanbanFileName = "Inster File Name SKTTC"
    var boardName = "Insert Title SKTTC"
    var isdeleting=false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate=self
        // Do any additional setup after loading the view.
//        if let vc = self.selectedViewController as? BoardCollectionViewController{
//            print("viewwilala first")
//        }else if let vc = self.selectedViewController as? NewKanbanTimelineViewController{
//            print("viewwilala second ")
//        }
    }

    //Note: addAutomationButton need to be hidden when in timeline as otherwise won't save
    @IBOutlet weak var addAutomationButton: UIBarButtonItem!
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
            NSAttributedString.Key.foregroundColor: UIColor.systemGray6 ,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 30)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        self.navigationController?.title = self.boardName
        let vc0 = self.viewControllers?[0] as! BoardCollectionViewController
        print("setting vc0 bfname")
        vc0.kanbanFileName=self.kanbanFileName
    }
    override func viewDidAppear(_ animated: Bool) {
//        if let vc = self.selectedViewController as? BoardCollectionViewController{
//            vc.boardFileName=self.boardFileName
//        }else if let vc = self.selectedViewController as? NewKanbanTimelineViewController{
//            vc.boardFileName=self.boardFileName
//        }
//        let vc0 = self.viewControllers?[0] as! BoardCollectionViewController
//        print("setting vc0 bfname")
//        vc0.boardFileName=self.boardFileName
//        let vc1 = self.viewControllers?[1] as! NewKanbanTimelineViewController
//        print("setting vc1 bfname")
//        vc1.boardFileName=self.boardFileName
    }
    override func viewWillDisappear(_ animated: Bool) {
        if isdeleting{
            return
        }
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 30)!]
        print("vwlds")
        if let vc = self.selectedViewController as? BoardCollectionViewController{
            vc.save()
        }else if let vc = self.selectedViewController as? NewKanbanTimelineViewController{
            vc.save()
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let vc = viewController as? NewKanbanTimelineViewController{
            print("viewwilalal selecting second")
            self.addAutomationButton.isEnabled=false
            let orig = self.viewControllers?[0] as! BoardCollectionViewController
            orig.save()
            if vc.boardFileName != self.kanbanFileName{
                vc.boardFileName=self.kanbanFileName
            }
        }else if viewController is BoardCollectionViewController{
            print("viewwilalal selection first")
            self.addAutomationButton.isEnabled=true
            let orig = self.viewControllers?[1] as! NewKanbanTimelineViewController
            orig.save()
            
        }
        return true
    }
    @IBAction func editElipsisPressed(_ sender: UIBarButtonItem) {
        print("ellipsisPressed")
        if let vc = self.selectedViewController as? NewKanbanTimelineViewController{
            print("NewKanbanTimelineViewController identified")
            editTimelinePressed(vc: vc, barButton: sender)
        }else if let vc = self.selectedViewController as? BoardCollectionViewController{
            editBoardPressed(vc: vc, barButton: sender)
        }
    }
    func editTimelinePressed(vc: NewKanbanTimelineViewController, barButton: UIBarButtonItem){
        let sortBoard = UIAlertAction(title: "Sort By Board",
                                    style: .default) { (action) in
            vc.sortStyle = .board
            vc.setAllCards()
        }
        let sortSchedule = UIAlertAction(title: "Sort By Schedule Date",
                                      style: .default) { (action) in
            vc.sortStyle = .scheduleDate
            vc.setAllCards()
        }
        let sortDateofConstruct = UIAlertAction(title: "Sort By Date of Construction",
                                      style: .default) { (action) in
            vc.sortStyle = .dateOfConstruction
            vc.setAllCards()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (action) in
                                            // Respond to user selection of the action
        }
        
        let alert = UIAlertController(title: "Sort Cards",
                                      message: "filter what to see",
                                      preferredStyle: .actionSheet)
        alert.addAction(sortBoard)
        alert.addAction(sortSchedule)
        alert.addAction(sortDateofConstruct)
        alert.addAction(cancelAction)
        // On iPad, action sheets must be presented from a popover.
        alert.popoverPresentationController?.barButtonItem = barButton
        self.present(alert, animated: true, completion: nil)
    }
    func editBoardPressed(vc: BoardCollectionViewController, barButton: UIBarButtonItem){
        let changeWall = UIAlertAction(title: "Change Wallpaper",
                                       style: .default) { (action) in
            self.setWallpaper(vc: vc)
        }
        let unsetWall = UIAlertAction(title: "Unset Wallpaper",
                                      style: .default) { (action) in
            self.deleteWallpaper(vc: vc)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (action) in
                                            // Respond to user selection of the action
        }
//        let deleteAction = UIAlertAction(title: "Delete kanban",
//                                         style: .destructive) { (action) in
//            self.deleteKanban(vc: vc)
//        }
        
        let alert = UIAlertController(title: "Edit Board",
                                      message: "Edit Board",
                                      preferredStyle: .actionSheet)
        alert.addAction(changeWall)
        alert.addAction(unsetWall)
//        alert.addAction(sortDateofConstruct)
        alert.addAction(cancelAction)
//        alert.addAction(deleteAction)
        // On iPad, action sheets must be presented from a popover.
        alert.popoverPresentationController?.barButtonItem = barButton
        self.present(alert, animated: true, completion: nil)

    }
    var BoardCVC: BoardCollectionViewController?
    func setWallpaper(vc: BoardCollectionViewController){
        self.BoardCVC=vc
        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 1
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    func deleteWallpaper(vc: BoardCollectionViewController){
        //delete old wallpaper
        vc.deleteWallPaper()
        vc.viewWillAppear(false)
    }
    /* not working
    func deleteKanban(vc: BoardCollectionViewController){
        for board in vc.kanban.boards{
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
//                            return
                        }
                    }
                }
            }
        }
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent(boardFileName){
            do{
                try FileManager.default.removeItem(at: url)
                print("deleted kanban item \(url) succefully")
            } catch{
                print("ERROR: kanban  at \(url) couldn't be deleted. Causes datalink")
//                            return
            }
        }
        kanbanDelegate?.updateBoardDeleteInfo(for: self.boardFileName)
        isdeleting=true
        self.navigationController?.popViewController(animated: true)
    }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="addAutomationSegue"{
            let vc = segue.destination as! AddAutomationViewController
            vc.boardFileName = self.kanbanFileName
            
        }
    }
}
extension switchKanbanTimelineTabBarController: ImagePickerDelegate{
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.expandGalleryView()
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        let fileName=String.uniqueFilename(withPrefix: "kabanWallPaperImageData")+".json"
        if images.count==0{
            print("no image returned")
            return
        }
        let image = images[0]
        if let json = imageData(instData: image.resizedTo1MB()!.pngData()!).json {
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(fileName){
                do {
                    /*
                    //delete old wallpaper
                    if let oldPath = self.BoardCVC?.kanban.wallpaperPath{
                        if let oldurl = try? FileManager.default.url(
                            for: .documentDirectory,
                            in: .userDomainMask,
                            appropriateFor: nil,
                            create: true
                        ).appendingPathComponent(oldPath){
                            let fileNameToDelete = "myFileName.txt"
                            var filePath = ""
                            
                            // Fine documents directory on device
                            let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
                            
                            if dirs.count > 0 {
                                let dir = dirs[0] //documents directory
                                filePath = dir.appendingFormat("/" + fileNameToDelete)
                                print("Local path = \(filePath)")
                            } else {
                                print("Could not find local directory to store file")
                                return
                            }
                            
                            let fileManager = FileManager.default
                            // Check if file exists
                            if fileManager.fileExists(atPath: filePath) {
                                print("old File exists now trying to delete")
                                do{
                                    try FileManager.default.removeItem(at: oldurl)
                                    print("deleted item \(oldurl) succefully")
                                } catch{
                                    print("ERROR: item  at \(oldurl) couldn't be deleted")
                                    return
                                }
                            } else {
                                print("File does not exist")
                            }
                            
                            
                        }
                    }
                    */
                    self.BoardCVC?.deleteWallPaper()
                    try json.write(to: url)
                    print ("saved kanban wall successfully with name \(fileName)")
                    self.BoardCVC?.kanban.wallpaperPath=fileName
                    self.BoardCVC?.save()
                    self.BoardCVC?.viewWillAppear(false)
                } catch let error {
                    print ("couldn't save \(error)")
                }
            }
        }
        imagePicker.dismiss(animated: true, completion: nil)
//        BoardCVC.kanban.wallpaperPath=path
//        BoardCVC.viewWillAppear(false)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
}
