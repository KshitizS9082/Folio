//
//  Board.swift
//  Folio
//
//  Created by Kshitiz Sharma on 12/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation
struct Kanban: Codable{
//    var boards = [Board]()
//    var boards = [
//            Board(title: "first", items: [KanbanCard(title: "Database Migration"),KanbanCard(title: "Schema Design"),KanbanCard(title: "Storage Management"),KanbanCard(title: "Model Abstraction")]),
//            Board(title: "second", items: [KanbanCard(title: "Database Migration"),KanbanCard(title: "Schema Design"),KanbanCard(title: "Storage Management"),KanbanCard(title: "Model Abstraction")]),
//            Board(title: "third", items: []),
//            Board(title: "fourth", items: [KanbanCard(title: "Database Migration"),KanbanCard(title: "Schema Design"),KanbanCard(title: "Storage Management"),KanbanCard(title: "Model Abstraction")])
//        ]
    var wallpaperPath: String?
    var dateOfCreation = Date()
    var boards = [Board]()
    var commands = [Command]()
    init(){
    }
    init?(json: Data){
        if let newValue = try? JSONDecoder().decode(Kanban.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}
class Board: Codable {
    var uid = UUID()
    var title: String
    var items: [KanbanCard]
    
    
    init(title: String, items: [KanbanCard]) {
        self.title = title
        self.items = items
    }
}

