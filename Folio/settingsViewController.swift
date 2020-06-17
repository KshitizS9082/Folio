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
        let cell = table.dequeueReusableCell(withIdentifier: "lockCell")!
        return cell
        case 3:
        let cell = table.dequeueReusableCell(withIdentifier: "cloudSwitchCell") as! settingSwitchTableViewCell
        cell.delegate=self
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
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
