//
//  journalViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 25/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import JTAppleCalendar
import MapKit
import CoreLocation
import ImagePicker
//TODO: instead of calling setupdata at updates try doing somethign like updateJournalNotesCard as setupdata may be very inefficient

struct journalCard: Codable {
    var type = journalCardType.notes
    var dateInCal: Date?
    var journalNotesCard: noteJournalCard?
    var journalLocationCard: locationJournalCard?
    var journalMediaCard: mediaJournalCard?
    var habitCard: habitJournalCard?
    var kanbanCard: KanbanCard?
    //used for segue from PageExtractViewController to switchPageTimelineVC
//    var pageID: pageInfo?
}
struct habitJournalCard: Codable{
    var UniquIdentifier=UUID()
    var title = ""
    var entryCount = 0.0
    var goalCount = 0.0
    var entryDate: Date?
    var habitGoalPeriod = habitCardData.recurencePeriod.daily
}
struct journalCardList: Codable{
    var jCards = [journalCard]()
    init(){
    }
    init?(json: Data){
        if let newValue = try? JSONDecoder().decode(journalCardList.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}
struct noteJournalCard: Codable {
    var UniquIdentifier = UUID()
//    var dateOfCreation = Date()
    var notesText = "Notes goes here"
    var subNotesText = "SubNotes goes here"
}
struct locationJournalCard: Codable {
    var UniquIdentifier = UUID()
//    var dateOfCreation = Date()
    var locationAnnotations = [CodableMKPointAnnotation]()
    var locationData: Data?
    var notesText = "Notes goes here"
    var subNotesText = "SubNotes goes here"
}
struct mediaJournalCard: Codable {
    var UniquIdentifier = UUID()
//    var dateOfCreation = Date()
    var imageData: Data?
    var imageFileName = [String]()
    var notesText = "Notes goes here"
    var subNotesText = "SubNotes goes here"
}
enum journalCardType: String, Codable{
    case audio
    case notes
    case journalLocation
    case journalMedia
    case habits
    case kanban
}
protocol addCardInJournalProtocol {
    func addMediaCell()
    func addWrittenEntry()
    func addLocationEntry()
    func updateJournalNotesEntry(at index: IndexPath, with text: String)
    func updateJournalNotesCard(at index: IndexPath, with card: noteJournalCard)
    func updateJournalMediaCard(at index: IndexPath, with card: mediaJournalCard)
    func showJournalFullView(at index: IndexPath)
    func updateJournalMediasNotesEntry(at index: IndexPath, with text: String)
    func getJournalMedia(at index: IndexPath)
    func updateJournalLocationNotesEntry(at index: IndexPath, with text: String)
    func getJournalLocation(at index: IndexPath)
    func setJournalLocation(at index: IndexPath, to locations: [CodableMKPointAnnotation])
    func deleteJournalCard(at index: IndexPath)
}

class JournalViewController: UIViewController {
    
//    var pagesListFromPLVC = pageInfoList()
//    var pages = [PageData]()
    var allCards = [journalCard]()
    var journalEntryCards = [journalCard]()
    var habits = HabitsData()
    var kanbanList = KanbanListInfo()
    var boards = [(String,Kanban)]()
    func loadKanbanBoards(){
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("KanbanList.json"){
            print("trying to extract contents of jsonData")
            if let jsonData = try? Data(contentsOf: url){
                //                pageList = pageInfo(json: jsonData)
                if let x = KanbanListInfo(json: jsonData){
                    kanbanList = x
                }else{
                    print("WARNING: COULDN'T UNWRAP JSON DATA TO FIND PAGELIST")
                }
            }
        }
        boards.removeAll()
        for ind in kanbanList.boardNames.indices{
            let fileName = kanbanList.boardFileNames[ind]
            let boardName = kanbanList.boardNames[ind]
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(fileName){
                if let jsonData = try? Data(contentsOf: url){
                    if let x = Kanban(json: jsonData){
                        boards.append((boardName,x))
                    }else{
                        print("WARNING: COULDN'T UNWRAP JSON DATA TO FIND kanbanData in homepage")
                    }
                }
            }
        }
    }
    
    var selectedDate = Date()
    var cardsForSelectedDate = [journalCard]()
//    var sizeType = cardSizeMode.full
    let locationManager = CLLocationManager()
//    var typesToShow
    var showJournalCards = true
//    var showPageCards = true
    var showHabitCards = true
    var showWalletCards = true
    var showKanbanCards = true
    
    @IBOutlet weak var backgroundImageView: UIImageView!{
        didSet{
            backgroundImageView.addBlurEffect()
        }
    }
    
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!{
        didSet{
//            calendarView.layer.cornerRadius = 10
//            calendarView.layer.masksToBounds=true
//            calendarView.backgroundColor = .clear
//            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemThinMaterial)
//            let blurEffectView = UIVisualEffectView(effect: blurEffect)
//            blurEffectView.frame = calendarView.bounds
//            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            calendarView.addSubview(blurEffectView)
        }
    }
    @IBOutlet weak var mapView: MKMapView!
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
        self.constraint.constant = singleRohCalHeight
        self.numberOfRows = 1
        self.calendarView.reloadData(withanchor: selectedDate)
        self.calendarView.selectDates([selectedDate])
        
        setupData()
        setupTable()
        table.reloadData()
        // register for notifications when the keyboard appears:
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @objc func keyboardWillShow( note:NSNotification ){
        print("asasasas did show keyboard")
        // read the CGRect from the notification (if any)
        if let newFrame = (note.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height, right: 0 )
            table.contentInset = insets
            table.scrollIndicatorInsets = insets
            UIView.animate(withDuration: 0.25) {
                self.table.layoutIfNeeded()
                self.table.layoutIfNeeded()
            }
        }
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
    @IBAction func setCardsToShow(_ sender: UIBarButtonItem) {
        let toggleJournal = UIAlertAction(title: self.showJournalCards ? "Hide Journal Cards": "Unhide Journal Cards", style: .default) { (action) in
            self.showJournalCards  = !self.showJournalCards
            self.setupData()
            self.setupSelectedDate()
            self.table.reloadData()
        }
        let togglePage = UIAlertAction(title: self.showKanbanCards ? "Hide Kanban Cards": "Unhide Kanban Cards", style: .default) { (action) in
            self.showKanbanCards  = !self.showKanbanCards
            self.setupData()
            self.setupSelectedDate()
            self.table.reloadData()
        }
        let toggleHabit = UIAlertAction(title: self.showHabitCards ? "Hide Habit Cards": "Unhide Habit Cards", style: .default) { (action) in
            self.showHabitCards  = !self.showHabitCards
            self.setupData()
            self.setupSelectedDate()
            self.table.reloadData()
        }
        let toggleWallet = UIAlertAction(title: self.showWalletCards ? "Hide Wallet Cards": "Unhide Wallet Cards", style: .default) { (action) in
            self.showWalletCards  = !self.showWalletCards
            self.setupData()
            self.setupSelectedDate()
            self.table.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (action) in
                                            // Respond to user selection of the action
        }
        let alert = UIAlertController(title: "Select Cards To Show",
                                      message: "Only cards from selected category will be shown",
                                      preferredStyle: .actionSheet)
        alert.addAction(toggleJournal)
        alert.addAction(togglePage)
        alert.addAction(toggleHabit)
        alert.addAction(toggleWallet)
        alert.addAction(cancelAction)
        // On iPad, action sheets must be presented from a popover.
        alert.popoverPresentationController?.barButtonItem = sender
        self.present(alert, animated: true) {
            // The alert was presented
        }
    }
    func setupData(){
        
        self.allCards.removeAll()
       
        print("journalentrycards count - \(journalEntryCards.count)")
        if showJournalCards{
            for card in journalEntryCards{
                allCards.append(card)
            }
        }
        if showHabitCards{
            for card in habits.cardList{
                for val in card.allEntries{
                    self.allCards.append(journalCard(type: .habits, dateInCal: val.key, habitCard: habitJournalCard(UniquIdentifier: card.UniquIdentifier, title: card.title, entryCount: val.value, goalCount: card.goalCount, entryDate: val.key, habitGoalPeriod: card.habitGoalPeriod)))
                }
            }
        }
        if showKanbanCards{
            for boardTup in boards{
                for board in boardTup.1.boards{
                    for card in board.items{
                        if let date = card.scheduledDate{
                            self.allCards.append(journalCard(type: .kanban,dateInCal: date, kanbanCard: card))
                        }
                    }
                }
            }
        }
    }
    func setupSelectedDate(){
        cardsForSelectedDate.removeAll()
        for card in allCards{
            let sameDat =  Calendar.current.isDate(card.dateInCal!, equalTo: selectedDate, toGranularity: .day)
            if sameDat{
                cardsForSelectedDate.append(card)
            }
        }
        cardsForSelectedDate.sort { (firstCard, secondCard) -> Bool in
//            if firstCard.type == .habits{
//                return false
//            }else if secondCard.type == .habits{
//                return true
//            }
            return firstCard.dateInCal! < secondCard.dateInCal!
        }
    }
    func setupTable(){
           table.dataSource=self
           table.delegate=self
//           table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//           table.register(UINib(nibName: "smallCardTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "titleTextCell")
//           table.register(UINib(nibName: "SmallCardDatePickerTableViewCell", bundle: nil), forCellReuseIdentifier: "datePickerCell")
//           table.register(UINib(nibName: "ScardTimelineTableViewCell", bundle: nil), forCellReuseIdentifier: "smallCardCell")
//           table.register(UINib(nibName: "BigcardTimelineTableViewCell", bundle: nil), forCellReuseIdentifier: "bigCardCell")
//           table.register(UINib(nibName: "MediaCardTableViewCell", bundle: nil), forCellReuseIdentifier: "mediaCardCell")
//           table.backgroundColor = pageColor
           table.rowHeight = UITableView.automaticDimension
       }
//    @objc func handlePinch(pinch: UIPinchGestureRecognizer){
//        if pinch.state == .ended{
//            if pinch.scale>1.0{
//                switch self.sizeType {
//                case .small:
//                    self.sizeType = .medium
//                case .medium:
//                    self.sizeType = .full
//                default:
//                    print("can't zoom in further")
//                }
//            }else if pinch.scale<1.0{
//                switch self.sizeType {
//                case .full:
//                    self.sizeType = .medium
//                case .medium:
//                    self.sizeType = .small
//                default:
//                    print("can't zoom out further")
//                }
//            }
//            print("size type = \(self.sizeType)")
//            table.reloadData()
//        }
//    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let visibleDates = calendarView.visibleDates()
        calendarView.viewWillTransition(to: .zero, with: coordinator, anchorDate: visibleDates.monthDates.first?.date)
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
        print("in viewwillappear")
        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.hidesBarsOnSwipe=true
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("journalCards.json"){
            if let jsonData = try? Data(contentsOf: url){
                if let extract = journalCardList(json: jsonData){
                    print("did set self.journalEntryCards to \(extract.jCards)")
                    self.journalEntryCards = extract.jCards
                }else{
                    print("ERROR: found PageData(json: jsonData) to be nil so didn't set it")
                }
            }else{
                print("error no file named journalCards.json found")
            }
        }
        
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("habitCardsData.json"){
            if let jsonData = try? Data(contentsOf: url){
                if let extract = HabitsData(json: jsonData){
                    print("did set self.habits to \(extract)")
                    self.habits = extract
                }else{
                    print("ERROR: found HabitsData(json: jsonData) to be nil so didn't set it")
                }
            }else{
                print("error no file named habitCardsData.json found")
            }
        }
        loadKanbanBoards()
        
        setupData()
        setupTable()
        table.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

        navigationController?.hidesBarsOnSwipe=false
        save()
    }
    
    func save() {
        var jcl = journalCardList()
        jcl.jCards=self.journalEntryCards
        if let json = jcl.json {
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("journalCards.json"){
                do {
                    try json.write(to: url)
                    print ("saved successfully")
                } catch let error {
                    print ("couldn't save \(error)")
                }
            }
        }
    }
    
    //index used for getting journal media
    var index = IndexPath()
    
    // MARK: - Navigation
    var selectedCell: Int?
    var uniqueIdOfCardToShow: UUID?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showJournalFullViewSegue"{
            if let targetController = segue.destination as? journalCardFullViewViewController{
                targetController.type = cardsForSelectedDate[selectedCell!].type
                targetController.card = cardsForSelectedDate[selectedCell!].journalNotesCard
                targetController.mediaCard = cardsForSelectedDate[selectedCell!].journalMediaCard
                targetController.index = IndexPath(row: selectedCell!, section: 0)
                targetController.delegate=self
            }
        }
    }
    
}
extension JournalViewController{
    var fullCalHeight: CGFloat{
        return 250
    }
    var singleRohCalHeight: CGFloat{
        return 90
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
        let calenar = Calendar.current
        if calenar.isDateInToday(date){
            self.selectedDate=Date()
        }
//        for card in allCards{
//            let sameDat =  Calendar.current.isDate(card.dateInCal!, equalTo: date, toGranularity: .day)
//            if sameDat{
//                cardsForSelectedDate.append(card)
//            }
//        }
        self.setupSelectedDate()
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
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.addCardDelegate=self
            return cell
        }
        switch cardsForSelectedDate[indexPath.row].type {
//        case .small:
//            return setSmallCardCell(tableView, cellForRowAt: indexPath)
//        case .big:
//            return setBigCardCell(tableView, cellForRowAt: indexPath)
//        case .media:
//            return setMediaCardCell(tableView, cellForRowAt: indexPath)
        case .notes:
            return setNotesCardCell(tableView, cellForRowAt: indexPath)
        case .journalMedia:
            return setJournalMediaCardCell(tableView, cellForRowAt: indexPath)
        case .journalLocation:
            return setJournalLocationCardCell(tableView, cellForRowAt: indexPath)
        case .habits:
            return setJournalHabitCardCell(tableView, cellForRowAt: indexPath)
        case .kanban:
            return setKanbanCardCell(tableView, cellForRowAt: indexPath)
        default:
            print("i dunno what card this is x")
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section==1 || (cardsForSelectedDate[indexPath.row].type != .notes && cardsForSelectedDate[indexPath.row].type != .journalMedia && cardsForSelectedDate[indexPath.row].type != .journalLocation){
            let configuration = UISwipeActionsConfiguration(actions: [])
            return configuration
        }
        let action = UIContextualAction(style: .destructive, title: "Delete",
                                        handler: { (action, view, completionHandler) in
                                            self.deleteJournalCard(at: indexPath)
//                                            self.tableView.beginUpdates()
//                                            self.tableView.deleteRows(at: [indexPath], with: .automatic)
//                                            self.tableView.endUpdates()
                                            completionHandler(true)
        })
        action.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
   
    func setNotesCardCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
         let cell = tableView.dequeueReusableCell(withIdentifier: "journalNotesTVC", for: indexPath) as! journalNotesTableViewCell
        cell.selectionStyle = .none
        cell.delegate=self
        cell.index = indexPath
        let formatter = DateFormatter()
        let card = cardsForSelectedDate[indexPath.row]
        formatter.dateStyle = .full
        cell.dateLabel.text = formatter.string(from: card.dateInCal!)
        formatter.dateFormat = "hh:mm a"
        cell.timeLabel.text = formatter.string(from: card.dateInCal!)
        cell.notesLabel.text = card.journalNotesCard?.notesText
        return cell
    }
    func setJournalMediaCardCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
         let cell = tableView.dequeueReusableCell(withIdentifier: "journalMediaTVC", for: indexPath) as! journalMediaTableViewCell
        cell.selectionStyle = .none
        cell.delegate=self
        cell.index = indexPath
        let formatter = DateFormatter()
        let card = cardsForSelectedDate[indexPath.row]
        formatter.dateStyle = .full
        cell.dateLabel.text = formatter.string(from: card.dateInCal!)
        formatter.dateFormat = "hh:mm a"
        cell.timeLabel.text = formatter.string(from: card.dateInCal!)
        cell.notesLabel.text = card.journalMediaCard?.notesText
//        if let data = card.journalMediaCard?.imageData {
        if let fileNames = card.journalMediaCard?.imageFileName{
            cell.imageFileNames = fileNames
        }
        cell.awakeFromNib()
        return cell
    }
    func setJournalLocationCardCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
             let cell = tableView.dequeueReusableCell(withIdentifier: "journalLocationTVC", for: indexPath) as! journalLocationTableViewCell
        cell.selectionStyle = .none
            cell.delegate=self
            cell.index = indexPath
            let formatter = DateFormatter()
            let card = cardsForSelectedDate[indexPath.row]
            formatter.dateStyle = .full
            cell.dateLabel.text = formatter.string(from: card.dateInCal!)
            formatter.dateFormat = "hh:mm a"
            cell.timeLabel.text = formatter.string(from: card.dateInCal!)
            cell.notesLabel.text = card.journalLocationCard?.notesText
        if let locs=card.journalLocationCard?.locationAnnotations, locs.count>0{
//            cell.mediaImageView.tintColor = UIColor.systemPink
            cell.mediaImageView.tintColor = UIColor(named: "calendarAccent") ?? UIColor.red
            cell.mediaImageView.image = UIImage(systemName: "location.fill")
        }else{
            cell.mediaImageView.tintColor = UIColor(named: "subMainTextColor") ?? UIColor.red
            cell.mediaImageView.image = UIImage(systemName: "location.slash")
        }
