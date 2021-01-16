//
//  CardTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 12/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//


import UIKit
protocol cardPreviewProtocol {
    func saveCard(to newCard: KanbanCard)
    func deleteCard(newCard: KanbanCard)
}
class CardTableViewCell: UITableViewCell {
    var card = KanbanCard()
    var row: Int?
    var delegate: tableCardDeletgate?
    
    @IBOutlet var previewVerSpacingConstraints: [NSLayoutConstraint]!
    @IBOutlet weak var previewIVHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var taskViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var taskSymbolImage: UIImageView!
    @IBOutlet weak var taskStatusLabel: UILabel!
    
    
    @IBOutlet weak var tagColorView: UIView!
    @IBOutlet weak var tagColorViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var checkListLabel: UILabel!
    @IBOutlet weak var calendarPreviewSymbol: UIImageView!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var reminderPreviewSymbol: UIImageView!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var linkPreviewSymbol: UIImageView!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!{
        didSet{
            previewImageView.layer.cornerRadius = 6
        }
    }
    @IBOutlet weak var imageCountIV: UIImageView!
    
    @IBOutlet weak var cardBackgroundView: UIView!{
        didSet{
//            cardBackgroundView.layer.cornerRadius=5
//            //Draw shaddow for layer
//            cardBackgroundView.layer.shadowColor = UIColor.gray.cgColor
//            cardBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.3)
//            cardBackgroundView.layer.shadowRadius = 0.7
//            cardBackgroundView.layer.shadowOpacity = 0.4
            
            cardBackgroundView.layer.cornerRadius = 10
            cardBackgroundView.layer.masksToBounds=true
            cardBackgroundView.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemChromeMaterial)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = cardBackgroundView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cardBackgroundView.addSubview(blurEffectView)
            cardBackgroundView.sendSubviewToBack(blurEffectView)
        }
    }
    @IBOutlet weak var titleTextView: UITextView!{
        didSet{
            titleTextView.delegate=self
        }
    }
    
    @IBOutlet var previewImageViews: [UIImageView]!
    
    @IBAction func handlePreviewButtonClick(_ sender: UIButton) {
        card.showingPreview = !card.showingPreview
        setupCard()
        delegate?.updateCard(to: self.card)
        self.delegate?.updateHeights()
        print("updated heights, calendarPreviewSymbol= \(String(describing: calendarPreviewSymbol)) ")
    }
    func setupCard(){
        titleTextView.text = card.title
        initiateTitleTextViewWithPlaceholder()
        setupPreviewImages()
        
        if let status = card.isTask{
            taskView.isHidden=false
            taskViewHeightConstraint.constant=30
            let taskConfig = UIImage.SymbolConfiguration(pointSize: 7, weight: .medium, scale: .small)
            if status{
                taskView.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 0.15)
                taskSymbolImage.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: taskConfig)
                taskSymbolImage.tintColor = UIColor.systemGreen
                taskStatusLabel.text = "Completed"
                taskStatusLabel.textColor = UIColor.systemGreen
            }else{
                taskView.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 0.15)
                taskSymbolImage.image = UIImage(systemName: "circle", withConfiguration: taskConfig)
                taskSymbolImage.tintColor = UIColor.systemOrange
                taskStatusLabel.text = "Pending"
                taskStatusLabel.textColor = UIColor.systemOrange
            }
        }else{
            taskView.isHidden=true
            taskViewHeightConstraint.constant=0
        }
        
        if card.tagColor==0{
            tagColorViewWidthConstraint.constant=0
        }else{
            tagColorViewWidthConstraint.constant=10
        }
        switch card.tagColor {
        case 1:
            tagColorView.backgroundColor = UIColor.systemPurple
        case 2:
            tagColorView.backgroundColor = UIColor.systemIndigo
        case 3:
            tagColorView.backgroundColor = UIColor.systemBlue
        case 4:
            tagColorView.backgroundColor = UIColor.systemTeal
        case 5:
            tagColorView.backgroundColor = UIColor.systemGreen
        case 6:
            tagColorView.backgroundColor = UIColor.systemYellow
        case 7:
            tagColorView.backgroundColor = UIColor.systemOrange
        case 8:
            tagColorView.backgroundColor = UIColor.systemPink
        case 9:
            tagColorView.backgroundColor = UIColor.systemRed
        default:
            tagColorView.backgroundColor = UIColor.systemGray
        }
        tagColorView.layer.opacity = 0.3
        
        for i in 1...4{
            previewImageViews[i].isHidden = card.showingPreview
        }
        checkListLabel.isHidden = !card.showingPreview
        
        if card.showingPreview{
            for ind in previewVerSpacingConstraints.indices{
                previewVerSpacingConstraints[ind].constant=6
            }
            previewIVHeightConstraint.constant=20
        }else{
            for ind in previewVerSpacingConstraints.indices{
                previewVerSpacingConstraints[ind].constant=0
            }
            previewIVHeightConstraint.constant=0
        }
