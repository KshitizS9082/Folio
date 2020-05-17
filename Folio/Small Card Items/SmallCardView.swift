//
//  SmallCardView.swift
//  Folio
//
//  Created by Kshitiz Sharma on 16/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class SmallCardView: UIView {
    var card = SmallCard()
    var isEditting = false
    
    var checkBox = UIImageView()
       private func configureCheckBox(){
           checkBox.translatesAutoresizingMaskIntoConstraints=false
           checkBox.isUserInteractionEnabled=true
           if self.subviews.contains(checkBox)==false{
               addSubview(checkBox)
           }
           [
               checkBox.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: cornerRadius),
               checkBox.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: cornerRadius),
               checkBox.widthAnchor.constraint(equalToConstant: checkBoxDimensions),
               checkBox.heightAnchor.constraint(equalToConstant: checkBoxDimensions)
               ].forEach { (constraint) in
                   constraint.isActive=true
           }
           if(card.isDone){
               checkBox.image = UIImage(systemName: "largecircle.fill.circle")
           }else{
               checkBox.image = UIImage(systemName: "circle")
           }
           let tap = UITapGestureRecognizer(target: self, action: #selector(handleCheckboxTap))
           checkBox.addGestureRecognizer(tap)
       }
       @objc private func handleCheckboxTap(){
           card.isDone = !card.isDone
       }
    override func layoutSubviews() {
        self.backgroundColor = cardColour
        configureCheckBox()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension SmallCardView{
    var cornerRadius: CGFloat {
        return 6
    }
    var checkBoxDimensions: CGFloat{
        return 30
    }
    var cardColour: UIColor{
        return UIColor.white
    }
}
