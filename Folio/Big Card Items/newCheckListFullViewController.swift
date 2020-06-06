//
//  newCheckListFullViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 06/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

protocol newCheckListFullVCProtocol {
    func updateCheckListItem(to item: checkListItem, at index: IndexPath)
    func updated(indexpath: IndexPath)
}

class newCheckListFullViewController: UIViewController {

    var viewLinkedTo: cardView?
    var card: Card = Card()
    
    @IBOutlet weak var checkListTable: UITableView!{
        didSet{
            checkListTable.dataSource=self
            checkListTable.delegate=self
        }
    }
    
    @IBOutlet weak var navBar: UINavigationBar!{
        didSet{
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
        }
    }
    
    @objc func didTapAddButton(){
        print("did tap add")
        card.checkList.append(checkListItem(isCompleted: false, title: "new Text", notes: nil, url: nil))
        checkListTable.beginUpdates()
        checkListTable.insertRows(at: [IndexPath(row: card.checkList.count-1, section: 0)], with: .automatic)
        checkListTable.endUpdates()
    }
    
    @IBOutlet weak var addButtonIV: UIImageView!{
        didSet{
            addButtonIV.isUserInteractionEnabled=true
            addButtonIV.tintColor = .systemTeal
            addButtonIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAddButton)))
        }
    }
    
    @IBOutlet weak var addButtonTextLabel: UILabel!{
        didSet{
            addButtonTextLabel.isUserInteractionEnabled=true
            addButtonTextLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAddButton)))
        }
    }
    
    @IBAction func handleCancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func handleDoneTap(_ sender: Any) {
        viewLinkedTo?.card=card
        viewLinkedTo?.layoutSubviews()
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension newCheckListFullViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return card.checkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = checkListTable.dequeueReusableCell(withIdentifier: "checkListCell") as! fullChecklistViewTableViewCell
        cell.delegate=self
        cell.index=indexPath
        cell.item=card.checkList[indexPath.row]
        cell.awakeFromNib()
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.card.checkList.remove(at: indexPath.row)
            self.checkListTable.deleteRows(at: [indexPath], with: .automatic)
            print("deleted")
        }
    }
}

extension newCheckListFullViewController: newCheckListFullVCProtocol{
     func updateCheckListItem(to item: checkListItem, at index: IndexPath) {
        print("yet to update updateCheckListItem")
        card.checkList[index.row]=item
    }
    
    func updated(indexpath: IndexPath) {
           print("updated at indexpath: \(indexpath)")
           // Disabling animations gives us our desired behaviour
           UIView.setAnimationsEnabled(false)
           /* These will causes table cell heights to be recaluclated,
            without reloading the entire cell */
           checkListTable.beginUpdates()
           checkListTable.endUpdates()
           // Re-enable animations
           UIView.setAnimationsEnabled(true)

           checkListTable.scrollToRow(at: indexpath, at: .bottom, animated: false)
    
       }
}
