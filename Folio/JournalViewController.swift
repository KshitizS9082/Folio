//
//  journalViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 25/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import JTAppleCalendar
struct journalCard {
    var type = journalCardType.small
    var dateInCal: Date?
    var smallCard: smallCardData?
    var bigCard: bigCardData?
    var mediaCard: mediaCardData?
    //used for segue from PageExtractViewController to switchPageTimelineVC
    var pageID: pageInfo?
}
enum journalCardType: String{
    case small
    case big
    case media
    case audio
}
protocol addCardInJournalProtocol {
    func addMediaCell()
    func addWrittenEntry()
    func addLocationEntry()
}

class JournalViewController: UIViewController {
    
    var pagesListFromPLVC = pageInfoList()
    var pages = [PageData]()
    var allCards = [journalCard]()
    var journalEntryCards = [journalCard]()
//    var datesPresent = [Date]()
    var selectedDate = Date()
    var cardsForSelectedDate = [journalCard]()
    var sizeType = cardSizeMode.full
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var toggleCalendarButton: UIBarButtonItem!
    var numberOfRows = 6
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode   = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        constraint.constant=fullCalHeight
        self.calendarView.reloadData(withanchor: selectedDate)
        
        setupData()
        setupTable()
        table.reloadData()
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        table.addGestureRecognizer(pinch)
    }
    
    @IBAction func toggleCalendar(_ sender: Any) {
        if numberOfRows == 6 {
            self.constraint.constant = singleRohCalHeight
            self.numberOfRows = 1
            self.toggleCalendarButton.image = UIImage(systemName: "rectangle.expand.vertical")
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { completed in
                //NOTE: did set anchor date to todays date
                self.calendarView.reloadData(withanchor: self.selectedDate)
//                self.calendarView.reloadData()
            }
        } else {
            self.constraint.constant = fullCalHeight
            self.numberOfRows = 6
            self.toggleCalendarButton.image = UIImage(systemName: "rectangle.compress.vertical")
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
//                self.calendarView.reloadData(withanchor: Date())
                self.calendarView.reloadData(withanchor: self.selectedDate)
//                self.calendarView.reloadData()
            })
        }
    }
    func setupData(){
        var fileName=""
        self.allCards.removeAll()
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
//                        pages.append(page)
                        page.bigCards.forEach { (card) in
                            if let doc=card.card.dateOfCompletion{
                            self.allCards.append(journalCard(type: .big, dateInCal: doc, smallCard: nil, bigCard: card, mediaCard: nil, pageID: info))
                            }
                        }
                        page.smallCards.forEach { (card) in
                            if let doc=card.card.dateOfCompletion{
                            self.allCards.append(journalCard(type: .small, dateInCal: doc, smallCard: card, bigCard: nil, mediaCard: nil, pageID: info))
                            }
                        }
                        page.mediaCards.forEach { (card) in
                            self.allCards.append(journalCard(type: .media, dateInCal: card.card.dateOfConstruction, smallCard: nil, bigCard: nil, mediaCard: card, pageID: info))
                        }
                    }else{
                        print("WARNING: DROPPED A PAGE INSIDE PAGEEXTRACTVC")
                    }
                }
            }
        }
        print("journalentrycards count - \(journalEntryCards.count)")
        for card in journalEntryCards{
            print("insed add from journalEntryCards")
            allCards.append(card)
        }
