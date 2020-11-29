//
//  KanbanCard.swift
//  Folio
//
//  Created by Kshitiz Sharma on 12/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation
import UIKit

struct KanbanCard: Codable{
    var UniquIdentifier=UUID()
    var title: String = ""
    var notes: String? = nil
    var linkURL = ""
    var scheduledDate: Date?
    var dateOfConstruction = Date()
    
    var showingPreview=false
    //if isTask==NULL it isn't a task
    var isTask: Bool?
    
    var reminderDate: Date?
//    var time : Date? = nil
//    var endTime : Date? = nil
    
    var savedPKData: Data?
    
    //if checkList==nul there is no checklist
    var checkList = CheckListData()
    
    var tagColor: Int=0
    
    var mediaLinks = [String]()
    
}

struct CheckListData: Codable {
    var title = ""
    var items =  [CheckListItem]()
}
struct CheckListItem: Codable {
    var uid = UUID()
    var item: String = ""
    var done: Bool = false
}
struct Color : Codable {
    var red : CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0

    var uiColor : UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    init(uiColor : UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}
