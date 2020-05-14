//
//  checkListItem.swift
//  card2
//
//  Created by Kshitiz Sharma on 07/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation
struct checkListItem: Codable {
    var isCompleted: Bool?
    var title: String?
    var notes: String?
    var url: URL?
}
