//
//  kanbanAutomation.swift
//  Folio
//
//  Created by Kshitiz Sharma on 16/12/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation

struct Trigger: Codable {
    var describingString: String{
            get{
                switch triggerType {
                case TriggerTypeEnum.xBeforeSchedule:
                    return "\(daysBeforeSchedule!) Days, \(hoursBeforeSchedule!) Hours before scheduled"
                case TriggerTypeEnum.ifFromBoard:
                    return "If from Board with title \(String(describing: fromBoard))"
                case TriggerTypeEnum.ifTilteIs:
                    return "If title is \(titleString!)"
                case TriggerTypeEnum.ifTitleContains:
                    return "If title contains \(titleString!)"
                case TriggerTypeEnum.ifTaskType:
                    if let tt = taskType{
                        if tt{
                            return "If is complete task"
                        }else{
                            return "If is incomplete task"
                        }
                    }else{
                        return "If is not a task"
                    }
                case TriggerTypeEnum.ifChecklistHasAllComplete:
                    return "If checklist has all elements complete"
                case TriggerTypeEnum.ifChecklistHasAllIncomplete:
                    return "If checklist has all elements incomplete"
                case TriggerTypeEnum.ifHasTag:
                    var color = "None"
                    switch tagColor {
                    case 0:
                        return "Has no tag set"
                    case 1:
                        color="Purple"
                    case 2:
                        color="Indigo"
                    case 3:
                        color="Blue"
                    case 4:
                        color="Teal"
                    case 5:
                        color="Green"
                    case 6:
                        color="Yellow"
                    case 7:
                        color="Orange"
                    case 8:
                        color="Pink"
                    case 9:
                        color="Red"
                    default:
                        color="Unknown"
                    }
                    return "If has tag color set to \(color)"
                case TriggerTypeEnum.ifHasURLSetTo:
                    return "If has URL set"
                case TriggerTypeEnum.onDate:
                    return "If is scheduled on date \(String(describing: scheduledDate))"
                default:
                    return "Describing string"
                }
            }
        }

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
    
    var fromBoard: String?
    
    var titleString: String?
    
    var taskType: Bool?
    
    var tagColor: Int=0
    
    var hasURL: Bool = false
    
    var scheduledDate: Date?
}

struct Action: Codable {
    var describingString: String{
            get{
                switch actionType {
    //            case ActionTypeEnum.moveCardToPostionOf:
    //            case ActionTypeEnum.deleteCard
                case ActionTypeEnum.setDueDateToNone:
                    return "Set Scheduled Date to none"
                case ActionTypeEnum.advanceDueDateByX:
                    return "Advace Scheduled Date by \(xDays!) Days, \(xHours!) Hours"
                case ActionTypeEnum.setTagTo:
                    var color = "None"
                    switch tagColor {
                    case 0:
                        return "Unset any tag color"
                    case 1:
                        color="Purple"
                    case 2:
                        color="Indigo"
                    case 3:
                        color="Blue"
                    case 4:
                        color="Teal"
                    case 5:
                        color="Green"
                    case 6:
                        color="Yellow"
                    case 7:
                        color="Orange"
                    case 8:
                        color="Pink"
                    case 9:
                        color="Red"
                    default:
                        color="Unknown"
                    }
                    return "Set tag color to \(color)"
                case ActionTypeEnum.setTaskTo:
                    if let tt = taskType{
                        if tt{
                            return "Set to complete task"
                        }else{
                            return "Set to incomplete task"
                        }
                    }else{
                        return "Set to not a task"
                    }
                case ActionTypeEnum.setChecklistItemsTo:
                    if checkListValue!{
                        return "Set Checklist items to Complete"
                    }else{
                        return "Set Checklist items to Incomplete"
                    }
                case ActionTypeEnum.deleteChecklistItemsWhichAre:
                    if let clv=checkListValue{
                        if clv{
                            return "Delete Checklist items which are Complete"
                        }else{
                            return "Delete Checklist items which are Incomplete"
                        }
                    }else{
                        return "Delete all Checklist items"
                    }
                case ActionTypeEnum.setTitleTo:
                    return "Set Card Title to \(newTitleString)"
    //            case ActionTypeEnum.appendToStartOfTitle
                default:
                    return "Yet to handle describing string"
                }
            }
        }
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
