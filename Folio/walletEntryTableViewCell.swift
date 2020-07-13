//
//  walletEntryTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 03/07/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class walletEntryTableViewCell: UITableViewCell {
    var wEntry: walletEntry?
    var delegate: walletProtocol?
    var index = IndexPath(row: 0, section: 0)

    @IBOutlet weak var categoryImageView: UIImageView!{
        didSet{
            categoryImageView.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var extraImageView: UIImageView!{
        didSet{
            extraImageView.layer.masksToBounds=true
            extraImageView.contentMode = .scaleAspectFill
            extraImageView.layer.cornerRadius = 3.5
        }
    }
    @IBOutlet weak var imageWidhtConstraint: NSLayoutConstraint!
//    @IBOutlet weak var imageTitleDistanceConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let entry = wEntry{
            
            let locale = Locale.current
            let currencySymbol = locale.currencySymbol!
            if entry.value<0{
                let valueString = "-"+currencySymbol+String(-entry.value)
                let amountText = NSMutableAttributedString.init(string: valueString)
//                amountText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22),
//                                          NSAttributedString.Key.foregroundColor: UIColor.systemGray2],
//                                         range: NSMakeRange(1, 1))
                amountText.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemGray2],
                range: NSMakeRange(1, 1))
                self.valueLabel.attributedText = amountText
            }else{
                let valueString = currencySymbol+String(entry.value)
                let amountText = NSMutableAttributedString.init(string: valueString)
                amountText.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemGray2],
                                         range: NSMakeRange(0, 1))
                self.valueLabel.attributedText = amountText
            }
            
            
            if let fileName = entry.imageURL{
                if let url = try? FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                ).appendingPathComponent(fileName){
                    if let jsonData = try? Data(contentsOf: url){
                        if let extract = imageData(json: jsonData){
                            let x=extract.data
                            if let image = UIImage(data: x){
                                DispatchQueue.main.async {
//                                    self.imageWidhtConstraint.constant=50
//                                    self.imageTitleDistanceConstraint.constant=6
                                    self.extraImageView.image = image
                                    self.extraImageView.isUserInteractionEnabled=true
                                    self.extraImageView.setupImageViewer()
                                    self.delegate?.updated(indexpath: self.index, animated: false)
                                }
                            }
                        }else{
                            print("couldnt get json from URL")
                        }
                    }
                }
            }else{
//                self.imageWidhtConstraint.constant=0
//                self.imageTitleDistanceConstraint.constant=0
                self.extraImageView.isUserInteractionEnabled=false
                self.delegate?.updated(indexpath: self.index, animated: false)
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            dateLabel.text = formatter.string(from: entry.date)
            switch entry.category {
                    case .foodDrinks:
                        self.categoryImageView.image = UIImage(systemName: "questionmark")
                        self.titleLabel.text="Food-Drinks"
                    case .shopping:
                        self.categoryImageView.image = UIImage(systemName: "cart.fill")
                        self.titleLabel.text="Shopping"
                    case .housing:
                        self.categoryImageView.image = UIImage(systemName: "house.fill")
                        self.titleLabel.text="Housing"
                    case .transport:
                        self.categoryImageView.image = UIImage(systemName: "tram.fill")
                        self.titleLabel.text="Transport"
                    case .vehilcle:
                        self.categoryImageView.image = UIImage(systemName: "car.fill")
                        self.titleLabel.text="Vehicle"
                    case .entertainment:
                        self.categoryImageView.image = UIImage(systemName: "film")
                        self.titleLabel.text="Entertainment"
                    case .commuinicationPC:
                        self.categoryImageView.image = UIImage(systemName: "desktopcomputer")
                        self.titleLabel.text="Computer"
                    case .loanInterest:
                        self.categoryImageView.image = UIImage(systemName: "dollarsign.circle")
                        self.titleLabel.text="Loan"
                    case .taxes:
                        self.categoryImageView.image = UIImage(systemName: "dollarsign.circle")
                        self.titleLabel.text="Taxes"
                    case .financial:
                        self.categoryImageView.image = UIImage(systemName: "dollarsign.circle")
                        self.titleLabel.text="Financial"
                    case .income:
                        self.categoryImageView.image = UIImage(systemName: "dollarsign.circle")
                        self.titleLabel.text="Income"
                    case .others:
                        self.categoryImageView.image = UIImage(systemName: "tag")
                        self.titleLabel.text="Others"
                    }
        }
    }

}
