//
//  PageListSideMenuTableViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 01/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import SideMenu

class PageListSideMenuTableViewController: UITableViewController {

    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource=self
        table.delegate=self
        self.navigationController?.navigationBar.isHidden=true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
//        self.navigationController?.navigationBar.isHidden=true
//        let attrs = [
//            NSAttributedString.Key.foregroundColor: UIColor.systemGray,
//            NSAttributedString.Key.font: UIFont(name: "SnellRoundhand-Black", size: 35)!
//        ]
//        self.navigationController?.navigationBar.titleTextAttributes = attrs
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        print("asking for count")
        return 7
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! UITableViewVibrantCell
//
//        if let menu = navigationController as? SideMenuNavigationController {
//            cell.blurEffectStyle = menu.blurEffectStyle
//        }
//
//        return cell
//    }
    @objc func dismissSideMenu(){
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCellIdentifier", for: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeCellIdentifier", for: indexPath)
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSideMenu)))
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "kanbanCellIdentifier", for: indexPath)
//            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSideMenu)))
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "journalCellIdentifier", for: indexPath)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "habitsCellIdentifier", for: indexPath)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "walletCellIdentifier", for: indexPath)
            return cell
        case 6:
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCellIdentifier", for: indexPath)
        return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
            return cell
        }
        
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
