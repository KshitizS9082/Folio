//
//  addWalletEntryViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/07/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import ImagePicker
protocol addWalletEntryVCProtocol {
    func addType(type: walletEntry.tansferType)
    func addCategory(categ: walletEntry.spendingCategory)
    func addDateOfAddition(date: Date)
    func addNote(note: String)
    func addPayee(payeeName: String)
    func addPaymentType(paymentType: String)
    func addImageURL(imageURL: String)
    func updated(indexpath: IndexPath, animated: Bool)
    func scollTo(indexpath: IndexPath, animated: Bool)
    func preseintViewController(vc: UIViewController)
}

class addWalletEntryViewController: UIViewController {
    var delegate: walletProtocol?
    var entry = walletEntry()
    var isNewEntry = false //to distinguish between adding a new and editing a old
    
    @IBOutlet weak var backgroundView: UIView!{
        didSet{
            backgroundView.layer.masksToBounds=true
            backgroundView.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemChromeMaterial)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = backgroundView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundView.addSubview(blurEffectView)
            backgroundView.sendSubviewToBack(blurEffectView)
        }
    }
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var valueField: UITextField!
    @IBAction func valueDedEndEditting(_ sender: UITextField) {
        self.entry.value = Float(sender.text ?? "0.0") ?? Float(0.0)
        //TODO: save number value
    }
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
        // register for notifications when the keyboard appears:
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        self.addCategory(categ: entry.category)
        if !isNewEntry{
            if entry.value<0.0 {
                valueField.text = String(-entry.value)
            }else{
                valueField.text = String(entry.value)
            }
        }
        if entry.type == .expense{
            incomeExpenseSegmentControl.selectedSegmentIndex=0
        }else{
            incomeExpenseSegmentControl.selectedSegmentIndex=1
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
    }
    @IBAction func handleCancelTap(_ sender: Any) {
        let fileManager = FileManager.default
        if let fileName = self.entry.imageURL{
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(fileName){
                do{
                    try fileManager.removeItem(at: url)
                    print("deleted item \(url) succefully")
                } catch{
                    print("ERROR: item  at \(url) couldn't be deleted")
                    return
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func handleDoneTap(_ sender: Any) {
        print("wallet entry set to \(self.entry)")
        if incomeExpenseSegmentControl.selectedSegmentIndex == 0{
            if entry.value>0{
                entry.value = -entry.value
            }
        }else{
            if entry.value<0{
                entry.value = -entry.value
            }
        }
        if isNewEntry{
            delegate?.addWallwtEntry(entry)
        }else{
            delegate?.modifyWalletEntry(to: entry)
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var navBar: UINavigationBar!{
        didSet{
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
        }
    }
    @objc func keyboardWillShow( note:NSNotification ){
        // read the CGRect from the notification (if any)
        if let newFrame = (note.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height, right: 0 )
            table.contentInset = insets
            table.scrollIndicatorInsets = insets
            UIView.animate(withDuration: 0.25) {
                self.table.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
        }
        print("did increase height")
    }
    

}
extension addWalletEntryViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
            cell.index = indexPath
            let myDateFormater = DateFormatter()
            myDateFormater.dateStyle = .long
            let myTimeFormater = DateFormatter()
            myTimeFormater.dateFormat = "hh:mm a"
            cell.dateLabel.text =  myTimeFormater.string(from:  self.entry.date) + ", " + myDateFormater.string(from:  self.entry.date)
            cell.datePicker.setDate(self.entry.date, animated: false)
            return cell
        case 2:
            let cell = table.dequeueReusableCell(withIdentifier: "addNoteCellId") as! addWallEntrNoteCell
            cell.delegate=self
            cell.index = indexPath
            cell.textView.text = self.entry.note
            return cell
        case 3:
            let cell = table.dequeueReusableCell(withIdentifier: "addPayeeCellId") as! addWallEntrPayeeCell
            cell.delegate=self
            cell.index = indexPath
            cell.nameField.text = self.entry.payee
            return cell
        case 4:
            let cell = table.dequeueReusableCell(withIdentifier: "addImageCellId") as! addWallEntryImageCell
            cell.delegate=self
            cell.index = indexPath
            cell.imageURL = self.entry.imageURL
            return cell
//        case 5:
//            return UITableViewCell()
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
    func scollTo(indexpath: IndexPath, animated: Bool){
        self.table.scrollToRow(at: indexpath, at: .middle, animated: true)
    }
    
    func preseintViewController(vc: UIViewController){
        self.present(vc, animated: true, completion: nil)
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
    var index =  IndexPath(row: 0, section: 0)
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
            if datePickerHeightConstraint.constant==0{
                datePicker.isHidden=false
                if #available(iOS 14, *){
                    datePickerHeightConstraint.constant = 35
                }else{
                    datePickerHeightConstraint.constant = 200
                }
            }else{
                datePicker.isHidden=true
                datePickerHeightConstraint.constant = 0
            }
            self.delegate?.updated(indexpath: self.index, animated: false)
            super.setSelected(false, animated: true)
        }
        // Configure the view for the selected state
    }
}

class addWallEntrNoteCell: UITableViewCell, UITextViewDelegate{
    var delegate: addWalletEntryVCProtocol?
    var index =  IndexPath(row: 0, section: 0)
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.delegate=self
            textView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.delegate?.scollTo(indexpath: index, animated: true)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.addNote(note: textView.text)
    }
    @objc func tapDone(sender: Any) {
        self.endEditing(true)
        self.layoutSubviews()
    }
}
class addWallEntrPayeeCell: UITableViewCell, UITextFieldDelegate{
    var delegate: addWalletEntryVCProtocol?
    var index =  IndexPath(row: 0, section: 0)
    
    @IBOutlet weak var nameField: UITextField!{
        didSet{
            nameField.delegate=self
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.delegate?.addPayee(payeeName: nameField.text ?? "")
    }
}

class addWallEntryImageCell: UITableViewCell, ImagePickerDelegate{
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("x")
        imagePicker.expandGalleryView()
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        let fileName=String.uniqueFilename(withPrefix: "WalletImageData")+".json"
        if images.count>0{
            let image = images[0]
            if let json = imageData(instData: (image.resizedTo1MB()!).pngData()!).json {
                if let url = try? FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                ).appendingPathComponent(fileName){
                    do {
                        try json.write(to: url)
                        print ("saved successfully")
                        //MARK: is a data leak to be corrected
                        //TODO: sometimes fileName added but not deleted
                        self.imageURL = fileName
                    } catch let error {
                        print ("couldn't save \(error)")
                    }
                }
            }
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("z")
        deleteImage()
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    var delegate: addWalletEntryVCProtocol?
    var index =  IndexPath(row: 0, section: 0)
    var imageURL: String?{
        didSet{
            if imageURL != nil{
                imagePreviewHeightConstraint.constant=125
//                delegate?.updated(indexpath: index, animated: true)
            }else{
                imagePreviewHeightConstraint.constant=80
            }
            if let fileName = imageURL{
                if let url = try? FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                ).appendingPathComponent(fileName){
                    if let jsonData = try? Data(contentsOf: url){
                        if let extract = imageData(json: jsonData){
                            let x=extract.data
                            if let image = UIImage(data: x){
                                DispatchQueue.main.async {
                                    self.imagePreview.image = image
                                }
                            }
                        }else{
                            print("couldnt get json from URL")
                        }
                    }
                }
            }
            if let url=imageURL{
                delegate?.addImageURL(imageURL: url)
            }
        }
    }
    @IBOutlet weak var imagePreview: UIImageView!{
        didSet{
            imagePreview.isUserInteractionEnabled=true
            imagePreview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTap)))
//            imagePreview.layer.masksToBounds=false
            imagePreview.layer.cornerRadius=8
//            imagePreview.layer.shadowColor=UIColor.gray.cgColor
//            imagePreview.layer.shadowOpacity=0.4
        }
    }
    @IBOutlet weak var imagePreviewHeightConstraint: NSLayoutConstraint!
    func deleteImage(){
        let fileManager = FileManager.default
        if let fileName = imageURL{
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(fileName){
                do{
                    try fileManager.removeItem(at: url)
                    print("deleted item \(url) succefully")
                } catch{
                    print("ERROR: item  at \(url) couldn't be deleted")
                    return
                }
            }
        }
    }
    @objc func handleImageTap(){
        deleteImage()
        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 1
        imagePickerController.delegate = self
//        self.present(imagePickerController, animated: true, completion: nil)
//        self.window?.rootViewController?.present(imagePickerController, animated: true, completion: nil)
        delegate?.preseintViewController(vc: imagePickerController)
    }
}
