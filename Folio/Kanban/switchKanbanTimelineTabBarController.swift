//
//  switchKanbanTimelineTabBarController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 29/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class switchKanbanTimelineTabBarController: UITabBarController, UITabBarControllerDelegate {
    var boardFileName = "Inster File Name SKTTC"
    var boardName = "Insert Title SKTTC"
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
//    override func viewDidAppear(_ animated: Bool) {
//        print("viewwilala vdl switch")
//        if let vc = self.selectedViewController as? BoardCollectionViewController{
//            print("viewwilala first")
//        }else if let vc = self.selectedViewController as? NewKanbanTimelineViewController{
//            print("viewwilala second ")
//        }
//    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.systemGray ,
            NSAttributedString.Key.font: UIFont(name: "SnellRoundhand-Black", size: 30)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        self.navigationController?.title = self.boardName
    }
    override func viewDidAppear(_ animated: Bool) {
//        if let vc = self.selectedViewController as? BoardCollectionViewController{
//            vc.boardFileName=self.boardFileName
//        }else if let vc = self.selectedViewController as? NewKanbanTimelineViewController{
//            vc.boardFileName=self.boardFileName
//        }
        let vc0 = self.viewControllers?[0] as! BoardCollectionViewController
        print("setting vc0 bfname")
        vc0.boardFileName=self.boardFileName
//        let vc1 = self.viewControllers?[1] as! NewKanbanTimelineViewController
//        print("setting vc1 bfname")
//        vc1.boardFileName=self.boardFileName
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "SnellRoundhand-Black", size: 30)!]
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
            let orig = self.viewControllers?[0] as! BoardCollectionViewController
            orig.save()
            if vc.boardFileName != self.boardFileName{
                vc.boardFileName=self.boardFileName
            }
        }else if let vc = viewController as? BoardCollectionViewController{
            print("viewwilalal selection first")
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

}
