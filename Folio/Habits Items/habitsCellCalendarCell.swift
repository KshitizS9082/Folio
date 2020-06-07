//
//  habitsCellCalendarCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 04/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation
import JTAppleCalendar
import UIKit
class habitsCellCalendarCell: JTAppleCell {
    
     @IBOutlet var dateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var dateBackgroundView: UIView!{
        didSet{
            dateBackgroundView.layer.cornerRadius=dateBackgroundView.layer.bounds.width/2
        }
    }
    @IBOutlet weak var countBackgroundView: UIView!{
        didSet{
            countBackgroundView.layer.cornerRadius=countBackgroundView.layer.bounds.width/2
        }
    }
    
}