//            if let data = card.journalLocationCard?.locationData {
//                if let image = UIImage(data: data){
//                    cell.mediaImageView.image=image
//                }else{
//                    cell.mediaImageView.image=UIImage(systemName: "camera")
//                }
//            }else{
//                cell.mediaImageView.image=UIImage(systemName: "camera")
//            }
            return cell
        }
    func setJournalHabitCardCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalHabitsTVC", for: indexPath) as! journalHabitTableViewCell
        cell.selectionStyle = .none
        cell.delegate=self
        cell.index = indexPath
        let card = cardsForSelectedDate[indexPath.row]
//        let formatter = DateFormatter()
//        formatter.dateStyle = .full
//        cell.dateLabel.text = formatter.string(from: card.dateInCal!)
//        formatter.dateFormat = "hh:mm a"
//        cell.timeLabel.text = formatter.string(from: card.dateInCal!)
        if let habitcrd = card.habitCard{
            cell.timeLabel.text =  "Habit: "+habitcrd.title+" ("+habitcrd.habitGoalPeriod.rawValue+")"
            cell.notesLabel.text = "Entry Today: " + String(Int(habitcrd.entryCount))
        }
        return cell
    }
    func setKanbanCardCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
         let cell = tableView.dequeueReusableCell(withIdentifier: "kabanTableCell", for: indexPath) as! CardTableViewCell
        let card = cardsForSelectedDate[indexPath.row]
        cell.delegate=self
        cell.card = card.kanbanCard!
        cell.setupCard()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table.deselectRow(at: indexPath, animated: false)
    }
}


