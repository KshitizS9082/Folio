//
//  KanbanListTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 30/11/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class KanbanListTableViewCell: UITableViewCell, UITextFieldDelegate {

//    var pageListDelegate: pageListeProtocol?
    var delegate: KanbanListProtcol?
    var boardName: String?
    var fileName: String?
//    @IBOutlet weak var describitngImage: UIImageView!
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
    
    @IBOutlet weak var titleTextField: UITextField!{
        didSet{
            titleTextField.delegate=self
        }
    }
//    @IBOutlet weak var subtitleText: UILabel!
    @IBOutlet weak var subtitleText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text{
            delegate?.editName(for: fileName!, to: text)
        }else{
            delegate?.editName(for: fileName!, to: "")
        }
    }
}
