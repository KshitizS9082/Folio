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
}
class CardTableViewCell: UITableViewCell {
    var card = KanbanCard()
    var row: Int?
    var delegate: tableCardDeletgate?
    
    @IBOutlet var previewVerSpacingConstraints: [NSLayoutConstraint]!
    @IBOutlet weak var previewIVHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!{
        didSet{
            previewImageView.layer.cornerRadius = 6
        }
    }
    @IBOutlet weak var imageCountIV: UIImageView!
    
    @IBOutlet weak var cardBackgroundView: UIView!{
        didSet{
            cardBackgroundView.layer.cornerRadius=5
            //Draw shaddow for layer
            cardBackgroundView.layer.shadowColor = UIColor.gray.cgColor
            cardBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.3)
            cardBackgroundView.layer.shadowRadius = 0.7
            cardBackgroundView.layer.shadowOpacity = 0.4
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
    }
    func setupCard(){
        titleTextView.text = card.title
        initiateTitleTextViewWithPlaceholder()
        setupPreviewImages()
        
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
//        UIView.animate(withDuration: 0.4, animations: {
//            self.layoutIfNeeded()
//            self.delegate?.updateHeights()
//        })
//        self.delegate?.updateHeights()
        if let schedDate = card.scheduledDate{
            let formatter = DateFormatter()
            formatter.dateFormat = "d/M/yy, hh:mm a"
            calendarLabel.text = formatter.string(from: schedDate)
        }else{
            calendarLabel.text = "-"
        }
        if let remindDate = card.reminderDate{
            let formatter = DateFormatter()
            formatter.dateFormat = "d/M/yy, hh:mm a"
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
            previewImageViews[0].tintColor = .blue
        }
        if card.scheduledDate == nil{
            previewImageViews[1].tintColor = .gray
        }else{
            previewImageViews[1].tintColor = .blue
        }
        if card.reminderDate == nil{
            previewImageViews[2].tintColor = .gray
        }else{
            previewImageViews[2].tintColor = .blue
        }
        if card.linkURL.count==0 {
            previewImageViews[3].tintColor = .gray
        }else{
            previewImageViews[3].tintColor = .blue
        }
        if card.mediaLinks.count == 0{
            previewImageViews[4].tintColor = .gray
        }else{
            previewImageViews[4].tintColor = .blue
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
    func saveCard(to newCard: KanbanCard) {
        self.card=newCard
        setupCard()
        delegate?.updateHeights()
        self.delegate?.updateCard(to: card)
    }
    
}

