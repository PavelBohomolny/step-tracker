//
//  StepBarChart.swift
//  Step Tracker
//
//  Created by Pavel Bohomolnyi on 15/05/2024.
//

import SwiftUI
import Charts

struct StepBarChart: View {
    @State private var rawSelectedDate: Date?
    @State private var isExpanded = false
    @State private var stepCountInput: String = ""
    @State private var showAverages = false
    
    var selectedStat: HealthMetricContext
    var chartData: [HealthMetric]
    
    /// Allow the user to set up steps goal
    var stepsGoal: Double {
        if let steps = Double(stepCountInput) {
            return steps
        } else {
            return 10_000
        }
    }
    
    var avgStepCount: Double {
        guard !chartData.isEmpty else { return 0 }
        let totalSteps = chartData.reduce(0) { $0 + $1.value }
        return totalSteps/Double(chartData.count)
    }
    
    var selectedHealthMetric: HealthMetric? {
        guard let rawSelectedDate else { return nil }
        return chartData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
    }
    
    // TODO: This value could be generic from the user input as a daily goal
    /// For example, the user could add his daily goal(10k steps) and this line would be like a goal measure
    /// As an option, we can add a configure button ⚙️ to allow users to add some specific settings, like:
    /// - daily goal
    /// - colour of the widgets
    var body: some View {
        
        // TODO: Create a separate file with settings
        // It will be implemented later with a different app
        // Depends on the app dashboard settings
       
        // MARK: - Settings
        
        HStack {
            Label("Settings", systemImage: "gear")
                .font(.title3.bold())
                .foregroundStyle(.pink)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .rotationEffect(
                    .degrees(isExpanded ? 90 : .zero)
                )
                .animation(.easeInOut, value: isExpanded)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
        
        if isExpanded {
            VStack {
                HStack {
                    Text("Add goal line")
                        .font(.callout)
                    Spacer()
                    Toggle("", isOn: $showAverages)
                        .labelsHidden()
                }
                
                if showAverages {
                    HStack {
                        Text("What is your daily step goal?")
                            .font(.callout)
                        Spacer()
                        TextField("10.000", text: $stepCountInput)
                            .frame(width: 55, height: 25)
                            .keyboardType(.numberPad)
                            .padding(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.secondary, lineWidth: 1)
                            )
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
            .transition(.opacity)
        }
        
        VStack {
            NavigationLink(value: selectedStat) {
                HStack {
                    VStack(alignment: .leading) {
                        Label("Steps", systemImage: "figure.walk")
                            .font(.title3.bold())
                            .foregroundStyle(.pink)
                        
                        Text("Avg: \(Int(avgStepCount)) steps")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            Chart {
                if let selectedHealthMetric {
                    RuleMark(x: .value("Selected Metric", selectedHealthMetric.date, unit: .day))
                        .foregroundStyle(Color.secondary.opacity(0.3))
                        .offset(y: -10)
                        .annotation(
                            position: .top,
                            spacing: 0,
                            overflowResolution: .init(x: .fit(to: .chart), y: .disabled)
                        ) {
                            annotationView
                        }
                }
                
                if showAverages {
                    RuleMark(y: .value("Average", stepsGoal))
                        .foregroundStyle(Color.secondary)
                        .lineStyle(.init(lineWidth: 1, dash: [5]))
                }
                
                ForEach(chartData) { steps in
                    BarMark(
                        x: .value("Date", steps.date, unit: .day),
                        y: .value("Steps", steps.value)
                    )
                    .foregroundStyle(Color.pink.gradient)
                    .opacity(rawSelectedDate == nil || steps.date == selectedHealthMetric?.date ? 1.0 : 0.3)
                }
            }
            .frame(height: 150)
            .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
            .chartXAxis {
                AxisMarks {
                    AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(Color.secondary.opacity(0.3))
                    
                    AxisValueLabel((value.as(Double.self) ?? 0).formatted(.number.notation(.compactName)))
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
    
    var annotationView: some View {
        VStack(alignment: .leading) {
            Text(selectedHealthMetric?.date ?? .now, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text(selectedHealthMetric?.value ?? 0, format: .number.precision(.fractionLength(0)))
                .fontWeight(.heavy)
                .foregroundStyle(.pink)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
        )
    }
}

#Preview {
    StepBarChart(selectedStat: .steps, chartData: MockData.steps)
}
