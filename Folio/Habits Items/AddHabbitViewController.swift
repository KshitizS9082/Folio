//
//  AddHabbitViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class AddHabbitViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!{
        didSet{
            //TODO: make it transparent
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
        }
    }
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource=self
        table.delegate=self
        table.separatorStyle = .none
        // Do any additional setup after loading the view.
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

extension AddHabbitViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCellIdentifier")!
            cell.backgroundColor = UIColor(named: "myBackgroundColor")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "habitStyleCellIdentifier")!
            cell.backgroundColor = UIColor(named: "myBackgroundColor")
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "goalPeriodCellIdentifier")!
            cell.backgroundColor = UIColor(named: "myBackgroundColor")
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "goalCountCellIdentifier")!
            cell.backgroundColor = UIColor(named: "myBackgroundColor")
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "reminderValuesCellIdentifier")!
            cell.backgroundColor = UIColor(named: "myBackgroundColor")
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}
