//
//  switchKanbanTimelineTabBarController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 29/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class switchKanbanTimelineTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
        if let vc = self.viewControllers?[0] as? BoardCollectionViewController{
            vc.save()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
