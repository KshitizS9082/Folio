//
//  TimelineViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 13/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

protocol myUpdateCellHeightDelegate{
    func updated(height: CGFloat, row: Int, indexpath: IndexPath)
    func saveSmallCard(with card: SmallCard)
    func saveBigCard(with card: Card)
    func saveMediaCard(with card: MediaCard)
}

class TimelineViewController: UIViewController {
    var pageID: pageInfo?
    var page: PageData?
    var showingType = showingDataType.allCards
    var sizeType = cardSizeMode.full
    var cardsList = [timeLineCard]()
    var myViewController: SwitchPageTimelineViewController?
    
    @IBOutlet weak var table: UITableView!{
        didSet{
            table.separatorStyle = .none
        }
    }
    private func setCardsList(){
        cardsList = []
        if let page = page{
            switch showingType {
            case .allCards:
                page.bigCards.forEach { (card) in
                    cardsList.append(timeLineCard(type: .big, smallCard: nil, bigCard: card, mediaCard: nil))
                }
                page.smallCards.forEach { (card) in
                    cardsList.append(timeLineCard(type: .small, smallCard: card, bigCard: nil, mediaCard: nil))
                }
                page.mediaCards.forEach { (card) in
                    cardsList.append(timeLineCard(type: .media, smallCard: nil, bigCard: nil, mediaCard: card))
                }
            case .reminderCards:
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
            case .mediaTypes:
                page.mediaCards.forEach { (card) in
                    cardsList.append(timeLineCard(type: .media, smallCard: nil, bigCard: nil, mediaCard: card))
                }
//            default:
//                print("dunnow what type")
            }
        }
    }
    func setTable(){
        table.dataSource=self
        table.delegate=self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(UINib(nibName: "smallCardTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "titleTextCell")
        table.register(UINib(nibName: "SmallCardDatePickerTableViewCell", bundle: nil), forCellReuseIdentifier: "datePickerCell")
        table.register(UINib(nibName: "ScardTimelineTableViewCell", bundle: nil), forCellReuseIdentifier: "smallCardCell")
        table.register(UINib(nibName: "BigcardTimelineTableViewCell", bundle: nil), forCellReuseIdentifier: "bigCardCell")
        table.register(UINib(nibName: "MediaCardTableViewCell", bundle: nil), forCellReuseIdentifier: "mediaCardCell")
//        table.backgroundColor = pageColor
        table.backgroundColor =  UIColor(named: "myBackgroundColor") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        table.rowHeight = UITableView.automaticDimension
    }
    override func viewDidLoad() {
        setCardsList()
        setTable()
        table.reloadData()
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        view.addGestureRecognizer(pinch)
        //to dismiss keyboard
        let tap=UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        // register for notifications when the keyboard appears:
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
    
    func addTimelineCard(of type: cardType){
        switch type {
        case .small:
            let nc = SmallCard()
            //            self.page?.sma.append(bigCardData(card: nc, frame: CGRect(x: 10, y: 10, width: PageView().bigCardWidth, height: PageView().bigCardHeight), isHidden: true))
            self.page?.smallCards.append(smallCardData(card: nc, frame: CGRect(x: 10, y: 10, width: PageView().smallCardWidth, height: PageView().smallCardHeight), isHidden: true))
            viewDidLoad()
            for ind in cardsList.indices{
                if cardsList[ind].type == .small , cardsList[ind].smallCard?.card.UniquIdentifier==nc.UniquIdentifier{
                    table.scrollToRow(at: IndexPath(row: ind, section: 0), at: .middle, animated: true)
                    return
                }
            }
        case .big:
            let nc = Card()
            self.page?.bigCards.append(bigCardData(card: nc, frame: CGRect(x: 10, y: 10, width: PageView().bigCardWidth, height: PageView().bigCardHeight), isHidden: true))
            viewDidLoad()
            for ind in cardsList.indices{
                if cardsList[ind].type == .big , cardsList[ind].bigCard?.card.UniquIdentifier==nc.UniquIdentifier{
                    table.scrollToRow(at: IndexPath(row: ind, section: 0), at: .middle, animated: true)
                    return
                }
            }
        case .media:
            let nc = MediaCard()
            self.page?.mediaCards.append(mediaCardData(card: nc, frame: CGRect(x: 10, y: 10, width: PageView().mediaCardDimension, height: PageView().mediaCardDimension), isHidden: true))
            viewDidLoad()
            for ind in cardsList.indices{
                if cardsList[ind].type == .media , cardsList[ind].mediaCard?.card.UniquIdentifier==nc.UniquIdentifier{
                    table.scrollToRow(at: IndexPath(row: ind, section: 0), at: .middle, animated: true)
                    return
                }
            }
        }
    }
    
    func save() {
        print("attempting to save page")
        if let json = page?.json {
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(pageID!.fileName){
                do {
                    try json.write(to: url)
                    print ("saved successfully")
                } catch let error {
                    print ("couldn't save \(error)")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("inside viewwill appear")
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent(pageID!.fileName){
//            print("trying to extract contents of jsonData")
            if let jsonData = try? Data(contentsOf: url){
                page = PageData(json: jsonData)
            }
            viewDidLoad()
        }
    }
    
    @objc func keyboardWillShow( note:NSNotification ){
        // read the CGRect from the notification (if any)
        if let newFrame = (note.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height, right: 0 )
            table.contentInset = insets
            table.scrollIndicatorInsets = insets
        }
    }
}

extension TimelineViewController{
    var pageColor: UIColor{
        UIColor(named: "myBackgroundColor") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//        return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//        return #colorLiteral(red: 0.9411764706, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
    }
    var mediaCardCellColor: UIColor{
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
//        return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}
extension TimelineViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cardsList[indexPath.row].type {
        case .small:
            return setSmallCardCell(tableView, cellForRowAt: indexPath)
        case .big:
            return setBigCardCell(tableView, cellForRowAt: indexPath)
        case .media:
            return setMediaCardCell(tableView, cellForRowAt: indexPath)
//        default:
//            print("i dunno what card this is")
        }
//        return UITableViewCell()
    }
    func setSmallCardCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "smallCardCell", for: indexPath) as! ScardTimelineTableViewCell
//        cell.updateCardDelegate=self
        cell.delegate=self
        cell.showLinkDelegate = myViewController
        cell.sizeType = self.sizeType
        cell.indexpath = indexPath
        cell.row = indexPath.row
        cell.backgroundColor = .clear
        cell.card=cardsList[indexPath.row].smallCard?.card
        if let done = cell.card?.isDone{
            cell.isDone = done
        }
        if let hid = cardsList[indexPath.row].smallCard?.isHidden{
            if hid{
                cell.linkView.tintColor = .systemGray
            }else{
                cell.linkView.tintColor = .systemBlue
            }
        }
        cell.awakeFromNib()
        return cell
    }
    func setBigCardCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "bigCardCell", for: indexPath) as! BigcardTimelineTableViewCell
        cell.delegate=self
//        cell.updateCardDelegate=self
        cell.showLinkDelegate=myViewController
        cell.sizeType = self.sizeType
        cell.indexpath=indexPath
        cell.row = indexPath.row
        cell.backgroundColor = .clear
        cell.card=cardsList[indexPath.row].bigCard?.card
        if let hid = cardsList[indexPath.row].bigCard?.isHidden{
            if hid{
                cell.linkView.tintColor = .systemGray
            }else{
                cell.linkView.tintColor = .systemBlue
            }
        }
        cell.awakeFromNib()
        return cell
    }
    func setMediaCardCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "mediaCardCell", for: indexPath) as! MediaCardTableViewCell
        //reload data added to remove a bug where previous cell without image deleted in page view and new cell with image added would result in crash DO NOT REMOVE!!
        cell.collectionView.reloadData()
        cell.showLinkDelegate=myViewController
        cell.card=cardsList[indexPath.row].mediaCard?.card
        cell.backgroundColor=mediaCardCellColor
        cell.delegate=self
        cell.indexpath=indexPath
        cell.row=indexPath.row
        cell.sizeType=self.sizeType
        if let hid = cardsList[indexPath.row].mediaCard?.isHidden{
            if hid{
                cell.linkView.tintColor = .systemGray
            }else{
                cell.linkView.tintColor = .systemBlue
            }
        }
        cell.awakeFromNib()
        return cell
    }
}
extension TimelineViewController: myUpdateCellHeightDelegate{
    func saveBigCard(with card: Card) {
        let uniqueID = card.UniquIdentifier
        if let cardDatas = page?.bigCards{
            for ind in cardDatas.indices{
                if cardDatas[ind].card.UniquIdentifier==uniqueID{
                    print("found the place to save to")
                    page?.bigCards[ind].card = card
                }
            }
        }
    }
    //TODO: see if ever calls
    func saveMediaCard(with card: MediaCard) {
        let uniqueID = card.UniquIdentifier
        if let cardDatas = page?.mediaCards{
            for ind in cardDatas.indices{
                if cardDatas[ind].card.UniquIdentifier==uniqueID{
                    print("found the place to save to nv = \(card)")
                    page?.mediaCards[ind].card = card
                }
            }
        }
    }
    
    func saveSmallCard(with card: SmallCard) {
        let uniqueID = card.UniquIdentifier
        if let cardDatas = page?.smallCards{
            for ind in cardDatas.indices{
                if cardDatas[ind].card.UniquIdentifier==uniqueID{
                    page?.smallCards[ind].card = card
                }
            }
        }
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

struct timeLineCard {
    var type = cardType.small
    var smallCard: smallCardData?
    var bigCard: bigCardData?
    var mediaCard: mediaCardData?
    //used for segue from PageExtractViewController to switchPageTimelineVC
    var pageID: pageInfo?
}
enum showingDataType {
    case allCards
    case reminderCards
    case mediaTypes
}
enum cardSizeMode{
    case full
    case medium
    case small
}
enum cardType: String{
    case small
    case big
    case media
}