//        print("self.cards ")
//        for card in self.allCards{
//            print(card)
//        }
    }
    func setupSelectedDate(){
        cardsForSelectedDate.removeAll()
        for card in allCards{
            let sameDat =  Calendar.current.isDate(card.dateInCal!, equalTo: selectedDate, toGranularity: .day)
            if sameDat{
                cardsForSelectedDate.append(card)
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let visibleDates = calendarView.visibleDates()
        calendarView.viewWillTransition(to: .zero, with: coordinator, anchorDate: visibleDates.monthDates.first?.date)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe=true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe=false
    }
//    override func viewDidAppear(_ animated: Bool) {
//        self.calendarView.reloadData(withanchor: Date())
//    }
    
    // MARK: - Navigation
    var selectedCell: Int?
    var uniqueIdOfCardToShow: UUID?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromCalendarShowCardSegue"{
            if let targetController = segue.destination as? SwitchPageTimelineViewController{
                targetController.pageID = cardsForSelectedDate[selectedCell!].pageID
                targetController.uniqueIdOfCardToShow = self.uniqueIdOfCardToShow
                self.uniqueIdOfCardToShow=nil
            }
        }
    }
    
}
extension JournalViewController{
    var fullCalHeight: CGFloat{
        return 300
    }
    var singleRohCalHeight: CGFloat{
        return 100
    }
    var monthLabelViewSize: CGFloat{
        return 40
    }
    var pageColor: UIColor{
        return UIColor(named: "myBackgroundColor") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
}

extension JournalViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = Date()
        
        if numberOfRows == 6 {
            return ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: numberOfRows)
        } else {
            return ConfigurationParameters(startDate: startDate,
                                           endDate: endDate,
                                           numberOfRows: numberOfRows,
                                           generateInDates: .forFirstMonthOnly,
                                           generateOutDates: .off,
                                           hasStrictBoundaries: false)
        }
        
    }
}
extension JournalViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        //        if cellState.dateBelongsTo == .thisMonth {
        //           cell.isHidden = false
        //        } else {
        //           cell.isHidden = true
        //        }
         cell.isPresentView.isHidden=true
        for card in allCards{
            let sameDat =  Calendar.current.isDate(card.dateInCal!, equalTo: date, toGranularity: .day)
            if sameDat{
                cell.isPresentView.isHidden=false
                break
            }
        }
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor(named: "mainTextColor")
        } else {
            cell.dateLabel.textColor = UIColor(named: "subMainTextColor")
        }
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
//            cell.selectedView.layer.cornerRadius =  15
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
    }
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if cellState.dateBelongsTo == .thisMonth{
            return true
        }else{
            return false
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        formatter.dateFormat = "MMM YYYY"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = formatter.string(from: range.start)
        return header
    }

    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: monthLabelViewSize)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
//        print("selected date] = \(date)")
        self.selectedDate=date
        for card in allCards{
            let sameDat =  Calendar.current.isDate(card.dateInCal!, equalTo: date, toGranularity: .day)
            if sameDat{
                cardsForSelectedDate.append(card)
            }
        }
        table.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
//        print("DEselected date] = \(date)")
        self.cardsForSelectedDate.removeAll()
    }
}

extension JournalViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==1{
            return 1
        }
        return cardsForSelectedDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section==1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "addEntryCell", for: indexPath) as! addEntryInJournalTableViewCell
            cell.backgroundColor = .clear
            cell.addCardDelegate=self
            return cell
        }
        switch cardsForSelectedDate[indexPath.row].type {
        case .small:
            return setSmallCardCell(tableView, cellForRowAt: indexPath)
        case .big:
            return setBigCardCell(tableView, cellForRowAt: indexPath)
        case .media:
            return setMediaCardCell(tableView, cellForRowAt: indexPath)
        default:
            print("i dunno what card this is x")
        }
        return UITableViewCell()
    }
    
    func setSmallCardCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "smallCardCell", for: indexPath) as! ScardTimelineTableViewCell
        cell.delegate=self
        cell.showLinkDelegate=self
        cell.sizeType = self.sizeType
        cell.indexpath = indexPath
        cell.row = indexPath.row
        cell.backgroundColor = .clear
        cell.card=cardsForSelectedDate[indexPath.row].smallCard?.card
        if let done = cell.card?.isDone{
            cell.isDone = done
        }
        cell.awakeFromNib()
        cell.checkBox.isUserInteractionEnabled=false
        cell.titleTextView.isEditable=false
        cell.notesTextView.isEditable=false
        cell.linkView.isUserInteractionEnabled=true
        return cell
    }
    func setBigCardCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "bigCardCell", for: indexPath) as! BigcardTimelineTableViewCell
        cell.delegate=self
        cell.showLinkDelegate=self
        cell.sizeType = self.sizeType
        cell.indexpath=indexPath
        cell.row = indexPath.row
        cell.backgroundColor = .clear
        cell.card=cardsForSelectedDate[indexPath.row].bigCard?.card
