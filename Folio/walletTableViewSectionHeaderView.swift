//
//  walletTableViewSectionHeaderView.swift
//  Folio
//
//  Created by Kshitiz Sharma on 03/07/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class walletTableViewSectionHeaderView: UIView {
    let label = UILabel()
    let valueLabel = UILabel()
    override func layoutSubviews() {
        if subviews.contains(label)==false{
            addSubview(label)
        }
        [
            label.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 15),
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -6)
//            ,label.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 25)
            ].forEach { (cst) in
                cst.isActive=true
        }
        if subviews.contains(valueLabel)==false{
            addSubview(valueLabel)
        }
        [
            valueLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -25),
            valueLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            valueLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -15)
            //            ,label.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 25)
            ].forEach { (cst) in
                cst.isActive=true
        }
        valueLabel.layer.backgroundColor = UIColor.systemPink.cgColor
        valueLabel.layer.cornerRadius=valueLabel.layer.frame.height/2.0
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
