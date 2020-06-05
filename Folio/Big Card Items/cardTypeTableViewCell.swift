//
//  cardTypeTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 05/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class cardTypeTableViewCell: UITableViewCell {
    var card = Card()
    var index = IndexPath(row: 0, section: 0)
    var delegate: newEditCardViewControllerProtocol?
    
    var cardTypePicker: UIPickerView? = nil
    var cardTypePickerData: [String] = [String]()
    
    @IBOutlet weak var typeValueLabel: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        switch card.type {
            case .Notes:
                typeValueLabel.text = "Notes"
            case .Drawing:
                typeValueLabel.text = "Drawing"
            case .CheckList:
                typeValueLabel.text = "Checklist"
        }
        setCardTypePickerView()
    }
    
    private func setCardTypePickerView(){
        cardTypePicker = UIPickerView()
        cardTypePickerData = ["Notes", "Drawing", "CheckList"]
        self.cardTypePicker?.delegate = self
        self.cardTypePicker?.dataSource = self
        
        typeValueLabel.inputView = cardTypePicker
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.backgroundColor = myBavkgoundColor
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Set", style: .done, target: self, action: #selector(doneCardTypeChange));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancleCardTypeChange));
        let centerButton = UIBarButtonItem(title: "Card Type", style: .plain, target: nil, action: nil)
        toolbar.setItems([cancelButton,spaceButton,centerButton,spaceButton,doneButton], animated: false)
        //        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        typeValueLabel.inputAccessoryView = toolbar
        cardTypePicker?.backgroundColor = myBavkgoundColor
    }
    @objc func doneCardTypeChange(){
        card.type = Card.cardType(rawValue: cardTypePickerData[(cardTypePicker?.selectedRow(inComponent: 0))!])!
//        typeValueLabel.text = cardTypePickerData[(cardTypePicker?.selectedRow(inComponent: 0))!]
        awakeFromNib()
        delegate?.updateCardType(to: card.type)
        self.endEditing(true)
    }
    @objc func cancleCardTypeChange(){
        self.endEditing(true)
    }
}
extension cardTypeTableViewCell{
    var myBavkgoundColor: UIColor{
        return UIColor(named: "myBackgroundColor") ?? #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
}
extension cardTypeTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cardTypePickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cardTypePickerData[row]
    }
    
    
}
