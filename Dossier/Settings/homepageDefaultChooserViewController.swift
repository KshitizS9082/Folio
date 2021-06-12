//
//  homepageDefaultChooserViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 19/02/21.
//  Copyright © 2021 Kshitiz Sharma. All rights reserved.
//

import UIKit

class homepageDefaultChooserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource=self
            tableView.delegate=self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("selected \(indexPath)")
        UserDefaults.standard.set(indexPath.row, forKey: "homePage_default_type")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Kanban"
        case 1:
            cell.textLabel?.text = "Finance"
        case 2:
            cell.textLabel?.text = "Habits"
        case 3:
            cell.textLabel?.text = "Journal"
        default:
            cell.backgroundColor = .red
        }
        return cell
    }
    

}
