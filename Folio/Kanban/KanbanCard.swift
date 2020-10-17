//
//  KanbanCard.swift
//  Folio
//
//  Created by Kshitiz Sharma on 12/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation

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
    var time : Date? = nil
    var endTime : Date? = nil
    
    var savedPKData: Data?
    
    //if checkList==nul there is no checklist
    var checkList = CheckListData()
    
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
