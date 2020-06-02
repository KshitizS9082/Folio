//
//  HabitsViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class HabitsViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "mainTextColor") ,
            NSAttributedString.Key.font: UIFont(name: "SnellRoundhand-Black", size: 30)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attrs
    }
    override func viewWillDisappear(_ animated: Bool) {
        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
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
