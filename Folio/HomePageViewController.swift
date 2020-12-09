//
//  HomePageViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 03/12/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
//extension UIImageView {
//    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
//        containerView.clipsToBounds = false
//        containerView.layer.shadowColor = UIColor.black.cgColor
//        containerView.layer.shadowOpacity = 1
//        containerView.layer.shadowOffset = CGSize.zero
//        containerView.layer.shadowRadius = 10
//        containerView.layer.cornerRadius = cornerRadious
//        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
//        self.clipsToBounds = true
//        self.layer.cornerRadius = cornerRadious
//    }
//}
class HomePageViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!{
        didSet{
            backgroundImageView.addBlurEffect(with: .systemUltraThinMaterial)
        }
    }
    
    @IBOutlet weak var segmentBackgroundView: UIView!{
        didSet{
            segmentBackgroundView.layer.cornerRadius = 20
            segmentBackgroundView.layer.masksToBounds=false
            segmentBackgroundView.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = segmentBackgroundView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.layer.cornerRadius = segmentBackgroundView.layer.cornerRadius
            blurEffectView.layer.masksToBounds=true
            segmentBackgroundView.addSubview(blurEffectView)
            segmentBackgroundView.sendSubviewToBack(blurEffectView)
        }
    }
    
    @IBOutlet var segmentButtons: [UIButton]!
    var selectedSegment=0
    @IBOutlet weak var selectedSegmentIndicatorView: UIView!{
        didSet{
            selectedSegmentIndicatorView.layer.cornerRadius = 20
            selectedSegmentIndicatorView.layer.masksToBounds=true
            selectedSegmentIndicatorView.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.prominent)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = selectedSegmentIndicatorView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            selectedSegmentIndicatorView.addSubview(blurEffectView)
        }
    }
    @IBOutlet weak var selectedSegmentIndicatorCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectedSegmentIndicatorCenterXConstraint: NSLayoutConstraint!
    @IBAction func segmentButtonSelected(_ sender: UIButton) {
        self.selectedSegment=segmentButtons.lastIndex(of: sender)!
        print("selected index: \(self.selectedSegment)")
        self.selectedSegmentIndicatorCenterXConstraint.isActive=false
        let newConstr = self.selectedSegmentIndicatorView.centerXAnchor.constraint(equalTo: self.segmentButtons[self.selectedSegment].centerXAnchor)
        newConstr.isActive=true
        self.selectedSegmentIndicatorCenterXConstraint=newConstr
        for ind in self.segmentButtons.indices{
            if ind == self.selectedSegment{
                segmentButtons[ind].alpha=1
            }else{
                segmentButtons[ind].alpha=0.35
            }
        }
        if self.selectedSegment==0{
            loadKanbanBoards()
        }else if self.selectedSegment==1{
            loadWallet()
        }else if self.selectedSegment==3{
            loadHabitCards()
        }else if self.selectedSegment==3{
            loadJournalCards()
        }
        animateSetup()
    }
    
    @IBOutlet weak var bubbleOne: UIImageView!{
        didSet{
            bubbleOne.layer.cornerRadius=bubbleOne.frame.width/2.0
            bubbleOne.addBlurEffect(with: .systemUltraThinMaterial)
//            bubbleOne.applyshadowWithCorner(containerView: bubbleOne, cornerRadious: bubbleOne.frame.width/2.0)
        }
    }
    @IBOutlet weak var bubbleOneContainer: UIView!{
        didSet{
//            bubbleOneContainer.backgroundColor = .clear
            bubbleOneContainer.layer.cornerRadius=bubbleOneContainer.frame.width/2.0
            //Draw shaddow for layer
            bubbleOneContainer.layer.shadowColor = #colorLiteral(red: 0.5039077985, green: 0.2100836635, blue: 0.2754305899, alpha: 1).cgColor
            bubbleOneContainer.layer.shadowOffset = CGSize(width: 10.0, height: 15)
            bubbleOneContainer.layer.shadowRadius = 18.0
            bubbleOneContainer.layer.shadowOpacity = 0.35
        }
    }
    
    @IBOutlet weak var bubbleOneShadow: UIImageView!{
        didSet{
            bubbleOneShadow.layer.cornerRadius=bubbleOneShadow.frame.width/2.0
            bubbleOneShadow.addBlurEffect(with: .systemUltraThinMaterial)
//            bubbleOne.applyshadowWithCorner(containerView: bubbleOne, cornerRadious: bubbleOne.frame.width/2.0)
        }
    }
    @IBOutlet weak var subBubOneOne: UIView!{
        didSet{
            subBubOneOne.backgroundColor = #colorLiteral(red: 0.6126989722, green: 0.2192376256, blue: 0.2806146145, alpha: 0.4727003085)
            subBubOneOne.layer.cornerRadius=subBubOneOne.frame.height/2.0
            subBubOneOne.addBlurEffect(with: .systemThinMaterial)
        }
    }
    @IBOutlet weak var oneOneLabel: UILabel!{
        didSet{
            oneOneLabel.layer.cornerRadius=oneOneLabel.frame.height/2.0
        }
    }
    @IBOutlet weak var subBubOneTwo: UIView!{
        didSet{
            subBubOneTwo.backgroundColor = #colorLiteral(red: 0.4769539237, green: 0.2728464603, blue: 0.3283729553, alpha: 0.5333660202)
            subBubOneTwo.layer.cornerRadius=subBubOneTwo.frame.height/2.0
            subBubOneTwo.addBlurEffect(with: .systemThinMaterial)
        }
    }
    @IBOutlet weak var oneTwoLabel: UILabel!{
        didSet{
            oneTwoLabel.layer.cornerRadius=oneTwoLabel.frame.height/2.0
        }
    }
    @IBOutlet weak var subBubOneThree: UIView!{
        didSet{
            subBubOneThree.backgroundColor = #colorLiteral(red: 0.3883536756, green: 0.2989271879, blue: 0.3512608409, alpha: 0.4925274375)
            subBubOneThree.layer.cornerRadius=subBubOneThree.frame.height/2.0
            subBubOneThree.addBlurEffect(with: .systemThinMaterial)
        }
    }
    @IBOutlet weak var oneThreeLabel: UILabel!{
        didSet{
            oneThreeLabel.layer.cornerRadius=oneThreeLabel.frame.height/2.0
        }
    }
    @IBOutlet weak var bubbleOneLabel: UILabel!
    @IBOutlet weak var bubbleOneSubLabel: UILabel!
    @IBOutlet weak var bubbleOneLeadingConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var bubbleTwoContainer: UIView!{
        didSet{
//            bubbleOneContainer.backgroundColor = .clear
            bubbleTwoContainer.layer.cornerRadius=bubbleTwoContainer.frame.width/2.0
            //Draw shaddow for layer
            bubbleTwoContainer.layer.shadowColor = #colorLiteral(red: 0.4481569647, green: 0.4288250172, blue: 0.5929355621, alpha: 1).cgColor
            bubbleTwoContainer.layer.shadowOffset = CGSize(width: -3, height: 35)
            bubbleTwoContainer.layer.shadowRadius = 30.0
            bubbleTwoContainer.layer.shadowOpacity = 0.65
        }
    }
    @IBOutlet weak var bubbleTwo: UIImageView!{
        didSet{
            bubbleTwo.layer.cornerRadius=bubbleTwo.frame.width/2.0
//            bubbleTwo.addBlurEffect(with: .systemUltraThinMaterial)
        }
    }
    @IBOutlet weak var bubbleTwoShadow: UIImageView!{
        didSet{
            bubbleTwoShadow.layer.cornerRadius=bubbleTwoShadow.frame.width/2.0
            bubbleTwoShadow.addBlurEffect(with: .systemUltraThinMaterial)
        }
    }
    @IBOutlet weak var subBubTwoOne: UIView!{
        didSet{
            subBubTwoOne.backgroundColor = #colorLiteral(red: 0.7734910846, green: 0.5028807521, blue: 0.7306686044, alpha: 0.5197318374)
            subBubTwoOne.layer.cornerRadius=subBubTwoOne.frame.height/2.0
            subBubTwoOne.addBlurEffect(with: .systemThinMaterial)
        }
    }
    @IBOutlet weak var subBubTwoTwo: UIView!{
        didSet{
            subBubTwoTwo.backgroundColor = #colorLiteral(red: 0.6391574144, green: 0.635892272, blue: 0.8690081239, alpha: 0.5820263995)
            subBubTwoTwo.layer.cornerRadius=subBubTwoTwo.frame.height/2.0
            subBubTwoTwo.addBlurEffect(with: .systemThinMaterial)
        }
    }
    @IBOutlet weak var bubbleTwoLabel: UILabel!
    @IBOutlet weak var bubbleTwoSubLabel: UILabel!
    @IBOutlet weak var subBubTwoOneLabel: UILabel!
    @IBOutlet weak var bubbleTwoTwoLabel: UILabel!
    @IBOutlet weak var bubbleTwoLeadingConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var bubbleThree: UIImageView!{
        didSet{
            bubbleThree.layer.cornerRadius=bubbleThree.frame.width/2.0
//            bubbleTwo.addBlurEffect(with: .systemUltraThinMaterial)
        }
    }
    @IBOutlet weak var bubbleThreeShadow: UIImageView!{
        didSet{
            bubbleThreeShadow.layer.cornerRadius=bubbleThreeShadow.frame.width/2.0
            bubbleThreeShadow.addBlurEffect(with: .systemUltraThinMaterial)
        }
    }
    @IBOutlet weak var bubbleThreeShadowTwo: UIImageView!{
        didSet{
            bubbleThreeShadowTwo.layer.cornerRadius=bubbleThreeShadowTwo.frame.width/2.0
            bubbleThreeShadowTwo.addBlurEffect(with: .systemUltraThinMaterial)
        }
    }
    @IBOutlet weak var subBubThreeOne: UIView!{
        didSet{
            subBubThreeOne.backgroundColor = #colorLiteral(red: 0.2910746932, green: 0.6548274159, blue: 0.6268165708, alpha: 0.5178142825)
            subBubThreeOne.layer.cornerRadius=subBubThreeOne.frame.height/2.0
            subBubThreeOne.addBlurEffect(with: .systemThinMaterial)
        }
    }
    @IBOutlet weak var subBubThreeTwo: UIView!{
        didSet{
            subBubThreeTwo.backgroundColor = #colorLiteral(red: 0.2842479944, green: 0.4911205173, blue: 0.6787464619, alpha: 0.53)
            subBubThreeTwo.layer.cornerRadius=subBubThreeTwo.frame.height/2.0
            subBubThreeTwo.addBlurEffect(with: .systemThinMaterial)
        }
    }
    @IBOutlet weak var bubbleThreeContainer: UIView!{
        didSet{
//            bubbleOneContainer.backgroundColor = .clear
            bubbleThreeContainer.layer.cornerRadius=bubbleThreeContainer.frame.width/2.0
            //Draw shaddow for layer
            bubbleThreeContainer.layer.shadowColor = #colorLiteral(red: 0.1764553137, green: 0.3516730533, blue: 0.4293856982, alpha: 1).cgColor
            bubbleThreeContainer.layer.shadowOffset = CGSize(width: 0, height: 15)
            bubbleThreeContainer.layer.shadowRadius = 18.0
            bubbleThreeContainer.layer.shadowOpacity = 0.3
        }
    }
    @IBOutlet weak var bubbleThreeLabel: UILabel!
    @IBOutlet weak var bubbleThreeOneLabel: UILabel!
    @IBOutlet weak var bubbleThreeTwoLabel: UILabel!
    @IBOutlet weak var bubbleThreeSubLabel: UILabel!
    @IBOutlet weak var bubbleThreeLeadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadKanbanBoards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 30)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        self.subBubOneOne.isHidden=true
        self.subBubOneTwo.isHidden=true
        self.subBubOneThree.isHidden=true
        self.subBubTwoOne.isHidden=true
        self.subBubTwoTwo.isHidden=true
        self.subBubThreeOne.isHidden=true
        self.subBubThreeTwo.isHidden=true
        self.setupKanbanBubbles()
    }
    
    func animateSetup(){
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
            self.bubbleOneLeadingConstraint.constant=self.bubbleOneLeadingConstraint.constant-self.backgroundImageView.frame.width
            self.bubbleTwoLeadingConstraint.constant=self.bubbleTwoLeadingConstraint.constant+self.backgroundImageView.frame.width
            self.bubbleThreeLeadingConstraint.constant=self.backgroundImageView.frame.width+self.bubbleThreeLeadingConstraint.constant
            self.view.layoutIfNeeded()
        } completion: { (bl) in
            self.subBubOneOne.isHidden=true
            self.subBubOneTwo.isHidden=true
            self.subBubOneThree.isHidden=true
            self.subBubTwoOne.isHidden=true
            self.subBubTwoTwo.isHidden=true
            self.subBubThreeOne.isHidden=true
            self.subBubThreeTwo.isHidden=true
            if self.selectedSegment==0{
                self.setupKanbanBubbles()
            }else if self.selectedSegment==1{
                self.setupWalletBubbles()
            }else if self.selectedSegment==2{
                self.setupHabitBubbles()
            }else if self.selectedSegment==3{
                self.setupJournalBubbles()
            }
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
                self.bubbleOneLeadingConstraint.constant=self.bubbleOneLeadingConstraint.constant+self.backgroundImageView.frame.width
                self.bubbleTwoLeadingConstraint.constant=self.bubbleTwoLeadingConstraint.constant-self.backgroundImageView.frame.width
                self.bubbleThreeLeadingConstraint.constant=self.bubbleThreeLeadingConstraint.constant-self.backgroundImageView.frame.width
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
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
    func setupKanbanBubbles(){
        var tasksCounts = [(String,Int)]()
        var taskTimes = [(String,Date)]()
        var taskMissed = [(String,Date)]()
        var totalCount = 0
        for tup in boards{
            let boardName = tup.0
            let kanbanInfo = tup.1
            var count=0
            for board in kanbanInfo.boards{
                count=0
                for item in board.items{
                    if let isComplete = item.isTask, isComplete==false{
                        count+=1
                    }
                    if let date = item.scheduledDate, Calendar.current.isDateInToday(date){
                        taskTimes.append((item.title, date))
                    }
                    if let isComplete = item.isTask, let date = item.scheduledDate, isComplete==false, date<Date() {
                        taskMissed.append((item.title, date))
                    }
                }
                tasksCounts.append((boardName,count))
                totalCount+=count
            }
        }
        
        //All incomplete tasks
        bubbleOneLabel.text="Tasks"
        bubbleOneSubLabel.text=String(totalCount)
        tasksCounts.sort { (first, second) -> Bool in
            return first.1>second.1
        }
        if tasksCounts.count>0, tasksCounts[0].1>0{
            subBubOneOne.isHidden=false
            oneOneLabel.text="\(tasksCounts[0].0) : \(tasksCounts[0].1)"
            if tasksCounts.count>1, tasksCounts[1].1>0{
                subBubOneTwo.isHidden=false
                oneTwoLabel.text="\(tasksCounts[1].0) : \(tasksCounts[1].1)"
                if tasksCounts.count>2, tasksCounts[2].1>0{
                    subBubOneThree.isHidden=false
                    oneThreeLabel.text="\(tasksCounts[2].0) : \(tasksCounts[2].1)"
                }
            }
        }
        
        //Events today
        bubbleTwoLabel.text="Today"
        bubbleTwoSubLabel.text = String(taskTimes.count)
        taskTimes.sort { (first, second) -> Bool in
            return first.1<second.1
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        if taskTimes.count>0{
            subBubTwoOne.isHidden=false
            subBubTwoOneLabel.text = "\(formatter.string(from: taskTimes[0].1)) : \(taskTimes[0].0)"
        }
        if taskTimes.count>1{
            subBubTwoTwo.isHidden=false
            bubbleTwoTwoLabel.text = "\(formatter.string(from: taskTimes[1].1)) : \(taskTimes[1].0)"
        }
        
        //Missed
        bubbleThreeLabel.text="Missed"
        formatter.dateStyle = .short
        bubbleThreeSubLabel.text = String(taskMissed.count)
        taskMissed.sort { (first, second) -> Bool in
            return first.1<second.1
        }
        if taskMissed.count>0{
            subBubThreeOne.isHidden=false
            bubbleThreeOneLabel.text="\(formatter.string(from: taskMissed[0].1)) : \(taskMissed[0].0)"
        }
        if taskMissed.count>1{
            subBubThreeTwo.isHidden=false
            bubbleThreeTwoLabel.text="\(formatter.string(from: taskMissed.last!.1)) : \(taskMissed.last!.0)"
        }
        
    }
    
    var journalEntryCards = [journalCard]()
    func loadJournalCards(){
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("journalCards.json"){
            if let jsonData = try? Data(contentsOf: url){
                if let extract = journalCardList(json: jsonData){
                    self.journalEntryCards = extract.jCards
                }else{
                    print("ERROR: found PageData(json: jsonData) to be nil so didn't set it")
                }
            }else{
                print("error no file named journalCards.json found")
            }
        }
    }
    func setupJournalBubbles(){
        var noteCards = [(String,Date)]()
        var mediaCards = [(mediaJournalCard,Date)]()
        var locationCount = 0
        for card in journalEntryCards{
            if Calendar.current.isDayInCurrentWeek(date: card.dateInCal!)!{
                if card.type == .notes{
                    noteCards.append((card.journalNotesCard!.notesText, card.dateInCal!))
                }else if card.type == .journalMedia{
                    mediaCards.append((card.journalMediaCard!, card.dateInCal!))
                }else if card.type == .journalLocation{
                    locationCount+=1
                }
            }
        }
        noteCards.sort { (first, second) -> Bool in
            return first.1>second.1
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        //Overview this week
        subBubOneOne.isHidden=false
        subBubOneTwo.isHidden=false
        subBubOneThree.isHidden=false
        bubbleOneLabel.text="This Week"
        bubbleOneSubLabel.text=String(noteCards.count+mediaCards.count+locationCount)
        oneOneLabel.text="Notes: \(noteCards.count)"
        oneTwoLabel.text="Media: \(mediaCards.count)"
        oneThreeLabel.text="Locations: \(locationCount)"
        
        //Notes bubble
        bubbleTwoLabel.text="Notes"
        bubbleTwoSubLabel.text=String(noteCards.count)
        if noteCards.count>0{
            subBubTwoOne.isHidden=false
            subBubTwoOneLabel.text="\(formatter.string(from: noteCards[0].1)) : \(noteCards[0].0)"
        }
        if noteCards.count>1{
            subBubTwoTwo.isHidden=false
            bubbleTwoTwoLabel.text="\(formatter.string(from: noteCards[1].1)) : \(noteCards[1].0)"
        }
        //Media Bubble
        bubbleThreeLabel.text="Media"
        bubbleThreeSubLabel.text=String(mediaCards.count)
        if mediaCards.count>0{
            subBubThreeOne.isHidden=false
            bubbleThreeOneLabel.text="\(formatter.string(from: mediaCards[0].1)) : \(mediaCards[0].0.notesText)"
        }
        if mediaCards.count>1{
            subBubThreeTwo.isHidden=false
            bubbleThreeTwoLabel.text="\(formatter.string(from: mediaCards[1].1)) : \(mediaCards[1].0.notesText)"
        }
    }
    
    var walletData = WalletData()
    func loadWallet(){
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("walletData.json"){
            if let jsonData = try? Data(contentsOf: url){
                if let extract = WalletData(json: jsonData){
                    self.walletData = extract
                }else{
                    print("ERROR: found WalletData(json: jsonData) to be nil so didn't set it")
                }
            }else{
                print("error no file named walletData.json found")
            }
        }
    }
    func setupWalletBubbles(){
        var monthIncome=Float(0.0)
        var monthExpense=Float(0.0)
        var weekIncome=Float(0.0)
        var weekExpense=Float(0.0)
        var totalIncome=Float(0.0)
        var totalExpense=Float(0.0)
        var currentBalance=walletData.initialBalance
        for entryListPair in Array(walletData.entries){
            let entryList = entryListPair.value
            for entry in entryList{
                currentBalance+=entry.value
                if entry.value<Float(0.0){
                    totalExpense+=entry.value
                }else{
                    totalIncome+=entry.value
                }
                if entry.date.isInThisWeek{
                    if entry.value<Float(0.0){
                        weekExpense+=entry.value
                    }else{
                        weekIncome+=entry.value
                    }
                }
                if entry.date.isInThisMonth && entry.date.isInThisYear{
                    if entry.value<Float(0.0){
                        monthExpense+=entry.value
                    }else{
                        monthIncome+=entry.value
                    }
                }
            }
        }
        
        subBubOneOne.isHidden=false
        subBubOneTwo.isHidden=false
        subBubOneThree.isHidden=false
        bubbleOneLabel.text="All-Time"
        let locale = Locale.current
        bubbleOneSubLabel.text="\(locale.currencySymbol!)(\(locale.currencyCode!))"
        oneOneLabel.text="Balance: \(currentBalance)"
        oneTwoLabel.text="Income: \(totalIncome)"
        oneThreeLabel.text="Expense: \(totalExpense)"
        
        subBubTwoOne.isHidden=false
        subBubTwoTwo.isHidden=false
        bubbleTwoLabel.text="Week"
        bubbleTwoSubLabel.text=String(weekIncome+weekExpense)
        subBubTwoOneLabel.text="Income: \(String(weekIncome))"
        bubbleTwoTwoLabel.text="Expense: \(String(weekExpense))"
        
        subBubThreeOne.isHidden=false
        subBubThreeTwo.isHidden=false
        bubbleThreeLabel.text="Months"
        bubbleThreeSubLabel.text=String(monthIncome+monthExpense)
        bubbleThreeOneLabel.text="Income: \(String(monthIncome))"
        bubbleThreeTwoLabel.text="Expense: \(String(monthExpense))"
        
    }
    
    var habits = HabitsData()
    func loadHabitCards(){
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("habitCardsData.json"){
            if let jsonData = try? Data(contentsOf: url){
                if let extract = HabitsData(json: jsonData){
                    self.habits = extract
                }else{
                    print("ERROR: found HabitsData(json: jsonData) to be nil so didn't set it")
                }
            }else{
                print("error no file named habitCardsData.json found")
            }
        }
    }
    func setupHabitBubbles(){
        var todayCards = [habitCardData]()
        var thisWeekCards = [habitCardData]()
        var thisMonthCards = [habitCardData]()
        for card in habits.cardList{
            switch card.habitGoalPeriod {
            case .daily:
                todayCards.append(card)
            case .weekly:
                thisWeekCards.append(card)
            case .monthly:
                thisMonthCards.append(card)
            default:
                print("not to show goalperiod")
            }
        }
        
        bubbleOneLabel.text="Habits"
        bubbleOneSubLabel.text=String(habits.cardList.count)
        subBubOneOne.isHidden=false
        oneOneLabel.text="Today: \(todayCards.count)"
        oneTwoLabel.isHidden=false
        oneTwoLabel.text="This Week: \(thisWeekCards.count)"
        oneThreeLabel.isHidden=false
        oneThreeLabel.text="This Month: \(thisMonthCards.count)"
        
        bubbleTwoLabel.text="Daily"
        bubbleTwoSubLabel.text=String(todayCards.count)
        if todayCards.count>0{
            subBubTwoOne.isHidden=false
            subBubTwoOneLabel.text=calculateHabitCompleted(habitData: todayCards[0])
        }
        if todayCards.count>1{
            subBubTwoTwo.isHidden=false
            bubbleTwoTwoLabel.text=calculateHabitCompleted(habitData: todayCards[1])
        }
        
        bubbleThreeLabel.text="This Week"
        bubbleThreeSubLabel.text=String(thisWeekCards.count)
        if thisWeekCards.count>0{
            subBubThreeOne.isHidden=false
            bubbleThreeOneLabel.text=calculateHabitCompleted(habitData: thisWeekCards[0])
        }
        if thisWeekCards.count>1{
            subBubThreeTwo.isHidden=false
            bubbleThreeTwoLabel.text=calculateHabitCompleted(habitData: thisWeekCards[1])
        }
        
    }
    func completed(habitData: habitCardData) -> Bool{
        var date = Date()
        switch habitData.habitGoalPeriod {
        case .daily:
            date=date.startOfDay
        case .weekly:
            date=date.startOfWeek
        case .monthly:
            date=date.startOfMonth
        case .yearly:
            date=date.startOfYear
//        default:
//            print("ERROR: UNKNOWN HABITGOALPERIOD IN HABITTABLEVIEWCELL")
        }
        let currentCount=habitData.entriesList[date] ?? 0
        return currentCount > habitData.goalCount || currentCount.isEqual(to: habitData.goalCount)
    }
    func calculateHabitCompleted( habitData: habitCardData) -> String{
        var date = Date()
        var returnStr = ""
        switch habitData.habitGoalPeriod {
        case .daily:
            returnStr = "Today: "
            date=date.startOfDay
        case .weekly:
            returnStr = "This Week: "
            date=date.startOfWeek
        case .monthly:
            returnStr = "This Month: "
            date=date.startOfMonth
        case .yearly:
            returnStr = "This Year: "
            date=date.startOfYear
//        default:
//            print("ERROR: UNKNOWN HABITGOALPERIOD IN HABITTABLEVIEWCELL")
//            returnStr = ""
        }
        //TODO: calculate count
        let currentCount=habitData.entriesList[date] ?? 0
        returnStr += String(Int(currentCount)) + " / " + String(Int(habitData.goalCount))
        
        return returnStr
    }

}
