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
    func performSegueForExtractView(for extractViewIndex: Int)
}

class PageListViewController: UIViewController {
//    var pages = [PageData]()
//    var pageList = [pageInfo]()
    var pages = pageInfoList()
    var addPageButton = UIImageView(image: UIImage(systemName: "plus.circle"))
//    let journalButton = UIImageView(image: UIImage(systemName: "square.split.2x1.fill"))
    let journalButton = UIImageView(image: UIImage(systemName: "book.circle"))
    var titleLabel = UILabel()
    
    @IBOutlet weak var table: UITableView!
    private func configureHeading(){
//        if view.subviews.contains(addPageButton)==false{
//            view.addSubview(addPageButton)
//        }
//        addPageButton.translatesAutoresizingMaskIntoConstraints=false
//        [
//            addPageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
//            addPageButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
//            addPageButton.widthAnchor.constraint(equalToConstant: topButtonsDimenstions),
//            addPageButton.heightAnchor.constraint(equalToConstant: topButtonsDimenstions)
//            ].forEach { (cst) in
//                cst.isActive=true
//        }
//        addPageButton.isUserInteractionEnabled=true
//        addPageButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPage)))
//
//        if view.subviews.contains(journalButton)==false{
//            view.addSubview(journalButton)
//        }
//        journalButton.translatesAutoresizingMaskIntoConstraints=false
//        [
//            journalButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
//            journalButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
//            journalButton.widthAnchor.constraint(equalToConstant: topButtonsDimenstions),
//            journalButton.heightAnchor.constraint(equalToConstant: topButtonsDimenstions)
//            ].forEach { (cst) in
//                cst.isActive=true
//        }
//        journalButton.isUserInteractionEnabled=true
//        journalButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showJournal)))
//
//        if view.subviews.contains(titleLabel)==false{
//            view.addSubview(titleLabel)
//        }
//        titleLabel.translatesAutoresizingMaskIntoConstraints=false
//        [
//            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
//            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: addPageButton.leftAnchor)//,
//            //            titleLabel.heightAnchor.constraint(equalToConstant: 45)
//            ].forEach { (cst) in
//                cst.isActive=true
//        }
//        titleLabel.text = "Folio's"//or chronicle
//        titleLabel.font = UIFont(name: "SnellRoundhand-Black", size: 40)
    }
    
    @IBAction func addPageNavBarButtonClick(_ sender: Any) {
        addPage()
    }
    @IBAction func showJournalNavButtonClick(_ sender: Any) {
        showJournal()
    }
    
    
    private func configureTable(){
        table.translatesAutoresizingMaskIntoConstraints=false
        [
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
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
        //        self.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.systemGray,
            NSAttributedString.Key.font: UIFont(name: "SnellRoundhand-Black", size: 30)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        
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
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = UIColor.systemBlue
        save()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:  UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(addPage))
        configureHeading()
        configureTable()
        // Do any additional setup after loading the view.
    }
    
    @objc func addPage(){
//        pages.append(PageData())
        pages.items.append(pageInfo())
        table.reloadData()
    }
    @objc func showJournal(){
        performSegue(withIdentifier: "showJournalSegue", sender: self)
    }
    
