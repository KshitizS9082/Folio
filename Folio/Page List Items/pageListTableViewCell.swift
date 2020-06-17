//
//  pageListTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 23/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class pageListTableViewCell: UITableViewCell, UITextFieldDelegate {

    var pageListDelegate: pageListeProtocol?
    var myIndexPath: IndexPath?
    @IBOutlet weak var describitngImage: UIImageView!
    @IBOutlet weak var cardBackgroundView: UIView!{
        didSet{
            cardBackgroundView.layer.cornerRadius = 10
            //Draw shaddow for layer
            cardBackgroundView.layer.shadowColor = UIColor.gray.cgColor
            cardBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
            cardBackgroundView.layer.shadowRadius = 3.0
            cardBackgroundView.layer.shadowOpacity = 0.2
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        pageListDelegate?.setPageTitle(for: myIndexPath!, to: titleTextField.text ?? "")
        return true
    }
}