//        cell.linkView.isHidden=true
        cell.awakeFromNib()
        cell.checkBox.isUserInteractionEnabled=false
        //        cell.checkListTable.isUserInteractionEnabled=fal
        cell.titleTextView.isEditable=false
        cell.additionalView.isUserInteractionEnabled=false
        cell.linkView.isUserInteractionEnabled=true
        return cell
    }
    func setMediaCardCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "mediaCardCell", for: indexPath) as! MediaCardTableViewCell
        //reload data added to remove a bug where previous cell without image deleted in page view and new cell with image added would result in crash DO NOT REMOVE!!
        cell.collectionView.reloadData()
        cell.showLinkDelegate=self
        cell.card=cardsForSelectedDate[indexPath.row].mediaCard?.card
        cell.backgroundColor = .clear
        cell.delegate=self
        cell.indexpath=indexPath
        cell.row=indexPath.row
        cell.backgroundColor = .clear
        cell.sizeType = self.sizeType
//        cell.linkView.isHidden=true
        cell.awakeFromNib()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table.deselectRow(at: indexPath, animated: false)
    }
}
extension JournalViewController: myUpdateCellHeightDelegate{
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
extension JournalViewController: timelineSwitchDelegate{
    func switchToPageAndShowCard(with uniqueID: UUID) {
        print("inside switchToPageAndShowCard")
        self.uniqueIdOfCardToShow=uniqueID
        cardsForSelectedDate.indices.forEach{ (ind) in
            let tlcard = cardsForSelectedDate[ind]
            if let card = tlcard.bigCard{
                if card.card.UniquIdentifier == uniqueID{
                    selectedCell=ind
                    print("gonna perform segue with cell at \(selectedCell!)")
                    performSegue(withIdentifier: "fromCalendarShowCardSegue", sender: self)
                    return
                }
            }
            if let card = tlcard.smallCard{
                if card.card.UniquIdentifier == uniqueID{
                    selectedCell=ind
                    print("gonna perform segue with cell at \(selectedCell!)")
                    performSegue(withIdentifier: "fromCalendarShowCardSegue", sender: self)
                    return
                }
            }
            if let card = tlcard.mediaCard{
                if card.card.UniquIdentifier == uniqueID{
                    selectedCell=ind
                    print("gonna perform segue with cell at \(selectedCell!)")
                    performSegue(withIdentifier: "fromCalendarShowCardSegue", sender: self)
                    return
                }
            }
        }
    }
}
extension JournalViewController: addCardInJournalProtocol{
    func addMediaCell() {
        print("inside addMediaCell")
        let card = journalCard(type: .media, dateInCal: selectedDate, smallCard: nil, bigCard:  nil, mediaCard: mediaCardData(), pageID: nil)
        journalEntryCards.append(card)
        setupData()
        setupSelectedDate()
        print("no. of cards to show \(cardsForSelectedDate.count)")
        table.reloadData()
        for ind in cardsForSelectedDate.indices{
            let cr = cardsForSelectedDate[ind]
            if cr.mediaCard?.card.UniquIdentifier == card.mediaCard?.card.UniquIdentifier{
                table.scrollToRow(at: IndexPath(row: ind, section: 0), at: .middle, animated: true)
            }
        }
    }
    
    func addWrittenEntry() {
        print("inside addWrittenEntry")
    }
    
    func addLocationEntry() {
        print("inside addLocationEntry")
    }
    
    
}

