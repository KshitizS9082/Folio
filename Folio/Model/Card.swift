//
//  Card.swift
//  card2
//
//  Created by Kshitiz Sharma on 07/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation
//import PencilKit

struct Card: Codable {
    var UniquIdentifier=UUID()
    var dateOfConstruction = Date()
    var dateOfCompletion: Date?
    var type: cardType = cardType.Notes
    enum cardType: String, Codable {
        case CheckList
        case Notes
        case Drawing
    }
    var isCompleted: Bool = false{
        didSet{
            if self.isCompleted{
                dateOfCompletion=Date()
            }else{
                dateOfCompletion=nil
            }
        }
    }
    var Heading: String? = nil
    var notes: String = ""

    var savedPKData = Data()

    var time : Date? = nil
    var endTime : Date? = nil
    var reminder: Date? = nil{//DesignP
        //MARK: "WARNING USED FOR DEBUGGING, REMOVE LATER"
        didSet{
            if reminder != nil{
                dateOfCompletion=reminder
            }
        }
    }
    
    var label: labelStruct? = nil
    var checkList = [checkListItem]()
    
    
}
struct labelStruct: Codable{
    var value: String? = nil
//    var colour: UIColor? = nil
}
