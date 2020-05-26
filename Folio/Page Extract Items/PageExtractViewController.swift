//
//  PageExtractViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 24/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class PageExtractViewController: UIViewController {
    var pagesListFromPLVC = pageInfoList()
    var pages = [PageData]()
    var selectedExtractView : Int = 0
    var sizeType = cardSizeMode.full
    var cardsList = [timeLineCard]()
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    func addAllCards(for page: PageData){
        page.bigCards.forEach { (card) in
            cardsList.append(timeLineCard(type: .big, smallCard: nil, bigCard: card, mediaCard: nil))
        }
        page.smallCards.forEach { (card) in
            cardsList.append(timeLineCard(type: .small, smallCard: card, bigCard: nil, mediaCard: nil))
        }
        page.mediaCards.forEach { (card) in
            cardsList.append(timeLineCard(type: .media, smallCard: nil, bigCard: nil, mediaCard: card))
        }
    }
    func addTodayCards(for page: PageData){
        let calendar = Calendar.current
        page.bigCards.forEach { (card) in
            if let date = card.card.reminder, calendar.isDateInToday(date){
                cardsList.append(timeLineCard(type: .big, smallCard: nil, bigCard: card, mediaCard: nil))
            }
        }
        page.smallCards.forEach { (card) in
            if let date = card.card.reminderDate, calendar.isDateInToday(date){
            cardsList.append(timeLineCard(type: .small, smallCard: card, bigCard: nil, mediaCard: nil))
            }
        }
    }
    func addScheduledCards(for page: PageData){
        page.bigCards.forEach { (card) in
            if card.card.reminder != nil{
                cardsList.append(timeLineCard(type: .big, smallCard: nil, bigCard: card, mediaCard: nil))
            }
        }
        page.smallCards.forEach { (card) in
            if card.card.reminderDate != nil{
            cardsList.append(timeLineCard(type: .small, smallCard: card, bigCard: nil, mediaCard: nil))
            }
        }
    }
    func addDueCards(for page: PageData){
        page.bigCards.forEach { (card) in
            if let date = card.card.reminder, date<Date(){
                cardsList.append(timeLineCard(type: .big, smallCard: nil, bigCard: card, mediaCard: nil))
            }
        }
        page.smallCards.forEach { (card) in
            if let date = card.card.reminderDate, date<Date(){
            cardsList.append(timeLineCard(type: .small, smallCard: card, bigCard: nil, mediaCard: nil))
            }
        }
    }
    func setupData(){
        var fileName=""
        for info in pagesListFromPLVC.items{
            fileName=info.fileName
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(fileName){
                if let jsonData = try? Data(contentsOf: url){
                    if let page = PageData(json: jsonData){
                        pages.append(page)
                        switch selectedExtractView {
                        case 0:
                            self.addTodayCards(for: page)
                        case 1:
                            self.addScheduledCards(for: page)
                        case 2:
                            self.addAllCards(for: page)
                        case 3:
                            self.addDueCards(for: page)
                        default:
                            print("to show case not handleed")
                        }
                    }else{
                        print("WARNING: DROPPED A PAGE INSIDE PAGEEXTRACTVC")
                    }
                }
            }
        }
    }
    func setupTable(){
        table.dataSource=self
        table.delegate=self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(UINib(nibName: "smallCardTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "titleTextCell")
        table.register(UINib(nibName: "SmallCardDatePickerTableViewCell", bundle: nil), forCellReuseIdentifier: "datePickerCell")
        table.register(UINib(nibName: "ScardTimelineTableViewCell", bundle: nil), forCellReuseIdentifier: "smallCardCell")
        table.register(UINib(nibName: "BigcardTimelineTableViewCell", bundle: nil), forCellReuseIdentifier: "bigCardCell")
        table.register(UINib(nibName: "MediaCardTableViewCell", bundle: nil), forCellReuseIdentifier: "mediaCardCell")
        table.backgroundColor = pageColor
        table.rowHeight = UITableView.automaticDimension
    }
    @objc func handlePinch(pinch: UIPinchGestureRecognizer){
        if pinch.state == .ended{
            if pinch.scale>1.0{
                switch self.sizeType {
                case .small:
                    self.sizeType = .medium
                case .medium:
                    self.sizeType = .full
                default:
                    print("can't zoom in further")
                }
            }else if pinch.scale<1.0{
                switch self.sizeType {
                case .full:
                    self.sizeType = .medium
                case .medium:
                    self.sizeType = .small
                default:
                    print("can't zoom out further")
                }
            }
            print("size type = \(self.sizeType)")
            table.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupTable()
        table.reloadData()
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        view.addGestureRecognizer(pinch)
        //to dismiss keyboard
        let tap=UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        // register for notifications when the keyboard appears:
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @objc func keyboardWillShow( note:NSNotification ){
           // read the CGRect from the notification (if any)
           if let newFrame = (note.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
               let insets = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height, right: 0 )
               table.contentInset = insets
               table.scrollIndicatorInsets = insets
           }
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = UIColor.systemBlue
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PageExtractViewController{
    var pageColor: UIColor{
        return #colorLiteral(red: 0.9411764706, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
    }
    var mediaCardCellColor: UIColor{
        return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

}
extension PageExtractViewController: UITableViewDataSource, UITableViewDelegate{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsList.count
//        switch section{
//        case 0:
//            return 1
//        case 1:
//            return cardsList.count
//        default:
//            print("no idea what is this")
//        }
//        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
////            cell.textLabel?.font =  UIFont(name: "SnellRoundhand-Black", size: 30)
//            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 30)
//            cell.textLabel?.text = "All Card's"
//            cell.backgroundColor=UIColor.clear
//            return cell
//        case 1:
        switch cardsList[indexPath.row].type {
        case .small:
            return setSmallCardCell(tableView, cellForRowAt: indexPath)
        case .big:
            return setBigCardCell(tableView, cellForRowAt: indexPath)
        case .media:
            return setMediaCardCell(tableView, cellForRowAt: indexPath)
        default:
            print("i dunno what card this is x")
        }
//        default:
//            print("i dunno what card this is y")
//        }
        return UITableViewCell()
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "TempTitle"
//    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        let headerLabel = UILabel()
        headerView.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints=false
        [
            headerLabel.leftAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.leftAnchor, constant: 10),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.centerYAnchor, constant: 0)
            ].forEach { (cst) in
                cst.isActive=true
        }
        headerLabel.font = UIFont.boldSystemFont(ofSize: 30)
        switch self.selectedExtractView {
        case 0:
            headerLabel.textColor = UIColor.systemBlue
            headerLabel.text = "Today Card's"
        case 1:
            headerLabel.textColor = UIColor.systemYellow
            headerLabel.text = "Scheduled Card's"
        case 2:
            headerLabel.textColor = UIColor.systemGray
            headerLabel.text = "All Card's"
        case 3:
            headerLabel.textColor = UIColor.systemRed
            headerLabel.text = "Due Card's"
        default:
            headerLabel.textColor = UIColor.black
        }
        navigationController?.navigationBar.topItem?.title = headerLabel.text
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:headerLabel.textColor ?? UIColor.systemBlue]
        navigationController?.navigationBar.tintColor = headerLabel.textColor
//        let appearance = UINavigationBarAppearance()
//        appearance.titleTextAttributes = [.foregroundColor: headerLabel.textColor ?? UIColor.systemBlue]
//        appearance.largeTitleTextAttributes = [.foregroundColor: headerLabel.textColor ?? UIColor.systemBlue]
////        appearance.backgroundColor = pageColor
//        appearance.shadowImage = UIImage()
//        appearance.backgroundImage = UIImage()
//        navigationItem.standardAppearance = appearance
//        navigationItem.scrollEdgeAppearance = appearance
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)

        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func setSmallCardCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "smallCardCell", for: indexPath) as! ScardTimelineTableViewCell
        cell.delegate=self
        //            cell.showLinkDelegate = myViewController
        cell.sizeType = self.sizeType
        cell.indexpath = indexPath
        cell.row = indexPath.row
        cell.card=cardsList[indexPath.row].smallCard?.card
        if let done = cell.card?.isDone{
            cell.isDone = done
        }
        cell.linkView.isHidden=true
        cell.awakeFromNib()
        return cell
    }
    func setBigCardCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "bigCardCell", for: indexPath) as! BigcardTimelineTableViewCell
        cell.delegate=self
        //        cell.updateCardDelegate=self
        //            cell.showLinkDelegate=myViewController
        cell.sizeType = self.sizeType
        cell.indexpath=indexPath
        cell.row = indexPath.row
        cell.card=cardsList[indexPath.row].bigCard?.card
        cell.linkView.isHidden=true
        cell.awakeFromNib()
        return cell
    }
    func setMediaCardCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "mediaCardCell", for: indexPath) as! MediaCardTableViewCell
        //reload data added to remove a bug where previous cell without image deleted in page view and new cell with image added would result in crash DO NOT REMOVE!!
        cell.collectionView.reloadData()
        //            cell.showLinkDelegate=myViewController
        cell.card=cardsList[indexPath.row].mediaCard?.card
        cell.backgroundColor=mediaCardCellColor
        cell.delegate=self
        cell.indexpath=indexPath
        cell.row=indexPath.row
        cell.sizeType=self.sizeType
        cell.linkView.isHidden=true
        cell.awakeFromNib()
        return cell
    }
}
extension PageExtractViewController: myUpdateCellHeightDelegate{
    func saveBigCard(with card: Card) {
//        let uniqueID = card.UniquIdentifier
//        if let cardDatas = page?.bigCards{
//            for ind in cardDatas.indices{
//                if cardDatas[ind].card.UniquIdentifier==uniqueID{
//                    print("found the place to save to")
//                    page?.bigCards[ind].card = card
//                }
//            }
//        }
    }
    //TODO: see if ever calls
    func saveMediaCard(with card: MediaCard) {
//        let uniqueID = card.UniquIdentifier
//        if let cardDatas = page?.mediaCards{
//            for ind in cardDatas.indices{
//                if cardDatas[ind].card.UniquIdentifier==uniqueID{
//                    print("found the place to save to nv = \(card)")
//                    page?.mediaCards[ind].card = card
//                }
//            }
//        }
    }
    
    func saveSmallCard(with card: SmallCard) {
//        let uniqueID = card.UniquIdentifier
//        if let cardDatas = page?.smallCards{
//            for ind in cardDatas.indices{
//                if cardDatas[ind].card.UniquIdentifier==uniqueID{
//                    page?.smallCards[ind].card = card
//                }
//            }
//        }
    }
    
    func updated(height: CGFloat, row: Int, indexpath: IndexPath) {
        //TODO: maybe use this stord height method, but not required
        
        // Disabling animations gives us our desired behaviour
        UIView.setAnimationsEnabled(false)
        /* These will causes table cell heights to be recaluclated,
         without reloading the entire cell */
        table.beginUpdates()
        table.endUpdates()
        // Re-enable animations
        UIView.setAnimationsEnabled(true)
        
        table.scrollToRow(at: indexpath, at: .bottom, animated: false)
    }
}
