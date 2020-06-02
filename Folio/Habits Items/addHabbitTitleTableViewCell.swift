//
//  addHabbitTitleTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class addHabbitTitleTableViewCell: UITableViewCell, UITextFieldDelegate {
    var delegate: addHabiitVCProtocol?
    @IBOutlet weak var titleTextFeild: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleTextFeild.delegate=self
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.setTitle(titleTextFeild.text!)
    }
}
