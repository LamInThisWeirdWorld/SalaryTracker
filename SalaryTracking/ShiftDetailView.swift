//
//  ShiftDetailView.swift
//  SalaryTracking
//
//  Created by Nguyen Ngoc Thanh Lam on 12/7/2025.
//

import SwiftUI

struct shiftInfo: Equatable {
    var startTIme: Date
    var endTime: Date
    var totalHours: Double {
        return endTime.timeIntervalSince(startTIme) / 3600
    }
    var payPerHour: Double
    var totalSalary: Double {
        return totalHours * payPerHour
    }
}

struct ShiftDetailView: View {
    static var defaultStartTime: Date {
        var component = DateComponents()
        component.hour = 10
        component.minute = 30
        return Calendar.current.date(from: component) ?? .now
    }
    
    static var defaultEndTime: Date {
        var component = DateComponents()
        component.hour = 17
        component.minute = 0
        return Calendar.current.date(from: component) ?? .now
    }
    
    @State private var shiftStart = defaultStartTime
    @State private var shiftEnd = defaultEndTime
    
    var body: some View {
        Form {
            VStack {
                HStack {
                    Text("Shift starts at:")
                    Spacer()
                    DatePicker("Please select shift start time", selection: $shiftStart, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                HStack {
                    Text("Shift ends at:")
                    Spacer()
                    DatePicker("Please select shift start time", selection: $shiftEnd, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
            }
        }
        .navigationTitle("Edit shift details")
    }
}

#Preview {
    ShiftDetailView()
}
