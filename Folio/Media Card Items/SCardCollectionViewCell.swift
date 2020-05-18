//
//  SCardCollectionViewCell.swift
//  card2
//
//  Created by Kshitiz Sharma on 29/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class SCardCollectionViewCell: UICollectionViewCell {

    
//    @IBOutlet weak var checkBox: UIImageView!
    
//    @IBOutlet weak var titleTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            contentView.leftAnchor.constraint(equalTo: leftAnchor),
//            contentView.rightAnchor.constraint(equalTo: rightAnchor),
//            contentView.topAnchor.constraint(equalTo: topAnchor),
//            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//        titleTextView.translatesAutoresizingMaskIntoConstraints=false
//        NSLayoutConstraint.activate([
//            titleTextView.leftAnchor.constraint(equalTo: checkBox.rightAnchor, constant: 6.0),
//            titleTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 6.0),
//            titleTextView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -6.0),
//            titleTextView.bottomAnchor.constraint(greaterThanOrEqualTo: checkBox.bottomAnchor)
//        ])
        
//        let screenWidth = UIScreen.main.bounds.width - 2*12
//        widthAnchor.constraint(equalToConstant: cardView.frame.width).isActive=true
//        heightAnchor.constraint(equalToConstant: cardView.frame.height).isActive=true
//        print("cv frame = \(cardView.frame)")
//        print("contentvie frame = \(contentView.frame)")
    }
    
    //forces the system to do one layout pass
    var isHeightCalculated: Bool = false
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if !isHeightCalculated {
            setNeedsLayout()
            layoutIfNeeded()
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var newFrame = layoutAttributes.frame
            newFrame.size.width = CGFloat(ceilf(Float(size.width)))
            layoutAttributes.frame = newFrame
            isHeightCalculated = true
        }
        return layoutAttributes
    }

}
