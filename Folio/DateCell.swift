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
        selectedView.layer.cornerRadius=15
        if subviews.contains(isPresentView)==false{
            addSubview(isPresentView)
        }
        isPresentView.translatesAutoresizingMaskIntoConstraints=false
        [
            isPresentView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            isPresentView.topAnchor.constraint(equalTo: selectedView.bottomAnchor, constant: 2),
            isPresentView.widthAnchor.constraint(equalToConstant: 5),
            isPresentView.heightAnchor.constraint(equalTo: isPresentView.widthAnchor)
            ].forEach { (cst) in
                cst.isActive=true
        }
        isPresentView.layer.cornerRadius=2.5
        isPresentView.backgroundColor = #colorLiteral(red: 1, green: 0.2156862745, blue: 0.3725490196, alpha: 0.9215994056)
        isPresentView.isHidden=true
    }
    
}
