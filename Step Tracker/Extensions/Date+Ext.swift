//
//  Date+Ext.swift
//  Step Tracker
//
//  Created by Pavel Bohomolnyi on 15/05/2024.
//

import Foundation

extension Date {
    var weekdayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
}
