//
//  smallCard.swift
//  card2
//
//  Created by Kshitiz Sharma on 14/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation
import UIKit

struct SmallCard: Codable {
    var UniquIdentifier=UUID()
    var dateOfCompletion: Date?
    var dateOfConstruction = Date()
    var isDone = false{
        didSet{
            if self.isDone{
                dateOfCompletion=Date()
            }else{
                dateOfCompletion=nil
            }
        }
    }
    var title = "Title"
    var notes = ""
    var extraNotes = ""
    var url: URL?
    var reminderDate: Date?{
        //MARK: "WARNING USED FOR DEBUGGING, REMOVE LATER"
        didSet{
            if reminderDate != nil{
                dateOfCompletion=reminderDate
            }
        }
    }
//    var images = [UIImage]()
    
    enum priorityEnum: String {
        case Low
        case Medium
        case High
    }
    
//    enum priorityEnum
}
