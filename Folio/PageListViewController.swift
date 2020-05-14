//
//  PageListViewController.swift
//  card2
//
//  Created by Kshitiz Sharma on 27/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class PageListViewController: UIViewController {
    var pages = [PageData]()
    var addPageButton = UIImageView(image: UIImage(systemName: "plus.circle.fill"))
    var titleLabel = UILabel()
    
    @IBOutlet weak var table: UITableView!
    private func configureHeading(){
        if view.subviews.contains(addPageButton)==false{
            view.addSubview(addPageButton)
        }
        addPageButton.translatesAutoresizingMaskIntoConstraints=false
        [
            addPageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            addPageButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            addPageButton.widthAnchor.constraint(equalToConstant: 40),
            addPageButton.heightAnchor.constraint(equalToConstant: 40)
            ].forEach { (cst) in
                cst.isActive=true
        }
        addPageButton.isUserInteractionEnabled=true
        addPageButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPage)))
        
        if view.subviews.contains(titleLabel)==false{
            view.addSubview(titleLabel)
        }
        titleLabel.translatesAutoresizingMaskIntoConstraints=false
        [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: addPageButton.leftAnchor)//,
            //            titleLabel.heightAnchor.constraint(equalToConstant: 45)
            ].forEach { (cst) in
                cst.isActive=true
        }
        titleLabel.text = "Folio's"//or chronicle
        titleLabel.font = UIFont(name: "SnellRoundhand-Black", size: 40)
    }
    
    private func configureTable(){
        table.translatesAutoresizingMaskIntoConstraints=false
        [
            table.topAnchor.constraint(equalTo: addPageButton.bottomAnchor, constant: 10),
            table.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ].forEach { (cst) in
                cst.isActive=true
        }
        
        table.backgroundColor = backgroundColour
        view.backgroundColor = backgroundColour
        table.dataSource=self
        table.delegate=self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:  UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(addPage))
        pages.append(PageData(title: "First Page"))
        pages.append(PageData(title: "Second Page"))
        configureHeading()
        configureTable()
        // Do any additional setup after loading the view.
    }
    
    @objc func addPage(){
        pages.append(PageData())
        table.reloadData()
    }
    
    // MARK: - Navigation
    var selectedCell: Int?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openPage"{
            if let targetController = segue.destination as? SwitchPageTimelineViewController{
                targetController.page = pages[selectedCell!]
                targetController.index = selectedCell!
                targetController.myViewController=self
                print("passing pageTitle: \(pages[selectedCell!].title)")
            }
        }
    }
    
}
extension PageListViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pageCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = pages[indexPath.row].title
        cell.backgroundColor = cellColour
        let time = pages[indexPath.row].lasteDateOfEditting
        let formatter = DateFormatter()
        //        formatter.dateFormat = "d/M/yy, hh:mm a"
        formatter.dateStyle = .full
        cell.detailTextLabel?.text = formatter.string(from: time)
        cell.detailTextLabel?.textColor = UIColor.systemGray
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            pages.remove(at: indexPath.row)
            table.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell=indexPath.row
        performSegue(withIdentifier: "openPage", sender: self)
        table.deselectRow(at: indexPath, animated: true)
    }
    
}
extension PageListViewController{
    var cellHeight: CGFloat{
        return 75
    }
    var cellColour: UIColor{
        return #colorLiteral(red: 0.9411764706, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
    }
    var backgroundColour: UIColor{
        return #colorLiteral(red: 0.9411764706, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
    }
}