extension JournalViewController: addCardInJournalProtocol{
    func deleteJournalCard(at index: IndexPath) {
//        cardsForSelectedDate[index.row].journalMediaCard!.notesText=text
        var notFoundInjournalEntryCards=true
        for ind in journalEntryCards.indices{
            let card =  journalEntryCards[ind]
            if ((cardsForSelectedDate[index.row].journalNotesCard != nil) && card.journalNotesCard?.UniquIdentifier==cardsForSelectedDate[index.row].journalNotesCard?.UniquIdentifier) ||
                ((cardsForSelectedDate[index.row].journalMediaCard != nil) && card.journalMediaCard?.UniquIdentifier==cardsForSelectedDate[index.row].journalMediaCard?.UniquIdentifier) ||
                ((cardsForSelectedDate[index.row].journalLocationCard != nil) && card.journalLocationCard?.UniquIdentifier==cardsForSelectedDate[index.row].journalLocationCard?.UniquIdentifier)
                {
                print("found journal entry to delete: \(journalEntryCards[ind])")
                notFoundInjournalEntryCards=false
                journalEntryCards.remove(at: ind)
                break
            }
        }
        if notFoundInjournalEntryCards{
            print("ERROR: JOURNAL CARD TO DELETE NOT FOUND IN journalEntryCards")
            return
        }
        print("remove at index: \(index): \(cardsForSelectedDate[index.row])")
        cardsForSelectedDate.remove(at: index.row)
        self.setupData()
//        self.setupSelectedDate()
//        self.table.reloadData()
        self.table.beginUpdates()
        self.table.deleteRows(at: [index], with: .automatic)
        self.table.endUpdates()
    }
    
    
    func showJournalFullView(at index: IndexPath) {
        selectedCell=index.row
        self.performSegue(withIdentifier: "showJournalFullViewSegue", sender: self)
    }
    func updateJournalMediaCard(at index: IndexPath, with card: mediaJournalCard) {
        print("inside updateJournalMediaCard")
                 cardsForSelectedDate[index.row].journalMediaCard!=card
                for ind in journalEntryCards.indices{
                    let valcard =  journalEntryCards[ind]
                    if valcard.journalMediaCard?.UniquIdentifier==cardsForSelectedDate[index.row].journalMediaCard?.UniquIdentifier{
                        print("found place to set in journalEntryCards")
                        journalEntryCards[ind].journalMediaCard = card
                    }
                }
        //        self.setupData()
        //        self.setupSelectedDate()
                for ind in allCards.indices{
                    if allCards[ind].type == .journalMedia, allCards[ind].journalMediaCard?.UniquIdentifier==card.UniquIdentifier{
                        print("dound to update in allcard.jormedia")
                        allCards[ind].journalMediaCard = card
                    }
                }
                table.reloadRows(at: [index], with: .automatic)
    }
    
