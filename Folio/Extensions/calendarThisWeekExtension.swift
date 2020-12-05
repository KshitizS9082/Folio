//
//  calendarThisWeekExtension.swift
//  Folio
//
//  Created by Kshitiz Sharma on 05/12/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation
extension Calendar {
    func isDayInCurrentWeek(date: Date) -> Bool? {
        let currentComponents = Calendar.current.dateComponents([.weekOfYear], from: Date())
        let dateComponents = Calendar.current.dateComponents([.weekOfYear], from: date)
        guard let currentWeekOfYear = currentComponents.weekOfYear, let dateWeekOfYear = dateComponents.weekOfYear else { return nil }
        return currentWeekOfYear == dateWeekOfYear
    }
}
