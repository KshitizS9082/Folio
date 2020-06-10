//
//  settingsViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 10/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
enum switchType{
    case icloudSync
    case touchID
    case hapticFeedBack
}

class settingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var navBar: UINavigationBar!{
        didSet{
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = table.dequeueReusableCell(withIdentifier: "themeCell")!
            return cell
        case 1:
            let cell = table.dequeueReusableCell(withIdentifier: "cloudSwitchCell") as! settingSwitchTableViewCell
            cell.type = .icloudSync
            cell.awakeFromNib()
            return cell
        case 2:
            let cell = table.dequeueReusableCell(withIdentifier: "cloudSwitchCell") as! settingSwitchTableViewCell
            cell.type = .touchID
            cell.awakeFromNib()
            return cell
        case 3:
        let cell = table.dequeueReusableCell(withIdentifier: "lockCell")!
        return cell
        case 4:
        let cell = table.dequeueReusableCell(withIdentifier: "cloudSwitchCell") as! settingSwitchTableViewCell
        cell.type = .hapticFeedBack
        cell.awakeFromNib()
        return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
class settingSwitchTableViewCell: UITableViewCell{
    var type: switchType?
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func switchChanged(_ sender: UISwitch) {
        
    }
    override func awakeFromNib() {
        switch self.type {
        case .icloudSync:
            titleLabel.text="iCloud Sync"
        case .touchID:
            titleLabel.text="Require Touch ID To Unlock"
        case .hapticFeedBack:
            titleLabel.text="Haptic Feedback"
        default:
            titleLabel.text="unknown type"
        }
    }
}
