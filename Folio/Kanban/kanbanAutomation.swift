//
//  kanbanAutomation.swift
//  Folio
//
//  Created by Kshitiz Sharma on 16/12/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation

struct Trigger: Codable {
    enum TriggerTypeEnum: String, Codable {
        case xBeforeSchedule
        case ifFromBoard
        case ifTilteIs
        case ifTitleContains
        case ifTaskType
        case ifChecklistHasAllComplete
        case ifChecklistHasAllIncomplete
        case ifHasTag
        case ifHasURLSetTo
        case onDate
    }
    var triggerType: TriggerTypeEnum
    
    var daysBeforeSchedule: Int?
    var hoursBeforeSchedule: Int?
    
    var fromBoard: UUID?
    
    var titleString: String?
    
    var taskType: Bool?
    
    var tagColor: Int=0
    
    var hasURL: Bool = false
    
    var scheduledDate: Date?
}

struct Action: Codable {
    enum ActionTypeEnum: String, Codable {
        case moveCardToPostionOf
        case deleteCard
        case setDueDateToNone
        case advanceDueDateByX
        case setTagTo
        case setTaskTo
        case setChecklistItemsTo
//        case deleteAllChecklist
//        case deleteCompletedChecklist
        case deleteChecklistItemsWhichAre
        case setTitleTo
        case appendToStartOfTitle
    }
    var actionType: ActionTypeEnum
    enum PositionType: String, Codable {
        case top
        case bottom
    }
    var position: PositionType?
    var tragetBoardName: String? //Note: null = move in self
    
    var newDueDate: Date? //Note: null = unset due date
    
    var xDays: Int?
    var xHours: Int?
    
    var tagColor: Int=0
    
    var taskType: Bool?
    
    var checkListValue: Bool? //NOTE: null = both
    
    var newTitleString = ""
    
    var startTitleString = ""
}

struct Command: Codable{
    var name = ""
    var uniqueIdentifier = UUID()
    var enabled = true
    var condition = [Trigger]()
    var execution = [Action]()
}
