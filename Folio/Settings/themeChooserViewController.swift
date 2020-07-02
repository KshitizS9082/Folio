//
//  themeChooserViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 10/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class themeChooserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Day Mode"
            cell.imageView?.image = UIImage(systemName: "circle")
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setDayMode)))
            
        case 1:
            cell.textLabel?.text = "Night Mode"
            cell.imageView?.image = UIImage(systemName: "moon.circle")
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setNightMode)))
        case 2:
            cell.textLabel?.text = "Automatic"
            cell.imageView?.image = UIImage(systemName: "circle.lefthalf.fill")
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setAutoMode)))
        default:
            cell.textLabel?.text = "Unkown case"
        }
        return cell
    }
    @objc func setDayMode(){
         overrideUserInterfaceStyle = .light
    }
    @objc func setNightMode(){
        overrideUserInterfaceStyle = .dark
    }
    @objc func setAutoMode(){
        overrideUserInterfaceStyle = .unspecified
    }
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {
            //Do post dismissing
        }
    }
    
    @IBOutlet weak var navBar: UINavigationBar!{
        didSet{
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
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
