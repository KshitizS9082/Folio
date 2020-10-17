//
//  Board.swift
//  Folio
//
//  Created by Kshitiz Sharma on 12/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation

class Board: Codable {
    var uid = UUID()
    var title: String
    var items: [KanbanCard]
    
    
    init(title: String, items: [KanbanCard]) {
        self.title = title
        self.items = items
    }
}

