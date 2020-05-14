//
//  Card.swift
//  card2
//
//  Created by Kshitiz Sharma on 07/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation
import PencilKit

struct Card: Codable {
    var UniquIdentifier: UUID?
    var type: cardType = cardType.CheckList
    enum cardType: String, Codable {
        case CheckList
        case Notes
        case Drawing
    }
    var isCompleted: Bool = false
    var Heading: String? = nil
    var notes: String = ""
//    var savedpkDrawing = PKDrawing()
    var savedPKData = Data()
//    var savedpkDrawing: Data?
    var time : Date? = nil
    var endTime : Date? = nil
    var reminder: Date? = nil//Design
    
    var label: labelStruct? = nil
    var checkList = [checkListItem]()
    
    
}
struct labelStruct: Codable{
    var value: String? = nil
//    var colour: UIColor? = nil
}
