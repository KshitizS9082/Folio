//
//  addHabbitGoalCountTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class addHabbitGoalCountTableViewCell: UITableViewCell {
var delegate: addHabiitVCProtocol?
    var goalCount = 1.0
    @IBOutlet weak var goalCountLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var decimalStepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        decimalStepper.stepValue=0.10
        stepper.value = goalCount
//        decimalStepper.value=goalCount.truncatingRemainder(dividingBy: 1)
        goalCountLabel.text = String(Int(goalCount))
        // Initialization code
        
    }
    @IBAction func stepperClick(_ sender: UIStepper) {
//        let val = stepper.value+decimalStepper.value
//        goalCount=(val*10).rounded()/10.0
        goalCount = floor(stepper.value)
        awakeFromNib()
        delegate?.setHabitGoalCount(goalCount)
    }
    @IBAction func decimalStepperClick(_ sender: Any) {
        let val = stepper.value+decimalStepper.value
        goalCount=(val*10).rounded()/10.0
        awakeFromNib()
        delegate?.setHabitGoalCount(goalCount)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
