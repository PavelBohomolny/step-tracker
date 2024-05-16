//
//  HealthMetric.swift
//  Step Tracker
//
//  Created by Pavel Bohomolnyi on 08/05/2024.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