//        UIView.animate(withDuration: 0 .4, animations: {
//            self.layoutIfNeeded()
//            self.delegate?.updateHeights()
//        })
//        self.delegate?.updateHeights()
        if card.checkList.items.count==0{
            checkListLabel.text="-"
        }else{
            var completed=0
            for item in card.checkList.items{
                if item.done{
                    completed+=1
                }
            }
            checkListLabel.text="\(completed)/\(card.checkList.items.count)"
        }
        if let schedDate = card.scheduledDate{
            let formatter = DateFormatter()
//            formatter.dateFormat = "d/M/yy, hh:mm a"
//            formatter.dateStyle = .medium
            formatter.dateFormat = "d/M, hh:mm a"
            calendarLabel.text = formatter.string(from: schedDate)
        }else{
            calendarLabel.text = "-"
        }
        if let remindDate = card.reminderDate{
            let formatter = DateFormatter()
            formatter.dateFormat = "d/M, hh:mm a"
//            formatter.dateStyle = .medium
            reminderLabel.text = formatter.string(from: remindDate)
        }else{
            reminderLabel.text = "-"
        }
        if card.linkURL.count>0{
            linkLabel.text = card.linkURL
        }else{
            linkLabel.text = "-"
        }
        
        if card.mediaLinks.count>0{
            let fileName = card.mediaLinks[0]
            DispatchQueue.global(qos: .background).async {
                if let url = try? FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                ).appendingPathComponent(fileName){
                    if let jsonData = try? Data(contentsOf: url){
                        if self.card.mediaLinks.count>0, self.card.mediaLinks[0]==fileName, let extract = imageData(json: jsonData){
                            let x=extract.data
                            if let image = UIImage(data: x){
                                DispatchQueue.main.async {
                                    self.previewImageView.image = image
                                }
                            }
                        }else{
                            print("couldnt get json from URL")
                        }
                    }
                }
            }
        }
        imageCountIV.image = UIImage(systemName: String(card.mediaLinks.count)+".circle.fill")
    }
    
    func setupPreviewImages(){
        if card.checkList.items.count == 0{
            previewImageViews[0].tintColor = .gray
        }else{
            previewImageViews[0].tintColor = .systemBlue
        }
        if card.scheduledDate == nil{
            previewImageViews[1].tintColor = .gray
            calendarPreviewSymbol.tintColor = .gray
        }else{
            previewImageViews[1].tintColor = .systemBlue
            calendarPreviewSymbol.tintColor = .systemBlue
        }
        if card.reminderDate == nil{
            previewImageViews[2].tintColor = .gray
            reminderPreviewSymbol.tintColor = .gray
        }else{
            previewImageViews[2].tintColor = .systemBlue
            reminderPreviewSymbol.tintColor = .systemBlue
        }
        if card.linkURL.count==0 {
            previewImageViews[3].tintColor = .gray
            linkPreviewSymbol.tintColor = .gray
        }else{
            previewImageViews[3].tintColor = .systemBlue
            linkPreviewSymbol.tintColor = .systemBlue
        }
        if card.mediaLinks.count == 0{
            previewImageViews[4].tintColor = .gray
        }else{
            previewImageViews[4].tintColor = .systemBlue
        }
    }
}
extension CardTableViewCell: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if textView==titleTextView{
            self.card.title=textView.text
            delegate?.updateHeights()
        }
        self.delegate?.updateCard(to: card)
    }
    //for placeholder
    func initiateTitleTextViewWithPlaceholder(){
        if titleTextView.text.isEmpty{
            titleTextView.text = "Add Title..."
            titleTextView.textColor = UIColor.systemGray
        }else{
            titleTextView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        initiateTitleTextViewWithPlaceholder()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView==titleTextView && textView.textColor == UIColor.systemGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}
extension CardTableViewCell: cardPreviewProtocol{
    func deleteCard(newCard: KanbanCard) {
        self.delegate?.deleteCard(newCard: newCard)
    }
    
    func saveCard(to newCard: KanbanCard) {
        self.card=newCard
        setupCard()
        delegate?.updateHeights()
        self.delegate?.updateCard(to: card)
    }
    
}

