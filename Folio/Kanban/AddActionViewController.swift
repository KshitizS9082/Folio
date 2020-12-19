//
//  AddActionViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 18/12/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
protocol AddActionViewControllerProtocol {
    func addAction(newAction: Action)
}
class AddActionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddActionViewControllerProtocol {
    

    var delegate: EditCommandVCProtocol?
    var kanban = Kanban()
    
    @IBOutlet var backgroundView: UIView!{
        didSet{
            backgroundView.addBlurEffect(with: .systemChromeMaterial)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource=self
            tableView.delegate=self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "setTitleID") as! SetTitleToTVC
            cell.delegate=self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func addAction(newAction: Action) {
        delegate?.addAction(newAction: newAction)
        self.dismiss(animated: true, completion: nil)
    }

}

class SetTitleToTVC: UITableViewCell {
    var delegate: AddActionViewControllerProtocol?
    
    @IBOutlet weak var nwTitleTextField: UITextField!
    @IBOutlet weak var plusButtonIV: UIImageView!{
        didSet{
            plusButtonIV.isUserInteractionEnabled=true
            plusButtonIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped)))
        }
    }
    @objc func plusButtonTapped(){
        var newAction = Action(actionType: .setTitleTo)
        if let str = nwTitleTextField.text, str.count>0{
            newAction.newTitleString=str
            delegate?.addAction(newAction: newAction)
        }
    }
}