    func updateJournalNotesCard(at index: IndexPath, with card: noteJournalCard) {
        print("inside updateJournalNotesCard")
         cardsForSelectedDate[index.row].journalNotesCard!=card
        for ind in journalEntryCards.indices{
            let valcard =  journalEntryCards[ind]
            if valcard.journalNotesCard?.UniquIdentifier==cardsForSelectedDate[index.row].journalNotesCard?.UniquIdentifier{
                print("found place to set in journalEntryCards")
                journalEntryCards[ind].journalNotesCard = card
            }
        }
//        self.setupData()
//        self.setupSelectedDate()
        for ind in allCards.indices{
            if allCards[ind].type == .notes, allCards[ind].journalNotesCard?.UniquIdentifier==card.UniquIdentifier{
                allCards[ind].journalNotesCard = card
            }
        }
        table.reloadRows(at: [index], with: .automatic)
    }
    
    func addMediaCell() {
        print("inside addMediaCell")
        let card = journalCard(type: .journalMedia, dateInCal:  selectedDate, journalMediaCard: mediaJournalCard() )
        journalEntryCards.append(card)
        setupData()
        setupSelectedDate()
        print("no. of cards to show \(cardsForSelectedDate.count)")
        table.reloadData()
        for ind in cardsForSelectedDate.indices{
            let cr = cardsForSelectedDate[ind]
            if cr.journalNotesCard?.UniquIdentifier == card.journalNotesCard?.UniquIdentifier{
                table.scrollToRow(at: IndexPath(row: ind, section: 0), at: .middle, animated: true)
            }
        }
    }
    func updateJournalMediasNotesEntry(at index: IndexPath, with text: String) {
        print("inside updateJournalMediasNotesEntry \(text)")
        cardsForSelectedDate[index.row].journalMediaCard!.notesText=text
        for ind in journalEntryCards.indices{
            let card =  journalEntryCards[ind]
            if card.journalMediaCard?.UniquIdentifier==cardsForSelectedDate[index.row].journalMediaCard?.UniquIdentifier{
                journalEntryCards[ind].journalMediaCard?.notesText=text
            }
        }
        self.setupData()
        self.setupSelectedDate()
    }
    func getJournalMedia(at index: IndexPath) {
        print("get image")
//        var configuration = Configuration()
//        configuration.
        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 1
        imagePickerController.delegate = self
        self.index=index
        self.present(imagePickerController, animated: true, completion: nil)
        
        /*
        //MARK: currently stores only 1 image but later can be extended to multiple images as stored in a array
        let fileManager = FileManager.default
        JournalImagePickerManager().pickImage(self){ image in
            //Delete thr old image if any
            for ind in self.journalEntryCards.indices{
                let card =  self.journalEntryCards[ind]
                if card.journalMediaCard?.UniquIdentifier==self.cardsForSelectedDate[index.row].journalMediaCard?.UniquIdentifier{
                    if let fnms = self.journalEntryCards[ind].journalMediaCard?.imageFileName{
                        for fileName in fnms{
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
                                    //TODO: check if return works this way if file deletionf fails
                                    return
                                }
                            }
                        }
                    }
                    self.journalEntryCards[ind].journalMediaCard?.imageFileName.removeAll()
                }
            }
            
            
            //MARK: set a new json and use corrosponding url for new image
            let fileName=String.uniqueFilename(withPrefix: "iamgeData")+".json"
            DispatchQueue.global(qos: .background).async {
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
                            for ind in self.journalEntryCards.indices{
                                let card = self.journalEntryCards[ind]
                                //MARK: new url based implementation for images
                                if card.journalMediaCard?.UniquIdentifier==self.cardsForSelectedDate[index.row].journalMediaCard?.UniquIdentifier{
                                    self.journalEntryCards[ind].journalMediaCard?.imageFileName.append(fileName)
                                }
                            }
                            DispatchQueue.main.sync {
                                self.setupData()
                                self.setupSelectedDate()
                                self.table.reloadRows(at: [index], with: .automatic)
                                self.table.scrollToRow(at: index, at: .middle, animated: true)
                            }
                        } catch let error {
                            print ("couldn't save \(error)")
                        }
                    }
                }
            }
            
        }
        */
    }
    
