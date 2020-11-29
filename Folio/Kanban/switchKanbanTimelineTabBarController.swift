//
//  switchKanbanTimelineTabBarController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 29/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class switchKanbanTimelineTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate=self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.systemGray ,
            NSAttributedString.Key.font: UIFont(name: "SnellRoundhand-Black", size: 30)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attrs
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        print("vwlds")
        if let vc = self.selectedViewController as? BoardCollectionViewController{
            vc.save()
        }else if let vc = self.selectedViewController as? NewKanbanTimelineViewController{
            vc.save()
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let vc = viewController as? NewKanbanTimelineViewController{
//            print("viewwilalal selecting second")
            let orig = self.viewControllers?[0] as! BoardCollectionViewController
            orig.save()
            
        }else if let vc = viewController as? BoardCollectionViewController{
//            print("viewwilalal selection first")
            let orig = self.viewControllers?[1] as! NewKanbanTimelineViewController
            orig.save()
            
        }
        return true
    }

}
