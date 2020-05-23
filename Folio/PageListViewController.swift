//
//  PageListViewController.swift
//  card2
//
//  Created by Kshitiz Sharma on 27/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
struct pageInfo: Codable{
    var title = "Title"
    var fileName = String.uniqueFilename(withPrefix: "Page")+".json"
    var dateOfMaking =  Date()
    init(){
    }
    init?(json: Data){
        if let newValue = try? JSONDecoder().decode(pageInfo.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    init(title: String){
        self.title = title
    }
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}
struct pageInfoList: Codable {
    var items = [pageInfo]()
    init(){
    }
    init?(json: Data){
        if let newValue = try? JSONDecoder().decode(pageInfoList.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}
protocol pageListeProtocol {
    func setPageTitle(for indexPath: IndexPath, to title: String)
}

class PageListViewController: UIViewController {
//    var pages = [PageData]()
//    var pageList = [pageInfo]()
    var pages = pageInfoList()
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
//        table.register(UINib(nibName: "pageListTableViewCell", bundle: nil), forCellReuseIdentifier: "customPageCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("PageList.json"){
            print("trying to extract contents of jsonData")
            if let jsonData = try? Data(contentsOf: url){
//                pageList = pageInfo(json: jsonData)
                if let x = pageInfoList(json: jsonData){
                    pages = x
                }else{
                    print("WARNING: COULDN'T UNWRAP JSON DATA TO FIND PAGELIST")
                }
            }
            viewDidLoad()
        }
    }
    func save() {
        print("attempting to save pages")
        if let json = pages.json {
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("PageList.json"){
                do {
                    try json.write(to: url)
                    print ("saved successfully")
                } catch let error {
                    print ("couldn't save \(error)")
                }
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        save()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:  UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(addPage))
        configureHeading()
        configureTable()
        // Do any additional setup after loading the view.
    }
    
    @objc func addPage(){
//        pages.append(PageData())
        pages.items.append(pageInfo())
        table.reloadData()
    }
    
    // MARK: - Navigation
    var selectedCell: Int?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openPage"{
            if let targetController = segue.destination as? SwitchPageTimelineViewController{
//                targetController.page = pages[selectedCell!]
                targetController.index = selectedCell!
                targetController.pageID = pages.items[selectedCell!]
                targetController.myViewController=self
                print("passing pageTitle: \(pages.items[selectedCell!].title)")
            }
        }
    }
    
}
extension PageListViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.items.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == pages.items.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PageExtractTVCell", for: indexPath) as! PagesExtractTableViewCell
            cell.backgroundColor = UIColor.clear
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "customPageCell", for: indexPath) as! pageListTableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.myIndexPath=indexPath
        cell.pageListDelegate=self
        cell.titleTextField.text = pages.items[indexPath.row].title
        cell.backgroundColor = cellColour
        let time =  pages.items[indexPath.row].dateOfMaking
        let formatter = DateFormatter()
        //        formatter.dateFormat = "d/M/yy, hh:mm a"
        formatter.dateStyle = .full
        cell.subtitleText?.text = formatter.string(from: time)
        cell.subtitleText?.textColor = UIColor.systemGray
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row==pages.items.count{
            return 300
        }
        return cellHeight
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            pages.items.remove(at: indexPath.row)
            table.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete",
                                        handler: { (action, view, completionHandler) in
                        self.pages.items.remove(at: indexPath.row)
                        self.table.reloadData()
                        completionHandler(true)
        })
        action.backgroundColor = .systemRed
        let editAction = UIContextualAction(style: .normal, title: "Edit",
                                            handler: { (action, view, completionHandler) in
                                                self.startEdittingCell(at: indexPath)
                                                completionHandler(true)
        })
        
        let configuration = UISwipeActionsConfiguration(actions: [action, editAction])
        return configuration
    }
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell=indexPath.row
        performSegue(withIdentifier: "openPage", sender: self)
        table.deselectRow(at: indexPath, animated: true)
    }
    func startEdittingCell(at indexPath: IndexPath){
        //needs to add a delay becuase of a bug that cell dissapears if not becomefirstresponder
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            if let cell = self.table.cellForRow(at: indexPath) as? pageListTableViewCell{
                cell.titleTextField.becomeFirstResponder()
            }
        }
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

extension PageListViewController: pageListeProtocol{
    func setPageTitle(for indexPath: IndexPath, to title: String) {
        pages.items[indexPath.row].title = title
    }
    
    
}
