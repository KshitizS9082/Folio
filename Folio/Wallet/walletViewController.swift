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
        
    }
    
    @IBOutlet weak var backgroundImageView: UIImageView!{
        didSet{
            backgroundImageView.addBlurEffect()
        }
    }
    
//    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var balanceView: UIView!{
        didSet{
            balanceView.layer.cornerRadius=10
            //Draw shaddow for layer
//            balanceView.layer.shadowColor = UIColor.gray.cgColor
//            balanceView.layer.shadowOffset = CGSize(width: 0.0, height: 15.0)
//            balanceView.layer.shadowRadius = 15.0
//            balanceView.layer.shadowOpacity = 0.8
            balanceView.layer.masksToBounds=true
            
            let blurContView = UIView()
            blurContView.frame = balanceView.bounds
            balanceView.addSubview(blurContView)
            balanceView.sendSubviewToBack(blurContView)
            blurContView.layer.cornerRadius = 10
            blurContView.layer.masksToBounds=true
            
//            balanceView.layer.cornerRadius = 10
            
            balanceView.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemChromeMaterial)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = blurContView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            blurContView.addSubview(blurEffectView)
            blurContView.sendSubviewToBack(blurEffectView)
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
//            table.layer.masksToBounds=false
        }
    }
    @IBOutlet weak var dateSelectedImageView: UIImageView!{
        didSet{
            dateSelectedImageView.layer.cornerRadius = 7
            dateSelectedImageView.isUserInteractionEnabled=true
            dateSelectedImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDateSelctor)))
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
    @objc func showDateSelctor(){
        print("show date")
        let myDatePicker: UIDatePicker = UIDatePicker()
        // setting properties of the datePicker
        myDatePicker.timeZone = NSTimeZone.local
        myDatePicker.datePickerMode = .date
//        myDatePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
        
        let alertController = UIAlertController(title: "Scroll To Date\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet)

        let somethingAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            print("scroll to date \(myDatePicker.date)")
            var ind=0;
            while(ind+1<self.walletEntryArray.count && self.walletEntryArray[ind+1].0<=myDatePicker.date.startOfDay){
                ind+=1
            }
            DispatchQueue.main.async {
                self.table.scrollToRow(at: IndexPath(row: 0, section: ind), at: .top, animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        
        alertController.view.addSubview(myDatePicker)
        myDatePicker.translatesAutoresizingMaskIntoConstraints=false
        [
            myDatePicker.topAnchor.constraint(equalTo: alertController.view.safeAreaLayoutGuide.topAnchor, constant: 25),
            myDatePicker.heightAnchor.constraint(equalToConstant: 170),
            //            myDatePicker.bottomAnchor.constraint(equalTo: alertController.view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            myDatePicker.centerXAnchor.constraint(equalTo: alertController.view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            myDatePicker.widthAnchor.constraint(equalTo: alertController.view.safeAreaLayoutGuide.widthAnchor, constant: -20)
            ].forEach { (cst) in
                cst.isActive=true
        }
        self.present(alertController, animated: true, completion:{})
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
        //setting darkmode/lightmode/automode
        let interfaceStyle = UserDefaults.standard.integer(forKey: "prefs_is_dark_mode_on")
        if interfaceStyle==0{
            overrideUserInterfaceStyle = .unspecified
        }else if interfaceStyle==1{
            overrideUserInterfaceStyle = .light
        }else if interfaceStyle==2{
            overrideUserInterfaceStyle = .dark
        }
//        self.navigationController?.hidesBarsOnSwipe=true
        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 30)!
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
//                    print("did set self.habits to \(extract)")
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
//        self.navigationController?.hidesBarsOnSwipe=false
        // Restore the navigation bar to default
//        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
//        navigationController?.navigationBar.shadowImage = nil
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
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
        //TODO: Can be improved instead of recalculation whole just add the new one
//        self.setupData()
        
        table.reloadData()
        calculateCurrentBalance()
    }
    func modifyWalletEntry(to newEntry: walletEntry){
//        print("Updated to: val \(newEntry.value) of type \(newEntry.type)")
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
    func deleteWalletEntry(to newEntry: walletEntry){
        //        print("Updated to: val \(newEntry.value) of type \(newEntry.type)")
        for key in self.walletData.entries.keys{
            var arr = self.walletData.entries[key]!
            var shouldBreak=false
            for ind in arr.indices{
                let val = arr[ind]
                if val.uniqueID == newEntry.uniqueID{
                    //TODO: save changes made
                    arr.remove(at: ind)
                    if arr.count>0{
                        self.walletData.entries[key]=arr
                    }else{
                        self.walletData.entries.removeValue(forKey: key)
                    }
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
                        return
                    }
                }
            }
        }
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
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor.clear
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemThickMaterial)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        let hvbounds = headerView.bounds
//        blurEffectView.frame = CGRect(x: hvbounds.minX+5, y: hvbounds.minY+5, width: hvbounds.width-10, height: hvbounds.height-10)
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.layer.cornerRadius=10
//        blurEffectView.layer.masksToBounds=true
//        headerView.addSubview(blurEffectView)
        
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 10, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        let date =  self.walletEntryArray[section].0
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        if Calendar.current.isDateInToday(date){
            label.text="Today"
        }else if Calendar.current.isDateInYesterday(date){
            label.text="Yesterday"
        }else{
            label.text = formatter.string(from: date)
        }
        headerView.addSubview(label)
        
        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints=false
        if headerView.subviews.contains(valueLabel)==false{
            headerView.addSubview(valueLabel)
        }
        [
            valueLabel.rightAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.rightAnchor, constant: -25),
//            valueLabel.centerYAnchor.constraint(equalTo: label.centerYAnchor)
            valueLabel.bottomAnchor.constraint(equalTo: label.bottomAnchor)
            ].forEach { (cst) in
                cst.isActive=true
        }
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol!
        var sum=Float(0.0)
        for entry in self.walletEntryArray[section].1{
            sum += entry.value
        }
        valueLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete",
                                        handler: { (action, view, completionHandler) in
                                            self.deleteWalletEntry(to: self.walletEntryArray[indexPath.section].1[indexPath.row])
                                            self.table.beginUpdates()
                                            self.table.deleteRows(at: [indexPath], with: .automatic)
                                            self.table.endUpdates()
                                            completionHandler(true)
        })
        action.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    //for rounded corner grouped sections
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//            let cornerRadius : CGFloat = 15.0
//            cell.backgroundColor = UIColor.clear
//            let layer: CAShapeLayer = CAShapeLayer()
//            let pathRef:CGMutablePath = CGMutablePath()
//            let bounds: CGRect = cell.bounds.insetBy(dx:0,dy:0)
//            var addLine: Bool = false
//
//            if (indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
//                pathRef.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
//                // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius)
//            } else if (indexPath.row == 0) {
//
//                pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
//                pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.midY), radius: cornerRadius)
//                pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
//                pathRef.addLine(to:CGPoint(x: bounds.maxX, y: bounds.maxY) )
//
//                addLine = true
//            } else if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
//
//
//                pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY), transform: CGAffineTransform())
//                //                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
//                pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
//                pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
//                pathRef.addLine(to:CGPoint(x: bounds.maxX, y: bounds.minY) )
//
//
//            } else {
//                pathRef.addRect(bounds)
//
//                addLine = true
//            }
//
//            layer.path = pathRef
//            layer.fillColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.8).cgColor
//
//            if (addLine == true) {
//                let lineLayer: CALayer = CALayer()
//                let lineHeight: CGFloat = (1.0 / UIScreen.main.scale)
//                lineLayer.frame = CGRect(x:bounds.minX + 10 , y:bounds.size.height-lineHeight, width:bounds.size.width-10, height:lineHeight)
//                lineLayer.backgroundColor = tableView.separatorColor?.cgColor
//                layer.addSublayer(lineLayer)
//            }
//            let testView: UIView = UIView(frame: bounds)
//            testView.layer.insertSublayer(layer, at: 0)
//            testView.backgroundColor = UIColor.clear
//            cell.backgroundView = testView
//
//        }
}
