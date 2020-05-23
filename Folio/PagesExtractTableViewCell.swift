//
//  pagesExtractTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 23/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class PagesExtractTableViewCell: UITableViewCell {

    @IBOutlet var extractCardList: [PageExtractSubview]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        for ind in extractCardList.indices{
            let card = extractCardList[ind]
            card.backgroundColor = #colorLiteral(red: 0.9839849829, green: 0.9880542423, blue: 0.9669427433, alpha: 1)
            switch ind {
            case 0:
                print(0)
                card.image.image = UIImage(systemName: "calendar.circle.fill")
                card.image.tintColor = .systemBlue
                card.textLablel.text = "Today"
                card.numberLabel.text = "4"
            case 1:
                print(1)
                card.image.image = UIImage(systemName: "clock.fill")
                card.image.tintColor = .systemYellow
                card.textLablel.text = "Scheduled"
                card.numberLabel.text = "32"
            case 2:
                print(2)
                card.image.image = UIImage(systemName: "tray.fill")
                card.image.tintColor = .systemGray
                card.textLablel.text = "All"
                card.numberLabel.text = "49"
            case 3:
                print(3)
                card.image.image = UIImage(systemName: "exclamationmark.circle.fill")
                card.image.tintColor = .systemRed
                card.textLablel.text = "Due"
                card.numberLabel.text = "5"
            default:
                print("didn't handle this extractCardListIndex")
            }
            card.layoutSubviews()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class PageExtractSubview: UIView{
    var image = UIImageView(image: UIImage(systemName: "calendar.circle.fill"))
    var textLablel = UILabel()
    var numberLabel = UILabel()
    
    override func layoutSubviews() {
        self.layer.cornerRadius=cornerradiuse
        if subviews.contains(image)==false{
            addSubview(image)
        }
        image.translatesAutoresizingMaskIntoConstraints=false
        [
            image.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: cornerradiuse),
            image.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: cornerradiuse),
            image.widthAnchor.constraint(equalToConstant: viewsizes),
            image.heightAnchor.constraint(equalToConstant: viewsizes)
            ].forEach { (cst) in
                cst.isActive=true
        }
        if subviews.contains(textLablel)==false{
            addSubview(textLablel)
        }
        textLablel.translatesAutoresizingMaskIntoConstraints=false
        [
            textLablel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: cornerradiuse),
            textLablel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: cornerradiuse),
            textLablel.heightAnchor.constraint(equalToConstant: viewsizes)
            ].forEach { (cst) in
                cst.isActive=true
        }
        textLablel.textColor = UIColor.systemGray
//        textLablel.text = "Today"
        
        if subviews.contains(numberLabel)==false{
            addSubview(numberLabel)
        }
        numberLabel.translatesAutoresizingMaskIntoConstraints=false
        [
            numberLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -cornerradiuse),
            numberLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: cornerradiuse)
            ].forEach { (cst) in
                cst.isActive=true
        }
        numberLabel.textColor = UIColor.black
//        numberLabel.attributedText = NSAttributedString(string: "22", attributes: numberFontAttributes)
//        numberLabel.text = "22"
        numberLabel.font = numberLabelFont
        numberLabel.sizeToFit()
    }
}
extension PageExtractSubview{
    var numberFontAttributes: [NSAttributedString.Key: Any]{
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 30),
            .foregroundColor: UIColor.systemBlue
        ]
        return attributes
    }
    var numberLabelFont: UIFont{
//         return UIFont(name: "SnellRoundhand-Black", size: 40)!
        return UIFont.boldSystemFont(ofSize: 40)
    }
    var cornerradiuse: CGFloat{
        return 10
    }
    var viewsizes: CGFloat{
        return 40
    }
}
