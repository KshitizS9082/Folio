//
//  addWalletEntryViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/07/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
protocol addWalletEntryVCProtocol {
    func addType(type: walletEntry.tansferType)
    func addCategory(categ: walletEntry.spendingCategory)
    func addDateOfAddition(date: Date)
    func addNote(note: String)
    func addPayee(payeeName: String)
    func addPaymentType(paymentType: String)
    func addImageURL(imageURL: String)
}

class addWalletEntryViewController: UIViewController {
    var delegate: walletProtocol?
    var entry = walletEntry()
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!{
        didSet{
            let locale = Locale.current
            //            let currencySymbol = locale.currencySymbol!
            let currencyCode = locale.currencyCode!
            currencyLabel.text = currencyCode
        }
    }
    
    
    @IBOutlet weak var incomeExpenseSegmentControl: UISegmentedControl!
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex==0{
            entry.type = .expense
        }else{
            entry.type = .income
        }
    }
    
    @IBOutlet weak var table: UITableView!{
        didSet{
            table.dataSource=self
            table.delegate=self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func handleCancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func handleDoneTap(_ sender: Any) {
        delegate?.addWallwtEntry(entry)
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var navBar: UINavigationBar!{
        didSet{
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
        }
    }
    

}
extension addWalletEntryViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = table.dequeueReusableCell(withIdentifier: "spendingCatCellId") as! spendingCategoryCell
            cell.delegate=self
            return cell
        case 1:
            let cell = table.dequeueReusableCell(withIdentifier: "addDateCellId") as! addWallEntrDateCell
            cell.delegate=self
            return cell
        case 2:
            return UITableViewCell()
        case 3:
            return UITableViewCell()
        case 4:
            return UITableViewCell()
        case 5:
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    
}
extension addWalletEntryViewController: addWalletEntryVCProtocol {
    func addType(type: walletEntry.tansferType) {
        self.entry.type = type
    }
    
    func addCategory(categ: walletEntry.spendingCategory) {
        self.entry.category = categ
        switch categ {
        case .foodDrinks:
            self.categoryImageView.image = UIImage(systemName: "questionmark")
//            self.descriptionLabel.text="Food-Drinks"
        case .shopping:
            self.categoryImageView.image = UIImage(systemName: "cart.fill")
//            self.descriptionLabel.text="Shopping"
        case .housing:
            self.categoryImageView.image = UIImage(systemName: "house.fill")
//            self.descriptionLabel.text="Housing"
        case .transport:
            self.categoryImageView.image = UIImage(systemName: "tram.fill")
//            self.descriptionLabel.text="Transport"
        case .vehilcle:
            self.categoryImageView.image = UIImage(systemName: "car.fill")
//            self.descriptionLabel.text="Vehicle"
        case .entertainment:
            self.categoryImageView.image = UIImage(systemName: "film")
//            self.descriptionLabel.text="Entertainment"
        case .commuinicationPC:
            self.categoryImageView.image = UIImage(systemName: "desktopcomputer")
//            self.descriptionLabel.text="Computer"
        case .loanInterest:
            self.categoryImageView.image = UIImage(systemName: "dollarsign.circle")
//            self.descriptionLabel.text="Loan"
        case .taxes:
            self.categoryImageView.image = UIImage(systemName: "dollarsign.circle")
//            self.descriptionLabel.text="Taxes"
        case .financial:
            self.categoryImageView.image = UIImage(systemName: "dollarsign.circle")
//            self.descriptionLabel.text="Financial"
        case .income:
            self.categoryImageView.image = UIImage(systemName: "dollarsign.circle")
//            self.descriptionLabel.text="Income"
        case .others:
            self.categoryImageView.image = UIImage(systemName: "tag")
//            self.descriptionLabel.text="Others"
        }
    }
    
    func addDateOfAddition(date: Date) {
        self.entry.date = date
    }
    
    func addNote(note: String) {
        self.entry.note = note
    }
    
    func addPayee(payeeName: String) {
        self.entry.payee = payeeName
    }
    
    func addPaymentType(paymentType: String) {
        self.entry.paymentType = paymentType
    }
    
    func addImageURL(imageURL: String) {
        self.entry.imageURL = imageURL
    }
    
    
}
protocol spendingCategoryCellProtocol{
    func selectedMe(index: Int)
}
class spendingCategoryCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate{
    var delegate: addWalletEntryVCProtocol?
    @IBOutlet weak var spendingColView: UICollectionView!{
        didSet{
            spendingColView.dataSource=self
            spendingColView.delegate=self
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            self.spendingColView.collectionViewLayout = layout
            self.spendingColView!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:0, right: 0)
            self.spendingColView.isPagingEnabled=true
            if let layout = self.spendingColView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumInteritemSpacing = spacings
                layout.minimumLineSpacing = spacings
                layout.itemSize = CGSize(width: (contentView.frame.width-5*spacings)/4, height: (spendingColView.frame.height-3*spacings)/2)
                layout.invalidateLayout()
            }
            spendingColView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spendingCell", for: indexPath) as! spendingCategCollectionViewCell
        cell.myIndex=indexPath.row
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            delegate?.addCategory(categ: .foodDrinks)
        case 1:
            delegate?.addCategory(categ: .shopping)
        case 2:
            delegate?.addCategory(categ: .housing)
        case 3:
            delegate?.addCategory(categ: .transport)
        case 4:
            delegate?.addCategory(categ: .vehilcle)
        case 5:
            delegate?.addCategory(categ: .entertainment)
        case 6:
            delegate?.addCategory(categ: .commuinicationPC)
        case 7:
            delegate?.addCategory(categ: .loanInterest)
        case 8:
            delegate?.addCategory(categ: .taxes)
        case 9:
            delegate?.addCategory(categ: .financial)
        case 10:
            delegate?.addCategory(categ: .income)
        case 11:
            delegate?.addCategory(categ: .others)
        default:
            print("unknown index")
        }
    }
    var spacings: CGFloat{
        return 15.0
    }
}
class spendingCategCollectionViewCell: UICollectionViewCell{
    var delegate: spendingCategoryCellProtocol?
    var myIndex=0{
        didSet{
            switch self.myIndex {
            case 0:
                self.image.image = UIImage(systemName: "questionmark")
                self.descriptionLabel.text="Food-Drinks"
            case 1:
                self.image.image = UIImage(systemName: "cart.fill")
                self.descriptionLabel.text="Shopping"
            case 2:
                self.image.image = UIImage(systemName: "house.fill")
                self.descriptionLabel.text="Housing"
            case 3:
                self.image.image = UIImage(systemName: "tram.fill")
                self.descriptionLabel.text="Transport"
            case 4:
                self.image.image = UIImage(systemName: "car.fill")
                self.descriptionLabel.text="Vehicle"
            case 5:
                self.image.image = UIImage(systemName: "film")
                self.descriptionLabel.text="Entertainment"
            case 6:
                self.image.image = UIImage(systemName: "desktopcomputer")
                self.descriptionLabel.text="Computer"
            case 7:
                self.image.image = UIImage(systemName: "dollarsign.circle")
                self.descriptionLabel.text="Loan"
            case 8:
                self.image.image = UIImage(systemName: "dollarsign.circle")
                self.descriptionLabel.text="Taxes"
            case 9:
                self.image.image = UIImage(systemName: "dollarsign.circle")
                self.descriptionLabel.text="Financial"
            case 10:
                self.image.image = UIImage(systemName: "dollarsign.circle")
                self.descriptionLabel.text="Income"
            case 11:
                self.image.image = UIImage(systemName: "tag")
                self.descriptionLabel.text="Income"
            default:
                self.image.image = UIImage(systemName: "questionmark")
            }
        }
    }
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(selectedMe))
    }
    @objc func selectedMe(){
//        delegate?.selectedMe(index: myIndex)
    }
}
class addWallEntrDateCell: UITableViewCell{
    var delegate: addWalletEntryVCProtocol?
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func datePicker(_ sender: UIDatePicker){
        print("date= \(datePicker.date)")
        delegate?.addDateOfAddition(date: self.datePicker.date)
        let myDateFormater = DateFormatter()
            myDateFormater.dateStyle = .long
        let myTimeFormater = DateFormatter()
            myTimeFormater.dateFormat = "hh:mm a"
        dateLabel.text =  myTimeFormater.string(from:  self.datePicker.date) + ", " + myDateFormater.string(from:  self.datePicker.date)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        print("afn date= \(datePicker.date)")
        delegate?.addDateOfAddition(date: self.datePicker.date)
        let myDateFormater = DateFormatter()
            myDateFormater.dateStyle = .long
        let myTimeFormater = DateFormatter()
            myTimeFormater.dateFormat = "hh:mm a"
        dateLabel.text =  myTimeFormater.string(from:  self.datePicker.date) + ", " + myDateFormater.string(from:  self.datePicker.date)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            print("is selected")
//            datePickerHeightConstraint.constant = 175-datePickerHeightConstraint.constant
            //TODO: update cell heigth
            super.setSelected(false, animated: true)
        }
        // Configure the view for the selected state
    }
}
