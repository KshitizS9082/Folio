//
//  weekExtractFromDate.swift
//  Folio
//
//  Created by Kshitiz Sharma on 03/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation

extension Date{
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    var startOfWeek: Date {
        let calendar = Calendar.current
        let components: DateComponents? = calendar.dateComponents([.weekday, .year, .month, .day], from: self)
        var modifiedComponent = components
        modifiedComponent?.day = (components?.day ?? 0) - ((components?.weekday ?? 0) - 1)

        return calendar.date(from: modifiedComponent!)!
    }
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
    //warning: gives last day of previous year maybe
    var startOfYear: Date {
        let components = Calendar.current.dateComponents([.year], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
}
