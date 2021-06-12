//
//  journalMediaTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 30/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class journalMediaTableViewCell: UITableViewCell, UITextViewDelegate{
    var index = IndexPath(row: 0, section: 0)
    var delegate: addCardInJournalProtocol?
    var imageFileNames = [String]()
//     var allImages = [UIImage]()
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!{
        didSet{
            notesLabel.isUserInteractionEnabled=true
            notesLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelctTextView)))
        }
    }
    @IBOutlet weak var cardBackgroundView: UIView!{
        didSet{
            cardBackgroundView.layer.cornerRadius = 10
            cardBackgroundView.layer.masksToBounds=true
            cardBackgroundView.backgroundColor = .clear
//            //Draw shaddow for layer
//            cardBackgroundView.layer.shadowColor = UIColor.systemGray6.cgColor
//            cardBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//            cardBackgroundView.layer.shadowRadius = 3.0
//            cardBackgroundView.layer.shadowOpacity = 0.2
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemThinMaterial)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = cardBackgroundView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cardBackgroundView.addSubview(blurEffectView)
        }
    }
    @IBOutlet weak var notesIsEditingTextView: UITextView!{
        didSet{
            notesIsEditingTextView.delegate=self
            notesIsEditingTextView.isHidden=true
        }
    }
    @IBOutlet weak var mediaImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        allImages.removeAll()
//        allImages = Array(repeating: UIImage(), count: imageFileNames.count)
        // Initialization code
        self.mediaImageView.tintColor = ivTintColor
        self.mediaImageView.layer.cornerRadius=ivCornerRadius
        self.mediaImageView.isUserInteractionEnabled=true
        self.mediaImageView.contentMode = .scaleAspectFill
//        self.mediaImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImage)))
        self.mediaImageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action:  #selector(getImage)))
        print("image count = \(imageFileNames.count)")
        if self.imageFileNames.count>0{
            let fileName = self.imageFileNames[0]
            DispatchQueue.global(qos: .background).async {
                if let url = try? FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                ).appendingPathComponent(fileName){
                    if let jsonData = try? Data(contentsOf: url){
                        if let extract = imageData(json: jsonData){
                            if let image = UIImage(data: extract.data){
                                DispatchQueue.main.async {
                                    self.mediaImageView.image=image
//                                    if let pos = self.imageFileNames.firstIndex(of: fileName){
//                                        if pos==0{
//                                            self.mediaImageView.setupImageViewer(images: [image])
//                                        }
//                                    }
                                        self.mediaImageView.setupImageViewer(images: [image])
                                }
                            }else{
                                print("couldn't get UIImage from extrated data, check if sure this file doesn't exist and if so delete it from array")
                            }
                        }else{
                            print("couldnt get json from URL")
                        }
                    }
                }
            }
        }else{
            self.mediaImageView.image = UIImage(systemName: "camera")
            self.mediaImageView.gestureRecognizers?.removeAll()
            self.mediaImageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action:  #selector(getImage)))
        }
//        var urlList = [URL]()
//        for file in imageFileNames{
//            if let url = try? FileManager.default.url(
//                for: .documentDirectory,
//                in: .userDomainMask,
//                appropriateFor: nil,
//                create: true
//            ).appendingPathComponent(file){
//                urlList.append(url)
//            }
//        }
//        self.mediaImageView.setupImageViewer(urls: urlList)
    }
    
    @IBOutlet weak var showFullViewImageView: UIImageView!{
        didSet{
            showFullViewImageView.isUserInteractionEnabled=true
            showFullViewImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFullJournal)))
        }
    }
    @objc func showFullJournal(){
        delegate?.showJournalFullView(at: index)
    }
    @objc func didSelctTextView() {
        print("didselect in setSelected")
        notesLabel.isHidden=true
        notesIsEditingTextView.isHidden=false
        notesIsEditingTextView.font = notesLabel.font
        notesIsEditingTextView.text = notesLabel.text
        notesIsEditingTextView.becomeFirstResponder()
    }
    @objc func showImage(){
        print("show image")
    }
    @objc func getImage(){
        delegate?.getJournalMedia(at: index)
    }
//    func deleteImage(){
//        if
//    }
    func textViewDidEndEditing(_ textView: UITextView) {
        notesLabel.text = notesIsEditingTextView.text
        notesLabel.isHidden=false
        notesIsEditingTextView.isHidden=true
//        delegate?.updateJournalNotesEntry(at: index, with:  notesIsEditingTextView.text)
        delegate?.updateJournalMediasNotesEntry(at: index, with: notesIsEditingTextView.text)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text=="\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
extension journalMediaTableViewCell{
    var ivTintColor: UIColor{
        return UIColor(named: "subMainTextColor") ?? UIColor.red
    }
    var ivCornerRadius: CGFloat{
        return 15
    }
}

