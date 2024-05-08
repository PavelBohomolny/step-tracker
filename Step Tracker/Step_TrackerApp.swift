//
//  Step_TrackerApp.swift
//  Step Tracker
//
//  Created by Pavel Bohomolnyi on 30/04/2024.
//

import SwiftUI

@main
struct Step_TrackerApp: App {
    
    let hkManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(hkManager)
        }
    }
}
