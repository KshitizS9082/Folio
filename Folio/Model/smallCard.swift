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
    var isDone = false
    var title = "Title"
    var notes = ""
    var extraNotes = ""
    var url: URL?
    var reminderDate: Date?
//    var images = [UIImage]()
    
    enum priorityEnum: String {
        case Low
        case Medium
        case High
    }
    
//    enum priorityEnum
}
