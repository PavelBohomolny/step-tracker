//
//  HealthKitManager.swift
//  Step Tracker
//
//  Created by Pavel Bohomolnyi on 08/05/2024.
//

import Foundation
import HealthKit
import Observation

@Observable class HealthKitManager {
    let store = HKHealthStore()
    
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
}
