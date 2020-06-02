//
//  habiCardData.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation

struct habitCardData {
    var UniquIdentifier=UUID()
    var constructionDate = Date()
    var targetDate: Date?
    var title = ""
    enum HabitStyle {
        case Build
        case Quit
    }
    var habitStyle = HabitStyle.Build
    enum recurencePeriod {
        case daily
        case weekly
        case monthly
        case yearly
    }
    var habitGoalPeriod = recurencePeriod.daily
    
    var goalCount = 0.0
    enum ReminderTime{
        case morning
        case noon
        case night
        case fifteenMinute
        case oneHour
        case notSet
    }
    var reminderValue = ReminderTime.notSet
}
