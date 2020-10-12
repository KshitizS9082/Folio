//
//  CardTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 12/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//


import UIKit

class CardTableViewCell: UITableViewCell {
    var card = KanbanCard()
    var row: Int?
    var delegate: tableCardDeletgate?
    @IBOutlet weak var cardBackgroundView: UIView!{
        didSet{
            cardBackgroundView.layer.cornerRadius=10
            //Draw shaddow for layer
            cardBackgroundView.layer.shadowColor = UIColor.gray.cgColor
            cardBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            cardBackgroundView.layer.shadowRadius = 1.0
            cardBackgroundView.layer.shadowOpacity = 0.8
        }
    }
    @IBOutlet weak var titleTextView: UITextView!{
        didSet{
            titleTextView.delegate=self
        }
    }
    
    @IBOutlet var previewImageViews: [UIImageView]!
    
    @IBAction func handlePreviewButtonClick(_ sender: UIButton) {
        
    }
    func setupCard(){
        titleTextView.text = card.title
        setupPreviewImages()
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
        if card.linkURL == nil{
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
}
extension CardTableViewCell: cardPreviewProtocol{
    func saveCard(to newCard: KanbanCard) {
        print("save card inside cardtvc")
        self.card=newCard
        setupCard()
        delegate?.updateHeights()
    }
    
    
}

