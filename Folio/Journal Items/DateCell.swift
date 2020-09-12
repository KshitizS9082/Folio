//
//  DateCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 25/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation
import JTAppleCalendar
import UIKit
class DateCell: JTAppleCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    var isPresentView = UIView()
    override func awakeFromNib() {
        selectedView.layer.cornerRadius=selectedView.layer.frame.width/2
        if subviews.contains(isPresentView)==false{
            addSubview(isPresentView)
        }
        isPresentView.translatesAutoresizingMaskIntoConstraints=false
        [
            isPresentView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            isPresentView.topAnchor.constraint(equalTo: selectedView.bottomAnchor, constant: 1),
            isPresentView.widthAnchor.constraint(equalToConstant: 4),
            isPresentView.heightAnchor.constraint(equalTo: isPresentView.widthAnchor)
            ].forEach { (cst) in
                cst.isActive=true
        }
        isPresentView.layer.cornerRadius=2
        isPresentView.backgroundColor = UIColor(named: "calendarAccent") ?? UIColor.red
        isPresentView.isHidden=true
    }
}