    func addWrittenEntry() {
        print("inside addWrittenEntry")
        let card = journalCard(type: .notes, dateInCal: selectedDate,journalNotesCard: noteJournalCard())
        journalEntryCards.append(card)
        setupData()
        setupSelectedDate()
        print("no. of cards to show \(cardsForSelectedDate.count)")
        table.reloadData()
        for ind in cardsForSelectedDate.indices{
            let cr = cardsForSelectedDate[ind]
            if cr.journalNotesCard?.UniquIdentifier == card.journalNotesCard?.UniquIdentifier{
                table.scrollToRow(at: IndexPath(row: ind, section: 0), at: .middle, animated: true)
            }
        }
    }
    func updateJournalNotesEntry(at index: IndexPath, with text: String) {
        print("inside updateJournalNotesEntry \(text)")
        cardsForSelectedDate[index.row].journalNotesCard!.notesText=text
        for ind in journalEntryCards.indices{
            let card =  journalEntryCards[ind]
            if card.journalNotesCard?.UniquIdentifier==cardsForSelectedDate[index.row].journalNotesCard?.UniquIdentifier{
                journalEntryCards[ind].journalNotesCard?.notesText=text
            }
        }
        self.setupData()
        self.setupSelectedDate()
    }
    
    func addLocationEntry() {
        print("inside addLocationEntry")
        let card = journalCard(type: .journalLocation, dateInCal:  selectedDate, journalLocationCard: locationJournalCard())
        journalEntryCards.append(card)
        setupData()
        setupSelectedDate()
        print("no. of cards to show \(cardsForSelectedDate.count)")
        table.reloadData()
        for ind in cardsForSelectedDate.indices{
            let cr = cardsForSelectedDate[ind]
            if cr.journalLocationCard?.UniquIdentifier == card.journalLocationCard?.UniquIdentifier{
                table.scrollToRow(at: IndexPath(row: ind, section: 0), at: .middle, animated: true)
            }
        }
    }
    func updateJournalLocationNotesEntry(at index: IndexPath, with text: String) {
        print("inside updateJournalMediasNotesEntry \(text)")
        cardsForSelectedDate[index.row].journalLocationCard!.notesText=text
        for ind in journalEntryCards.indices{
            let card =  journalEntryCards[ind]
            if card.journalLocationCard?.UniquIdentifier==cardsForSelectedDate[index.row].journalLocationCard?.UniquIdentifier{
                journalEntryCards[ind].journalLocationCard?.notesText=text
            }
        }
        self.setupData()
        self.setupSelectedDate()
    }
    func getJournalLocation(at index: IndexPath){
        print("get journalLocation")
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "journalLocationPickerNavigationViewController")
        vc.modalPresentationStyle = .automatic
        //TODO: just useed here to avoide fault in ipad, to be changed and set appropriately later
//        vc.popoverPresentationController?.barButtonItem=toggleCalendarButton
        if let x = vc as? UINavigationController{
            print("is uinav controller")
            if let y = x.viewControllers.first as? journalLocationPickerViewController{
                print("insid journalLocationPickerViewController")
                y.delegate=self
                y.myIndex=index
                if let locs=cardsForSelectedDate[index.row].journalLocationCard?.locationAnnotations{
                    y.locationAnnotations=locs
                }
            }
        }
        present(vc, animated: true, completion:nil)
    }
    func setJournalLocation(at index: IndexPath, to locations: [CodableMKPointAnnotation]){
        for ind in journalEntryCards.indices{
            let card =  journalEntryCards[ind]
            if card.journalLocationCard?.UniquIdentifier==cardsForSelectedDate[index.row].journalLocationCard?.UniquIdentifier{
                journalEntryCards[ind].journalLocationCard?.locationAnnotations=locations
            }
        }
        self.setupData()
        self.setupSelectedDate()
        self.table.reloadRows(at: [index], with: .automatic)
    }
}
extension JournalViewController: CLLocationManagerDelegate,MKMapViewDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate

        mapView.mapType = MKMapType.standard

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)

        let annotation = CodableMKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "Javed Multani"
        annotation.subtitle = "current location"
        mapView.addAnnotation(annotation)

        //centerMap(locValue)
    }
}
extension JournalViewController: tableCardDeletgate{
    func updateHeights() {
        // Disabling animations gives us our desired behaviour
        UIView.setAnimationsEnabled(false)
        /* These will causes table cell heights to be recaluclated,
         without reloading the entire cell */
        table.beginUpdates()
        table.endUpdates()
        // Re-enable animations
        UIView.setAnimationsEnabled(true)
    }
    
