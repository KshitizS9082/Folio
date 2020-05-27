//
//  checkListFullViewController.swift
//  card2
//
//  Created by Kshitiz Sharma on 08/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import SPFakeBar
import SPStorkController

class checkListFullViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SPStorkControllerDelegate {
    var viewLinkedTo: cardView?
    var card: Card = Card()
    let navBar = SPFakeBarView(style: .stork)
    let addButton = UIImageView()
    let addButtonText = UILabel()
    var checkListTable = UITableView()
    
    
    
    func setNavBar(){
        self.navBar.titleLabel.text = ""
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 30),
            .foregroundColor: UIColor.systemBlue
        ]
        let title = NSAttributedString(string: "Tasks", attributes: attributes)
        self.navBar.leftButton.setAttributedTitle(title, for: .normal)
        self.view.addSubview(self.navBar)
    }
    func setAddButton(){
        if view.subviews.contains(addButton)==false{
            view.addSubview(addButton)
        }
        addButton.translatesAutoresizingMaskIntoConstraints=false
        addButton.isUserInteractionEnabled=true
        [
            addButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 6),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor)
            ].forEach { (cst) in
                cst.isActive=true
        }
        addButton.image=UIImage(systemName: "plus.circle.fill")
        addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAddButton)))
        
        if view.subviews.contains(addButtonText)==false{
            view.addSubview(addButtonText)
        }
        addButtonText.translatesAutoresizingMaskIntoConstraints=false
        addButtonText.isUserInteractionEnabled=true
        [
            addButtonText.leftAnchor.constraint(equalTo: addButton.rightAnchor, constant: 6),
            addButtonText.bottomAnchor.constraint(equalTo: addButton.bottomAnchor),
            addButtonText.heightAnchor.constraint(equalTo: addButton.heightAnchor),
            addButtonText.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor)
            ].forEach { (cst) in
                cst.isActive=true
        }
        let attributes: [NSAttributedString.Key: Any] = [
                   .font: UIFont.boldSystemFont(ofSize: addButtonTextFontSize),
                   .foregroundColor: UIColor.systemBlue
               ]
        addButtonText.attributedText = NSAttributedString(string: "New Sub-Task", attributes: attributes)
        addButtonText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAddButton)))
        
    }
    @objc func didTapAddButton(){
        print("did tap add")
        card.checkList.append(checkListItem(isCompleted: false, title: "new textfsdf", notes: nil, url: nil))
        checkListTable.beginUpdates()
        checkListTable.insertRows(at: [IndexPath(row: card.checkList.count-1, section: 0)], with: .automatic)
        checkListTable.endUpdates()
    }
    func configureCheckListTable(){
        checkListTable.dataSource=self
        checkListTable.register(UITableViewCell.self, forCellReuseIdentifier: "cardCheckListCell")
        checkListTable.backgroundColor = checkListBackgroundColor
        if(view.subviews.contains(checkListTable)==false){
            view.addSubview(checkListTable)
        }
        checkListTable.translatesAutoresizingMaskIntoConstraints = false
        [
            checkListTable.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            checkListTable.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -6),
            checkListTable.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            checkListTable.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            ].forEach { (constraints) in
                constraints.isActive = true
        }
        checkListTable.allowsSelection = false//TODO:   WHY?
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return card.checkList.count
       }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCheckListCell", for: indexPath)// as! checkListTableViewCell
        cell.textLabel?.text = "  "+card.checkList[indexPath.row].title!
        cell.textLabel?.font = UIFont(name: checkListFontStyle, size: checkListFontSize)
        cell.textLabel?.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: cell.textLabel!.font)
        cell.setEditing(true, animated: true)
        cell.textLabel?.isUserInteractionEnabled = true
        cell.textLabel?.isEnabled = true
       if(card.checkList[indexPath.row].isCompleted!){
           cell.imageView?.image =  UIImage(systemName: "largecircle.fill.circle")
       }else{
           cell.imageView?.image = UIImage(systemName: "circle")
       }
       cell.imageView?.isUserInteractionEnabled=true
       let tap = myTapRecogniser(target: self, action: #selector(toggleCheckBox(sender:)))
       tap.indexPath = indexPath
       cell.imageView?.addGestureRecognizer(tap)
       print("returning cell")
       return cell
    }
    @objc func toggleCheckBox(sender: myTapRecogniser){
        print(sender.index)
        card.checkList[sender.indexPath!.row].isCompleted = !card.checkList[sender.indexPath!.row].isCompleted!
        self.checkListTable.reloadRows(at: [sender.indexPath!], with: UITableView.RowAnimation.automatic)
    }
    class myTapRecogniser: UITapGestureRecognizer {
       var indexPath: IndexPath?
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.card.checkList.remove(at: indexPath.row)
            self.checkListTable.deleteRows(at: [indexPath], with: .automatic)
            print("deleted")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = checkListBackgroundColor
        setNavBar()
        setAddButton()
        configureCheckListTable()
        checkListTable.dataSource = self
        checkListTable.delegate = self
        checkListTable.register(UITableViewCell.self, forCellReuseIdentifier: "cardCheckListCell")
        checkListTable.rowHeight = UITableView.automaticDimension
        checkListTable.estimatedRowHeight = 200
    }
    func didDismissStorkByTap() {
        print("dismissed by tap")
        viewLinkedTo?.card=card
        viewLinkedTo?.layoutSubviews()
    }
    func didDismissStorkBySwipe() {
        print("dismissed by swipe")
        didDismissStorkByTap()
    }
}
extension checkListFullViewController{
    var checkListFontStyle: String{
        return "AppleSDGothicNeo-Regular"
    }
    var checkListFontSize: CGFloat{
        return 25
    }
    var addButtonTextFontSize: CGFloat{
        return 20
    }
    var checkListBackgroundColor: UIColor{
        return UIColor(named: "bigCardColor") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
}
extension checkListFullViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SPStorkController.scrollViewDidScroll(scrollView)
    }
}
