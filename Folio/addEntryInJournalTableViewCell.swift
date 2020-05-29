//
//  addEntryInJournalTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 29/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class addEntryInJournalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardBackgrounView: UIView!
    
    @IBOutlet weak var addTextIV: UIImageView!{
        didSet{
            addTextIV.isUserInteractionEnabled=true
            addTextIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addText)))
        }
    }
    @IBOutlet weak var addMediaIV: UIImageView!{
        didSet{
            addMediaIV.isUserInteractionEnabled=true
            addMediaIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addMediaCell)))
        }
    }
    @IBOutlet weak var addLocation: UIImageView!{
        didSet{
            addLocation.isUserInteractionEnabled=true
            addLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addLocationEntry)))
        }
    }
    
    var addCardDelegate: addCardInJournalProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardBackgrounView.layer.cornerRadius = ivCornerRadius
        cardBackgrounView.backgroundColor = cardBackgrounViewColor
        
        addTextIV.tintColor = ivTintColor
        addTextIV.backgroundColor = ivBackgroundColor
        addTextIV.layer.cornerRadius = ivCornerRadius
        addMediaIV.tintColor = ivTintColor
        addMediaIV.backgroundColor = ivBackgroundColor
        addMediaIV.layer.cornerRadius = ivCornerRadius
        addLocation.tintColor = ivTintColor
        addLocation.backgroundColor = ivBackgroundColor
        addLocation.layer.cornerRadius = ivCornerRadius
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func addText(){
        addCardDelegate?.addWrittenEntry()
    }
    @objc func addMediaCell(){
        addCardDelegate?.addMediaCell()
    }
    @objc func addLocationEntry(){
        addCardDelegate?.addLocationEntry()
    }

}
extension addEntryInJournalTableViewCell{
    var cardBackgrounViewColor: UIColor{
        return UIColor(named: "calendarColor") ?? UIColor.red
    }
    var ivTintColor: UIColor{
        return UIColor(named: "subMainTextColor") ?? UIColor.red
    }
    var ivBackgroundColor: UIColor{
        return .clear
    }
    var ivCornerRadius: CGFloat{
        return 15
    }
}
