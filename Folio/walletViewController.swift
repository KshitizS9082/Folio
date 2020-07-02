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
}
class walletViewController: UIViewController {
    var walletData = WalletData()
    override func viewDidLoad() {
        super.viewDidLoad()

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
        print("entries = \(self.walletData.entries)")
        table.reloadData()
    }
}

extension walletViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.walletData.entries.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.walletData.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .systemRed
        return cell
    }
}
