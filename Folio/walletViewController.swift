//
//  walletViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/07/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

struct WalletData: Codable{
    var initialBalance = 0.0
//    var entryList = [walletEntry]()
    var entries = [Date: [walletEntry] ]()
    init(){
    }
    init?(json: Data){
        if let newValue = try? JSONDecoder().decode(WalletData.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}
struct walletEntry: Codable{
    var value: Float = 0.0
    var type = tansferType.expense
    var category = spendingCategory.others
    var date = Date()
    var note = ""
    var payee = ""
    var paymentType = ""
    var imageURL: String?
//    var location
    
    enum tansferType: String, Codable{
        case expense
        case income
    }
    //TODO: update spendingCategory enum
    enum spendingCategory: String, Codable{
        case foodDrinks
        case shopping
        case housing
        case transport
        case vehilcle
        case entertainment
        case commuinicationPC
        case loanInterest
        case taxes
        case financial
        case income
        case others
    }
}
protocol walletProtocol {
    func addWallwtEntry(_ entry: walletEntry)
    func updated(indexpath: IndexPath, animated: Bool)
}
class walletViewController: UIViewController {
    var walletData = WalletData()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.table.sectionHeaderHeight = tableViewHeaderHeight
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var balanceView: UIView!{
        didSet{
            balanceView.layer.cornerRadius=15
            //Draw shaddow for layer
            balanceView.layer.shadowColor = UIColor.gray.cgColor
            balanceView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            balanceView.layer.shadowRadius = 5.0
            balanceView.layer.shadowOpacity = 0.2
        }
    }
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!{
        didSet{
            let locale = Locale.current
//            let currencySymbol = locale.currencySymbol!
            let currencyCode = locale.currencyCode!
            currencyLabel.text = currencyCode
        }
    }
    
    @IBOutlet weak var table: UITableView!{
        didSet{
            table.dataSource=self
            table.delegate=self
        }
    }
    
    func addEntry(){
        print("add entry")
        self.performSegue(withIdentifier: "showAddWalletEntrySegue", sender: self)
    }
    
    func setupData(){
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? addWalletEntryViewController{
            vc.delegate=self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue ,
            NSAttributedString.Key.font: UIFont(name: "SnellRoundhand-Black", size: 30)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
}
extension walletViewController: walletProtocol{
    func addWallwtEntry(_ entry: walletEntry) {
        if var dic = self.walletData.entries[entry.date.startOfDay]{
            dic.append(entry)
            self.walletData.entries[entry.date.startOfDay]=dic
        }else{
            var dic = [walletEntry]()
            dic.append(entry)
            self.walletData.entries[entry.date.startOfDay]=dic
        }
//        //TODO: remove as used for testing/ debuggin
//        for _ in 0..<8{
//            let x = Calendar.current.date(byAdding: .day, value:  -(Int(arc4random_uniform(15)) + 1), to: entry.date)!.startOfDay
//            var testEntry = entry
//            testEntry.date=x
//            if var dic = self.walletData.entries[testEntry.date.startOfDay]{
//                dic.append(testEntry)
//                self.walletData.entries[testEntry.date.startOfDay]=dic
//            }else{
//                var dic = [walletEntry]()
//                dic.append(testEntry)
//                self.walletData.entries[testEntry.date.startOfDay]=dic
//            }
//        }
        
        print("entries = \(self.walletData.entries)")
        table.reloadData()
    }
    func updated(indexpath: IndexPath, animated: Bool) {
        print("updated at indexpath: \(indexpath)")
        // Disabling animations gives us our desired behaviour
        UIView.setAnimationsEnabled(animated)
        /* These will causes table cell heights to be recaluclated,
         without reloading the entire cell */
        table.beginUpdates()
        table.endUpdates()
        // Re-enable animations
        UIView.setAnimationsEnabled(true)
        
        table.scrollToRow(at: indexpath, at: .bottom, animated: false)
        
    }
}

extension walletViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.walletData.entries.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.walletData.entries.count
        let arr = Array(self.walletData.entries)[section].value
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.backgroundColor = .systemRed
//        return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "myWalletCell") as! walletEntryTableViewCell
        let entry = Array(self.walletData.entries)[indexPath.section].value[indexPath.row]
//        cell.textLabel?.text = entry.category.rawValue
//        cell.detailTextLabel?.text = String(entry.value)
        cell.wEntry=entry
        cell.awakeFromNib()
        return cell
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let date =  Array(self.walletData.entries)[section].key
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter.string(from: date)
//    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = walletTableViewSectionHeaderView(frame: CGRect(x: 0, y: 0, width: table.frame.size.width, height: 60))
//        view.backgroundColor = .systemTeal
//        let date =  Array(self.walletData.entries)[section].key
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        view.label.text = formatter.string(from: date)
//        var sum=Float(0.0)
//        for entry in Array(self.walletData.entries)[section].value{
//            sum += entry.value
//        }
//        view.valueLabel.text=String(sum)
        //        return view
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))

        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 6, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.font = UIFont.boldSystemFont(ofSize: 23.0)
        let date =  Array(self.walletData.entries)[section].key
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        label.text = formatter.string(from: date)
        headerView.addSubview(label)
        
        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints=false
        if headerView.subviews.contains(valueLabel)==false{
            headerView.addSubview(valueLabel)
        }
        [
            valueLabel.rightAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.rightAnchor, constant: -25),
            valueLabel.topAnchor.constraint(equalTo:headerView.safeAreaLayoutGuide.topAnchor, constant: 15),
            valueLabel.bottomAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.bottomAnchor, constant: -15)
            //            ,label.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 25)
            ].forEach { (cst) in
                cst.isActive=true
        }
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol!
        var sum=Float(0.0)
        for entry in Array(self.walletData.entries)[section].value{
            sum += entry.value
        }
        valueLabel.text = currencySymbol + String(sum)
        valueLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
//        headerView.backgroundColor = .systemTeal
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewHeaderHeight
    }
    var tableViewHeaderHeight: CGFloat{
        return 50.0
    }
}
