//
//  addHabbitGoalPeriodTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class addHabbitGoalPeriodTableViewCell: UITableViewCell {
    var delegate: addHabiitVCProtocol?
    @IBOutlet weak var segment: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func segmentChanged(_ sender: Any) {
        switch segment.selectedSegmentIndex {
        case 0:
            delegate?.setHabitGoalPeriod(.daily)
        case 1:
            delegate?.setHabitGoalPeriod(.weekly)
        case 2:
            delegate?.setHabitGoalPeriod(.monthly)
        case 3:
            delegate?.setHabitGoalPeriod(.yearly)
        default:
            print("ERROR: unhandled index")
        }
    }

}
