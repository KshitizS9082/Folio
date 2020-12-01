//
//  journalHabitTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 21/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class journalHabitTableViewCell: UITableViewCell {
    var index = IndexPath(row: 0, section: 0)
    var delegate: addCardInJournalProtocol?
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    @IBOutlet weak var cardBackgroundView: UIView!{
        didSet{
            cardBackgroundView.layer.cornerRadius = 10
            cardBackgroundView.layer.masksToBounds=true
            cardBackgroundView.backgroundColor = .clear
//            //Draw shaddow for layer
//            cardBackgroundView.layer.shadowColor = UIColor.systemGray6.cgColor
//            cardBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//            cardBackgroundView.layer.shadowRadius = 3.0
//            cardBackgroundView.layer.shadowOpacity = 0.2
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemThinMaterial)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = cardBackgroundView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cardBackgroundView.addSubview(blurEffectView)
        }
    }
    @IBOutlet weak var showFullViewImageView: UIImageView!{
        didSet{
            showFullViewImageView.isUserInteractionEnabled=true
//            showFullViewImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFullJournal)))
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
