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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadKanbanBoards()
        setupKanbanBubbles()
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
//        var tasksCounts = [String,[KanbanCard]]()
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
                }else{
                    subBubOneThree.isHidden=true
                }
            }else{
                subBubOneTwo.isHidden=true
                subBubOneThree.isHidden=true
            }
            
        }else{
            subBubOneOne.isHidden=true
            subBubOneTwo.isHidden=true
            subBubOneThree.isHidden=true
        }
        
        //Events today
        bubbleTwoSubLabel.text = String(taskTimes.count)
        taskTimes.sort { (first, second) -> Bool in
            return first.1<second.1
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        subBubTwoOne.isHidden=true
        subBubTwoTwo.isHidden=true
        if taskTimes.count>0{
            subBubTwoOne.isHidden=false
            subBubTwoOneLabel.text = "\(formatter.string(from: taskTimes[0].1)) : \(taskTimes[0].0)"
        }
        if taskTimes.count>1{
            subBubTwoTwo.isHidden=false
            bubbleTwoTwoLabel.text = "\(formatter.string(from: taskTimes[1].1)) : \(taskTimes[1].0)"
        }
        
        //Missed
        formatter.dateStyle = .short
        bubbleThreeSubLabel.text = String(taskMissed.count)
        taskMissed.sort { (first, second) -> Bool in
            return first.1<second.1
        }
        subBubThreeOne.isHidden=true
        subBubThreeTwo.isHidden=true
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
