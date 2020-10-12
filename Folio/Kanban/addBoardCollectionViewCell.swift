//
//  addBoardCollectionViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 12/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class addBoardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var addBoardButton: UIButton!{
        didSet{
            self.addBoardButton.layer.cornerRadius = 10.0
        }
    }
    
}