    func updateCard(to newCard: KanbanCard) {
        print("won't do here")
    }
    
    func deleteCard(newCard: KanbanCard) {
        print("won't do here")
    }
    
    
}
extension JournalViewController: ImagePickerDelegate{
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("x")
        imagePicker.expandGalleryView()
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("y")
        if images.count<1 {
            imagePicker.dismiss(animated: true, completion: nil)
            return
        }
        //MARK: currently stores only 1 image but later can be extended to multiple images as stored in a array
        let fileManager = FileManager.default
        imagePicker.dismiss(animated: true) {
            //Delete thr old image if any
            for ind in self.journalEntryCards.indices{
                let card =  self.journalEntryCards[ind]
                if card.journalMediaCard?.UniquIdentifier==self.cardsForSelectedDate[self.index.row].journalMediaCard?.UniquIdentifier{
                    if let fnms = self.journalEntryCards[ind].journalMediaCard?.imageFileName{
                        for fileName in fnms{
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
                                    //TODO: check if return works this way if file deletionf fails
                                    return
                                }
                            }
                        }
                    }
                    self.journalEntryCards[ind].journalMediaCard?.imageFileName.removeAll()
                }
            }
            //MARK: set a new json and use corrosponding url for new image
            let fileName=String.uniqueFilename(withPrefix: "iamgeData")+".json"
            DispatchQueue.global(qos: .background).async {
                if let json = imageData(instData: (images[0].resizedTo1MB()!).pngData()!).json {
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
                            for ind in self.journalEntryCards.indices{
                                let card = self.journalEntryCards[ind]
                                //MARK: new url based implementation for images
                                if card.journalMediaCard?.UniquIdentifier==self.cardsForSelectedDate[self.index.row].journalMediaCard?.UniquIdentifier{
                                    self.journalEntryCards[ind].journalMediaCard?.imageFileName.append(fileName)
                                }
                            }
                            DispatchQueue.main.sync {
                                self.setupData()
                                self.setupSelectedDate()
                                self.table.reloadRows(at: [self.index], with: .automatic)
                                self.table.scrollToRow(at: self.index, at: .middle, animated: true)
                            }
                        } catch let error {
                            print ("couldn't save \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("z")
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
}
