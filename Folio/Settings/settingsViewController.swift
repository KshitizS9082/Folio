//
//  settingsViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 10/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import LocalAuthentication
enum switchType{
    case icloudSync
    case touchID
    case hapticFeedBack
}
protocol settingsViewControllerProtocol{
    func showAler(aler: UIAlertController)
}
class settingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, settingsViewControllerProtocol {
    func showAler(aler: UIAlertController) {
        self.present(aler, animated: true)
    }
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var navBar: UINavigationBar!{
        didSet{
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
//        case 0:
//            let cell = table.dequeueReusableCell(withIdentifier: "themeCell")!
//            return cell
        case 0:
            let cell = table.dequeueReusableCell(withIdentifier: "cloudSwitchCell") as! settingSwitchTableViewCell
            cell.type = .icloudSync
            cell.delegate=self
            cell.awakeFromNib()
            return cell
        case 1:
            let cell = table.dequeueReusableCell(withIdentifier: "cloudSwitchCell") as! settingSwitchTableViewCell
            cell.delegate=self
            cell.type = .touchID
            cell.awakeFromNib()
            return cell
        case 2:
        let cell = table.dequeueReusableCell(withIdentifier: "themeChooserTVC")!
            //setting darkmode/lightmode/automode
            var istylye = "text for interface style"
            let interfaceStyle = UserDefaults.standard.integer(forKey: "prefs_is_dark_mode_on")
            if interfaceStyle==0{
                istylye="Automatic"
            }else if interfaceStyle==1{
                istylye="Day Mode"
            }else if interfaceStyle==2{
                istylye="Night Mode"
            }
            cell.detailTextLabel?.text = istylye
        return cell
        case 3:
            let cell = table.dequeueReusableCell(withIdentifier: "homeDefaultChooserTVC")!
            let homePageDefault = UserDefaults.standard.integer(forKey: "homePage_default_type")
            switch homePageDefault {
            case 0:
                cell.detailTextLabel?.text = "Kanban"
            case 1:
                cell.detailTextLabel?.text = "Finance"
            case 2:
                cell.detailTextLabel?.text = "Habits"
            case 3:
                cell.detailTextLabel?.text = "Journal"
            default:
                cell.backgroundColor = .red
            }
        return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
            NSAttributedString.Key.foregroundColor: UIColor.systemGray,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 30)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        
        table.reloadData()
    }
    

}
class settingSwitchTableViewCell: UITableViewCell{
    var type: switchType?
    var delegate: settingsViewControllerProtocol?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBAction func switchChanged(_ sender: UISwitch) {
        switch self.type {
        case .icloudSync:
            UserDefaults.standard.set(sender.isOn, forKey: "cloudSync")
        case .touchID:
            if sender.isOn{
                let myContext = LAContext()
//                let myLocalizedReasonString = "Biometric Authntication testing !! "
                var authError: NSError?
                if !myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                    let ac = UIAlertController(title: "Bio Metric Unavailable", message: "Your device isn't configured for biometric authentication", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    delegate?.showAler(aler: ac)
                    sender.setOn(false, animated: true)
                }else{
                    UserDefaults.standard.set(sender.isOn, forKey: "AppIsLocked")
                }
            }else{
                UserDefaults.standard.set(sender.isOn, forKey: "AppIsLocked")
            }
        case .hapticFeedBack:
            UserDefaults.standard.set(sender.isOn, forKey: "hapticFeedBackDisabled")
        default:
            titleLabel.text="unknown type"
        }
    }
    override func awakeFromNib() {
        switch self.type {
        case .icloudSync:
            let name = UserDefaults.standard.bool(forKey: "cloudSync")
            switchButton.setOn(name, animated: false)
            titleLabel.text="iCloud Sync"
        case .touchID:
            let myContext = LAContext()
            var authError: NSError?
            if !myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                switchButton.setOn(false, animated: false)
                UserDefaults.standard.set(false, forKey: "AppIsLocked")
            }
            let name = UserDefaults.standard.bool(forKey: "AppIsLocked")
            switchButton.setOn(name, animated: false)
            titleLabel.text="Screen Lock"
        case .hapticFeedBack:
            let name = UserDefaults.standard.bool(forKey: "hapticFeedBackDisabled")
            switchButton.setOn(name, animated: false)
            titleLabel.text="Disable Haptic Feedback"
        default:
            titleLabel.text="unknown type"
        }
    }
    
}
