//
//  walletViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/07/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

struct WalletData: Codable{
    var initialBalance: Float = 0.0
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
    var uniqueID = UUID()
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
    func modifyWalletEntry(to newEntry: walletEntry)
}
class walletViewController: UIViewController {
    var walletData = WalletData()
    override func viewDidLoad() {
        super.viewDidLoad()
//        calculateCurrentBalance()
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        blurView.layer.masksToBounds=true
        self.blurView.addSubview(blurEffectView)
    }
    
    @IBOutlet weak var blurView: UIView!
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
            table.layer.masksToBounds=false
        }
    }
    
    var walletEntryArray = [(Date, [walletEntry])]()
    func setupData(){
//        walletEntryArray = (self.walletData.entries).sorted(by: { $0.0 < $1.0 })
        walletEntryArray = Array(self.walletData.entries)
        walletEntryArray.sort { (first, second) -> Bool in
            return first.0<second.0
        }
        for ind in self.walletEntryArray.indices{
            self.walletEntryArray[ind].1.sort { (first, second) -> Bool in
                return first.date<second.date
            }
        }
        print("did setup data: ")
        for elem in walletEntryArray{
            print("da: \(elem.0)")
        }
    }
    
    func calculateCurrentBalance(){
        var count=walletData.initialBalance
        for entryListPair in Array(walletData.entries){
            let entryList = entryListPair.value
            for entry in entryList{
                count+=entry.value
            }
        }
        self.balanceLabel.text = String(count)
    }
    func addEntry(){
        print("add entry")
        selectedCell=nil
        self.performSegue(withIdentifier: "showAddWalletEntrySegue", sender: self)
    }
    
    func save(){
        if let json = walletData.json {
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("walletData.json"){
                do {
                    try json.write(to: url)
                    print ("saved successfully")
                } catch let error {
                    print ("couldn't save \(error)")
                }
            }
        }
    }
    
    var selectedCell: IndexPath?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? addWalletEntryViewController{
            if selectedCell==nil{// wanting to add a new entry
                vc.delegate=self
                vc.isNewEntry=true
            }else{
                let entry = self.walletEntryArray[selectedCell!.section].1[selectedCell!.row]
                vc.delegate=self
                vc.isNewEntry=false
                vc.entry = entry
            }
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
        
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("walletData.json"){
            if let jsonData = try? Data(contentsOf: url){
                if let extract = WalletData(json: jsonData){
                    print("did set self.habits to \(extract)")
                    self.walletData = extract
                    self.calculateCurrentBalance()
                    self.setupData()
                }else{
                    print("ERROR: found WalletData(json: jsonData) to be nil so didn't set it")
                }
            }else{
                print("error no file named walletData.json found")
            }
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        save()
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
        
        var isThere = false
        for ind in self.walletEntryArray.indices{
            let arrTupple = self.walletEntryArray[ind]
            if arrTupple.0 == entry.date.startOfDay{
                isThere=true
                print("IS THERE")
                self.walletEntryArray[ind].1.append(entry)
                self.walletEntryArray[ind].1.sort { (first, second) -> Bool in
                    return first.date<second.date
                }
            }
        }
        var newEntryArray = [walletEntry]()
        newEntryArray.append(entry)
        if !isThere{
            self.walletEntryArray.append((entry.date.startOfDay, newEntryArray))
        }
        self.walletEntryArray.sort { (first, secon) -> Bool in
            return first.0<secon.0
        }
        print("entries = \(self.walletData.entries)")
        print("entries keycnt= \(self.walletData.entries.keys.count)")
        for elem in self.walletEntryArray{
            print("fsdaf = \(elem)")
        }
        //TODO: Can be improved instead of recalculation whole just add the new one
//        self.setupData()
        
        table.reloadData()
        calculateCurrentBalance()
    }
    func modifyWalletEntry(to newEntry: walletEntry){
        for key in self.walletData.entries.keys{
            var arr = self.walletData.entries[key]!
            var shouldBreak=false
            for ind in arr.indices{
                let val = arr[ind]
                if val.uniqueID == newEntry.uniqueID{
                    //TODO: save changes made
                    arr.remove(at: ind)
                    self.walletData.entries[key]=arr
                    shouldBreak=true
                    break
                }
            }
            if shouldBreak{
                break
            }
        }
        for ind in self.walletEntryArray.indices{
            if self.walletEntryArray[ind].0==newEntry.date.startOfDay{
                for indx in self.walletEntryArray[ind].1.indices{
                    if self.walletEntryArray[ind].1[indx].uniqueID == newEntry.uniqueID{
                        self.walletEntryArray[ind].1.remove(at: indx)
                        self.addWallwtEntry(newEntry)
                        return
                    }
                }
            }
        }
        //TODO: check if needed
        self.addWallwtEntry(newEntry)
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
//        return self.walletData.entries.count
        return self.walletEntryArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.walletData.entries.count
//        let arr = Array(self.walletData.entries)[section].value
//        return arr.count
        return self.walletEntryArray[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.backgroundColor = .systemRed
//        return cell
        print("cellforrowat data: ")
        for elem in walletEntryArray{
            print("da: \(elem.0)")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "myWalletCell") as! walletEntryTableViewCell
//        let entry = Array(self.walletData.entries)[indexPath.section].value[indexPath.row]
        let entry = self.walletEntryArray[indexPath.section].1[indexPath.row]
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
        let date =  self.walletEntryArray[section].0
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
        for entry in self.walletEntryArray[section].1{
            sum += entry.value
        }
        valueLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        if sum<0{
            let valueString = "-"+currencySymbol+String(-sum)
            let amountText = NSMutableAttributedString.init(string: valueString)
            amountText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                                      NSAttributedString.Key.foregroundColor: UIColor.systemGray2],
                                     range: NSMakeRange(1, 1))
            valueLabel.attributedText = amountText
        }else{
            let valueString = currencySymbol+String(sum)
            let amountText = NSMutableAttributedString.init(string: valueString)
            amountText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                                      NSAttributedString.Key.foregroundColor: UIColor.systemGray2],
                                     range: NSMakeRange(0, 1))
            valueLabel.attributedText = amountText
        }
        //        headerView.backgroundColor = .systemTeal
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewHeaderHeight
    }
    var tableViewHeaderHeight: CGFloat{
        return 50.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell=indexPath
        self.performSegue(withIdentifier: "showAddWalletEntrySegue", sender: self)
    }
}
