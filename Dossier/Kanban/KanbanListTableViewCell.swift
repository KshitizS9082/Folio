//
//  KanbanListTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 30/11/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class KanbanListTableViewCell: UITableViewCell, UITextFieldDelegate {

//    var pageListDelegate: pageListeProtocol?
    var delegate: KanbanListProtcol?
    var boardName: String?
    var fileName: String?{
        didSet{
            if let boardFileName = fileName{
                if let url = try? FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                ).appendingPathComponent(boardFileName){
                    if let jsonData = try? Data(contentsOf: url){
                        if let x = Kanban(json: jsonData){
                            self.kanban = x
                        }else{
                            print("WARNING: COULDN'T UNWRAP JSON DATA TO FIND kanbanData")
                        }
                    }
                    awakeFromNib()
                }
            }
        }
    }
    var kanban : Kanban?{
        didSet{
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            if let doc = kanban?.dateOfCreation{
                self.subtitleText.text = formatter.string(from: doc)
            }
            if let wallpath = self.kanban?.wallpaperPath{
                self.cardBGImageView.isHidden=false
                DispatchQueue.global(qos: .background).async {
                print("got wall path")
                    if let url = try? FileManager.default.url(
                        for: .documentDirectory,
                        in: .userDomainMask,
                        appropriateFor: nil,
                        create: true
                    ).appendingPathComponent(wallpath){
                        if let jsonData = try? Data(contentsOf: url){
                            if let extract = imageData(json: jsonData){
                                let x=extract.data
                                if let image = UIImage(data: x){
                                    print("got the background image")
                                    DispatchQueue.main.async {
                                        self.cardBGImageView.image=image
                                    }
                                }
                            }else{
                                print("couldnt get json from URL")
                            }
                        }
                    }
                }
            }else{
                self.cardBGImageView.isHidden=true
            }
        }
    }
//    @IBOutlet weak var describitngImage: UIImageView!
    @IBOutlet weak var cardBackgroundView: UIView!{
        didSet{
            //TODO: shaddow now working
            cardBackgroundView.layer.cornerRadius = 10
            cardBackgroundView.layer.masksToBounds=false
            cardBackgroundView.backgroundColor = .clear
            //Draw shaddow for layer
            cardBackgroundView.layer.shadowColor = UIColor.red.cgColor
            cardBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
            cardBackgroundView.layer.shadowRadius = 20.0
            cardBackgroundView.layer.shadowOpacity = 1
        }
    }
    @IBOutlet weak var cardBGImageView: UIImageView!{
        didSet{
            cardBGImageView.layer.cornerRadius = 10
            cardBGImageView.layer.masksToBounds=true
            cardBGImageView.backgroundColor = .clear
        }
    }
    @IBOutlet weak var cardBlurView: UIView!{
        didSet{
            cardBlurView.layer.cornerRadius = 10
            cardBlurView.layer.masksToBounds=true
            cardBlurView.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemThinMaterial)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = cardBlurView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cardBlurView.addSubview(blurEffectView)
        }
    }
    
    @IBOutlet weak var categoryImageView: UIImageView!{
        didSet{
            categoryImageView.layer.cornerRadius = 8
            //Draw shaddow for layer
            categoryImageView.layer.masksToBounds=false
            categoryImageView.layer.shadowColor = UIColor.gray.cgColor
            categoryImageView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            categoryImageView.layer.shadowRadius = 10.0
            categoryImageView.layer.shadowOpacity = 0.25
//            let smallConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium, scale: .small)
            let iconColor = [#colorLiteral(red: 0.886832118, green: 0.9455494285, blue: 0.9998298287, alpha: 1), #colorLiteral(red: 0.9906743169, green: 0.8905956149, blue: 0.8889676332, alpha: 1), #colorLiteral(red: 0.755782187, green: 1, blue: 0.8466194272, alpha: 1), #colorLiteral(red: 0.9186416268, green: 0.7921586633, blue: 0.9477668405, alpha: 1)].randomElement()
            self.categoryImageView.backgroundColor = iconColor
            self.categoryImageView.tintColor = iconColor?.darker(by: 50)
        }
    }
    
    @IBOutlet weak var titleTextField: UITextField!{
        didSet{
            titleTextField.delegate=self
        }
    }
//    @IBOutlet weak var subtitleText: UILabel!
    @IBOutlet weak var subtitleText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text{
            delegate?.editName(for: fileName!, to: text)
        }else{
            delegate?.editName(for: fileName!, to: "")
        }
    }
}
