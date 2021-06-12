//
//  addHabbitStyleTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class addHabbitStyleTableViewCell: UITableViewCell {
    var delegate: addHabiitVCProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var segment: UISegmentedControl!
    @IBAction func segmentChange(_ sender: Any) {
        switch segment.selectedSegmentIndex {
        case 0:
            delegate?.setHabitStyle(.Build)
        case 1:
            delegate?.setHabitStyle(.Quit)
        default:
            print("ERROR: unhandled index")
        }
    }
    

}
