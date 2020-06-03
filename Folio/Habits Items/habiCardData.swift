//
//  habiCardData.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation

struct habitCardData: Codable {
    var UniquIdentifier=UUID()
    var constructionDate = Date()
    var targetDate: Date?
    var title = ""
    enum HabitStyle: String, Codable {
        case Build
        case Quit
    }
    var habitStyle = HabitStyle.Build
    enum recurencePeriod: String, Codable  {
        case daily
        case weekly
        case monthly
        case yearly
    }
    var habitGoalPeriod = recurencePeriod.daily
    
    var goalCount = 0.0
    enum ReminderTime: String, Codable {
        case morning
        case noon
        case night
        case fifteenMinute
        case oneHour
        case notSet
    }
    var reminderValue = ReminderTime.notSet
    
    var entriesList : [Date: Double] = [:]
    
    init(){
    }
    init?(json: Data){
        if let newValue = try? JSONDecoder().decode(habitCardData.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}


