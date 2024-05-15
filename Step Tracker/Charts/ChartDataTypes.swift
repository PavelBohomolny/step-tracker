//
//  ChartDataTypes.swift
//  Step Tracker
//
//  Created by Pavel Bohomolnyi on 15/05/2024.
//

import Foundation

struct WeekdayChartData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