    // MARK: - Navigation
    var selectedCell: Int?
    var selectedExtractView: Int?
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
        if segue.identifier == "pageExtractSegue"{
            if let targetController = segue.destination as? PageExtractViewController{
                targetController.pagesListFromPLVC=self.pages
                targetController.selectedExtractView = self.selectedExtractView!
            }
        }
        if segue.identifier == "showJournalSegue"{
            print("now set journalvc")
//            if let targetController = segue.destination as? JournalViewController{
//                targetController.pagesListFromPLVC=self.pages
//            }
        }
    }
    
}
extension PageListViewController{
    var topButtonsDimenstions: CGFloat{
        return 35
    }
}
extension PageListViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if section == 0 {
            rowCount = 1
        }
        if section == 1 {
            rowCount = pages.items.count
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section==0{
            return self.setupExtractTableViewCell(tableView, cellForRowAt: indexPath)
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
        cell.subtitleText?.textColor =  UIColor(named: "subMainTextColor") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return cell
    }
    
    func setupExtractTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PageExtractTVCell", for: indexPath) as! PagesExtractTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.delegate=self
        var fileName=""
        var count = [Int](repeating: 0, count: 4)
        for info in pages.items{
            fileName=info.fileName
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(fileName){
                if let jsonData = try? Data(contentsOf: url){
                    if let page = PageData(json: jsonData){
                        let calendar = Calendar.current
                        page.bigCards.forEach { (card) in
                            count[2]+=1
                            if let date = card.card.reminder{
                                count[1]+=1
                                if calendar.isDateInToday(date){
                                    count[0]+=1
                                }
                                if date<Date(){
                                    count[2]+=1
                                }
                            }
                        }
                        page.smallCards.forEach { (card) in
                            count[2]+=1
                            if let date = card.card.reminderDate{
                                count[1]+=1
                                if calendar.isDateInToday(date){
                                    count[0]+=1
                                }
                                if date<Date(){
                                    count[2]+=1
                                }
                            }
                        }
                        page.mediaCards.forEach { (card) in
                            count[2]+=1
                        }
                    }else{
                        print("WARNING: DROPPED A PAGE INSIDE PAGEEXTRACTVC")
                    }
                }
            }
        }
        for ind in cell.extractCardList.indices{
            cell.extractCardList[ind].numberLabel.text = String(count[ind])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section==0{
            return 270
        }
        return cellHeight
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func deletePage(for pageInformation: pageInfo){
        print("inside delete page")
        let fileName = pageInformation.fileName
        let fileManager = FileManager.default
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent(fileName){
            if let jsonData = try? Data(contentsOf: url){
                let pageDat = PageData(json: jsonData)
                if let medCards = pageDat?.mediaCards{
                    medCards.forEach { (medCardDat) in
                        for imgName in medCardDat.card.mediaDataURLs{
                            if let imgURL = try? FileManager.default.url(
                                for: .documentDirectory,
                                in: .userDomainMask,
                                appropriateFor: nil,
                                create: true
                            ).appendingPathComponent(imgName){
                                do{
                                    try fileManager.removeItem(at: imgURL)
                                    print("deleted item \(imgURL) succefully")
                                } catch{
                                    print("ERROR: item  at \(imgURL) couldn't be deleted")
                                    return
                                }
                            }
                        }
                    }
                }
            }
            do{
                try fileManager.removeItem(at: url)
                print("deleted pageInformation \(url) succefully")
            } catch{
                print("ERROR: pageInformation item  at \(url) couldn't be deleted")
            }
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete",
                                        handler: { (action, view, completionHandler) in
                                            self.deletePage(for: self.pages.items[indexPath.row])
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell=indexPath.row
        if indexPath.section==0{
            print("selected cell at section 0")
            let cell=table.cellForRow(at: indexPath) as! PagesExtractTableViewCell
            self.selectedExtractView=cell.selectedView
        }else{
            performSegue(withIdentifier: "openPage", sender: self)
        }
        table.deselectRow(at: indexPath, animated: true)
    }
    func startEdittingCell(at indexPath: IndexPath){
        //needs to add a delay becuase of a bug that cell dissapears if not becomefirstresponder
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            if let cell = self.table.cellForRow(at: indexPath) as? pageListTableViewCell{
                cell.titleTextField.becomeFirstResponder()
            }
        }
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section==0{
//            let empytView = UIView()
//            empytView.backgroundColor = .gray
//            return empytView
//        }
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        let headerLabel = UILabel()
//        headerView.addSubview(headerLabel)
//        headerLabel.translatesAutoresizingMaskIntoConstraints=false
//        [
//            headerLabel.leftAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.leftAnchor, constant: 10),
//            headerLabel.centerYAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.centerYAnchor, constant: 0)
//            ].forEach { (cst) in
//                cst.isActive=true
//        }
//        headerLabel.font = UIFont.boldSystemFont(ofSize: 30)
//        headerLabel.textColor = UIColor.systemGray
//        headerLabel.text = "My Pages"
//        headerLabel.sizeToFit()
//        headerView.addSubview(headerLabel)
//        return headerView
//    }
}
extension PageListViewController{
    var cellHeight: CGFloat{
        return 75
    }
    var cellColour: UIColor{
        return UIColor(named: "myBackgroundColor") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//        return #colorLiteral(red: 0.9411764706, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
    }
    var backgroundColour: UIColor{
        return UIColor(named: "myBackgroundColor") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//        return #colorLiteral(red: 0.9411764706, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
    }
}

extension PageListViewController: pageListeProtocol{
    func performSegueForExtractView(for extractViewIndex: Int) {
        self.selectedExtractView=extractViewIndex
        performSegue(withIdentifier: "pageExtractSegue", sender: self)
    }
    
    func setPageTitle(for indexPath: IndexPath, to title: String) {
        pages.items[indexPath.row].title = title
    }
    
    
}
